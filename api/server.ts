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
    status: 'Buhay ang Node.js backend ko!',
    oras: new Date().toLocaleTimeString(),
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
      },
    });
  } catch (error) {
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
    res.status(500).json({ error: (error as Error).message });
  }
});

app.put('/api/profile', async (req: Request, res: Response): Promise<void> => {
  const { user_id, first_name, middle_initial, last_name, email } = req.body;
  const id = Number(user_id);
  const normalizedEmail = typeof email === 'string' ? email.trim().toLowerCase() : '';
  const name = [first_name, middle_initial, last_name]
    .filter((part) => typeof part === 'string' && part.trim())
    .map((part) => part.trim())
    .join(' ');

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

    res.status(500).json({ error: error?.message ?? 'Unable to update profile.' });
  }
});

app.get('/api/users', async (_req: Request, res: Response): Promise<void> => {
  try {
    const [rows] = await pool.query('SELECT * FROM users');
    res.json({ success: true, users: rows });
  } catch (error) {
    res.status(500).json({ error: (error as Error).message });
  }
});

app.listen(PORT, '0.0.0.0', () => {
  const localIp = getLocalIPv4();
  const host = localIp ?? 'localhost';
  console.log(`API Server running at http://${host}:${PORT}`);
});
