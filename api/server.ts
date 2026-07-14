import express, { Request, Response } from 'express';
import mysql from 'mysql2/promise';
import cors from 'cors';
import crypto from 'crypto';
import os from 'os';

const app = express();
app.use(cors());
app.use(express.json());

const PORT = Number(process.env.PORT ?? 3000);

const getLocalIPv4 = (): string | undefined => {
  const interfaces = os.networkInterfaces();

  for (const addresses of Object.values(interfaces)) {
    for (const address of addresses ?? []) {
      if (address.family === 'IPv4' && !address.internal) {
        return address.address;
      }
    }
  }

  return undefined;
};

// Local database configuration.
const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'travis',
  waitForConnections: true,
  connectionLimit: 10,
});

const md5Hash = (text: string): string =>
  crypto.createHash('md5').update(text).digest('hex');

app.get('/api/test', (_req: Request, res: Response) => {
  res.json({
    status: 'The Node.js backend is alive!',
    time: new Date().toLocaleTimeString(),
  });
});

app.get('/api/status', async (_req: Request, res: Response): Promise<void> => {
  try {
    await pool.query('SELECT 1');
    res.json({ server_connected: true, db_connected: true });
  } catch (error) {
    console.error('Database status check failed:', error);
    res.json({ server_connected: true, db_connected: false });
  }
});

app.post('/api/login', async (req: Request, res: Response): Promise<void> => {
  const { email, password } = req.body;

  try {
    const [rows]: any = await pool.query(
      'SELECT * FROM users WHERE email = ?',
      [email]
    );

    if (rows.length === 0) {
      res.status(400).json({ error: 'Wrong email or password.' });
      return;
    }

    const user = rows[0];
    const hashedInputPassword = md5Hash(password);

    if (hashedInputPassword !== user.password) {
      res.status(400).json({ error: 'Wrong email or password.' });
      return;
    }

    res.json({
      success: true,
      user: {
        id: user.user_id,
        full_name: user.full_name,
        email: user.email,
        role: user.role,
        status: user.status,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: (error as Error).message });
  }
});

app.post('/api/register', async (req: Request, res: Response): Promise<void> => {
  const { name, email, password } = req.body;

  try {
    const hashedPassword = md5Hash(password);
    await pool.query(
      'INSERT INTO users (full_name, email, password) VALUES (?, ?, ?)',
      [name, email, hashedPassword]
    );
    res.status(201).json({ success: true });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: (error as Error).message });
  }
});

app.get('/api/profile/:id', async (req: Request, res: Response): Promise<void> => {
  const id = Number(req.params.id);

  if (!Number.isInteger(id) || id < 1) {
    res.status(400).json({ error: 'A valid user ID is required.' });
    return;
  }

  try {
    const [rows]: any = await pool.query(
      'SELECT user_id, full_name, email, role, status FROM users WHERE user_id = ?',
      [id]
    );

    if (rows.length === 0) {
      res.status(404).json({ error: 'User not found.' });
      return;
    }

    const [[stats]]: any = await pool.query(
      `SELECT
         COUNT(*) AS payments_processed,
         COALESCE(SUM(amount_paid), 0) AS total_collected
       FROM payments
       WHERE received_by = ? AND payment_status = 'completed'`,
      [id]
    );

    res.json({
      success: true,
      user: rows[0],
      paymentsProcessed: Number(stats.payments_processed ?? 0),
      totalCollected: Number(stats.total_collected ?? 0),
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: (error as Error).message });
  }
});

app.put('/api/profile', async (req: Request, res: Response): Promise<void> => {
  const { user_id, full_name, email } = req.body;
  const id = Number(user_id);
  const normalizedEmail = typeof email === 'string' ? email.trim().toLowerCase() : '';
  const name = typeof full_name === 'string' ? full_name.trim() : '';

  if (!Number.isInteger(id) || id < 1 || !name || !normalizedEmail) {
    res.status(400).json({ error: 'A valid name, email, and user ID are required.' });
    return;
  }

  try {
    const [result]: any = await pool.query(
      'UPDATE users SET full_name = ?, email = ? WHERE user_id = ?',
      [name, normalizedEmail, id]
    );

    if (result.affectedRows === 0) {
      res.status(404).json({ error: 'User not found.' });
      return;
    }

    res.json({ success: true, user: { id, full_name: name, email: normalizedEmail } });
  } catch (error: any) {
    if (error?.code === 'ER_DUP_ENTRY') {
      res.status(409).json({ error: 'That email address is already in use.' });
      return;
    }

    console.error(error);
    res.status(500).json({ error: error?.message ?? 'Unable to update profile.' });
  }
});

app.put('/api/profile/password', async (req: Request, res: Response): Promise<void> => {
  const { user_id, current_password, new_password } = req.body;
  const id = Number(user_id);

  if (!Number.isInteger(id) || id < 1 || !current_password || !new_password) {
    res.status(400).json({ error: 'Current password and new password are required.' });
    return;
  }

  try {
    const [rows]: any = await pool.query('SELECT password FROM users WHERE user_id = ?', [id]);

    if (rows.length === 0) {
      res.status(404).json({ error: 'User not found.' });
      return;
    }

    if (md5Hash(current_password) !== rows[0].password) {
      res.status(400).json({ error: 'Current password is incorrect.' });
      return;
    }

    await pool.query('UPDATE users SET password = ? WHERE user_id = ?', [
      md5Hash(new_password),
      id,
    ]);

    res.json({ success: true });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: (error as Error).message });
  }
});

app.get('/api/dashboard', async (_req: Request, res: Response): Promise<void> => {
  try {
    const [[violationCounts]]: any = await pool.query(`
      SELECT
        COUNT(*) AS total_violations,
        SUM(status = 'pending') AS pending_violations,
        SUM(status = 'paid') AS paid_violations
      FROM violations
    `);

    const [[collections]]: any = await pool.query(`
      SELECT
        COALESCE(SUM(CASE WHEN DATE(payment_date) = CURDATE() THEN amount_paid ELSE 0 END), 0) AS todays_collections,
        COALESCE(SUM(CASE WHEN YEAR(payment_date) = YEAR(CURDATE()) AND MONTH(payment_date) = MONTH(CURDATE()) THEN amount_paid ELSE 0 END), 0) AS monthly_collections
      FROM payments
      WHERE payment_status = 'completed'
    `);

    const [recentPayments]: any = await pool.query(`
      SELECT p.payment_id, p.amount_paid, p.payment_date, p.payment_method,
             v.ticket_number, v.driver_name
      FROM payments p
      JOIN violations v ON v.violation_id = p.violation_id
      ORDER BY p.payment_date DESC
      LIMIT 5
    `);

    const [pendingViolations]: any = await pool.query(`
      SELECT violation_id, ticket_number, driver_name, penalty_amount, violation_date
      FROM violations
      WHERE status = 'pending'
      ORDER BY violation_date DESC
      LIMIT 5
    `);

    const [dailyRows]: any = await pool.query(`
      SELECT DATE(payment_date) AS day, SUM(amount_paid) AS total
      FROM payments
      WHERE payment_status = 'completed' AND payment_date >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)
      GROUP BY DATE(payment_date)
    `);
    const dailyByDate = new Map(
      dailyRows.map((r: any) => {
        const key = r.day instanceof Date ? r.day.toISOString().slice(0, 10) : String(r.day).slice(0, 10);
        return [key, Number(r.total)];
      })
    );
    const dailyCollection = Array.from({ length: 7 }, (_, i) => {
      const d = new Date();
      d.setDate(d.getDate() - (6 - i));
      const key = d.toISOString().slice(0, 10);
      return {
        label: d.toLocaleDateString('en-US', { weekday: 'short' }),
        value: dailyByDate.get(key) ?? 0,
      };
    });

    const [monthlyRows]: any = await pool.query(`
      SELECT MONTH(payment_date) AS month, SUM(amount_paid) AS total
      FROM payments
      WHERE payment_status = 'completed' AND YEAR(payment_date) = YEAR(CURDATE())
      GROUP BY MONTH(payment_date)
    `);
    const monthlyByNumber = new Map(monthlyRows.map((r: any) => [Number(r.month), Number(r.total)]));
    const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const monthlyCollection = monthNames.map((label, i) => ({
      label,
      value: monthlyByNumber.get(i + 1) ?? 0,
    }));

    const [statusRows]: any = await pool.query(`
      SELECT payment_status, COUNT(*) AS count
      FROM payments
      GROUP BY payment_status
    `);
    const statusColors: Record<string, string> = {
      completed: '#0d9488',
      pending: '#d97706',
      failed: '#dc2626',
      refunded: '#64748b',
    };
    const paymentStatusDistribution = statusRows.map((r: any) => ({
      label: r.payment_status,
      value: Number(r.count),
      color: statusColors[r.payment_status] ?? '#94a3b8',
    }));

    res.json({
      success: true,
      totalViolations: Number(violationCounts.total_violations ?? 0),
      pendingViolations: Number(violationCounts.pending_violations ?? 0),
      paidViolations: Number(violationCounts.paid_violations ?? 0),
      todaysCollections: Number(collections.todays_collections ?? 0),
      monthlyCollections: Number(collections.monthly_collections ?? 0),
      recentPayments,
      pendingPayments: pendingViolations,
      dailyCollection,
      monthlyCollection,
      paymentStatusDistribution,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: (error as Error).message });
  }
});

app.get('/api/users', async (_req: Request, res: Response): Promise<void> => {
  try {
    const [rows] = await pool.query('SELECT * FROM users');
    res.json({ success: true, users: rows });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: (error as Error).message });
  }
});

app.listen(PORT, '0.0.0.0', () => {
  const localIp = getLocalIPv4();
  const host = localIp ?? 'localhost';
  console.log(`API Server running at http://${host}:${PORT}`);
});
