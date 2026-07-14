import mysql from 'mysql2/promise';

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'travis',
});

const AMOUNT_TIERS = [200, 300, 500, 750, 1000, 1500, 2000, 3000, 5000];
const METHODS = ['cash', 'card', 'online', 'cheque', 'mobile_wallet', 'other'];
const STATUS_WEIGHTS = [
  ['completed', 85],
  ['pending', 6],
  ['failed', 5],
  ['refunded', 4],
];

const pick = (arr) => arr[Math.floor(Math.random() * arr.length)];

function pickWeighted(weights) {
  const total = weights.reduce((sum, [, w]) => sum + w, 0);
  let roll = Math.random() * total;
  for (const [value, weight] of weights) {
    roll -= weight;
    if (roll <= 0) return value;
  }
  return weights[0][0];
}

function randomDateWithinDays(daysAgo) {
  const now = new Date();
  const past = new Date(now.getTime() - daysAgo * 24 * 60 * 60 * 1000);
  const time = past.getTime() + Math.random() * (now.getTime() - past.getTime());
  return new Date(time);
}

async function main() {
  const [existing] = await pool.query('SELECT COUNT(*) AS c FROM payments');
  if (existing[0].c > 0) {
    console.log(`payments table already has ${existing[0].c} rows — skipping seed.`);
    await pool.end();
    return;
  }

  const [violations] = await pool.query(
    "SELECT violation_id FROM violations WHERE status = 'paid' ORDER BY RAND() LIMIT 150"
  );
  const [users] = await pool.query('SELECT user_id FROM users');
  const userIds = users.map((u) => u.user_id);

  const rows = [];

  // Spread most payments across the last 120 days.
  for (const { violation_id } of violations) {
    const amount = pick(AMOUNT_TIERS) + Math.floor(Math.random() * 5) * 20;
    rows.push([
      violation_id,
      amount,
      pickWeighted(STATUS_WEIGHTS),
      randomDateWithinDays(120),
      pick(userIds),
      pick(METHODS),
      `OR-${violation_id}-${Math.floor(1000 + Math.random() * 9000)}`,
    ]);
  }

  // Guarantee visible activity for "today" and "this week" stat cards.
  const recentSample = violations.slice(0, 8);
  for (const { violation_id } of recentSample) {
    const amount = pick(AMOUNT_TIERS);
    rows.push([
      violation_id,
      amount,
      'completed',
      randomDateWithinDays(1),
      pick(userIds),
      pick(METHODS),
      `OR-${violation_id}-${Math.floor(1000 + Math.random() * 9000)}`,
    ]);
  }

  for (const row of rows) {
    await pool.query(
      `INSERT INTO payments (violation_id, amount_paid, payment_status, payment_date, received_by, payment_method, receipt_reference)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      row
    );
  }

  console.log(`Inserted ${rows.length} payment rows.`);
  await pool.end();
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
