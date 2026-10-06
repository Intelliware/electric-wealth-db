// Shared logic for the database scripts. No dependencies: uses Node's built-in SQLite (node:sqlite).
import { DatabaseSync } from 'node:sqlite';
import { existsSync, mkdirSync, readdirSync, readFileSync, rmSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

export const repoRoot = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const migrationsDir = join(repoRoot, 'migrations');
const seedDir = join(repoRoot, 'seed');

/**
 * Resolves the database file path. Precedence:
 *   1. --db <path> command-line argument
 *   2. DB_PATH environment variable
 *   3. data/electric-wealth.db inside this repo
 */
export function resolveDbPath(argv = process.argv.slice(2)) {
  const flag = argv.indexOf('--db');
  if (flag !== -1 && argv[flag + 1]) return resolve(argv[flag + 1]);
  if (process.env.DB_PATH) return resolve(process.env.DB_PATH);
  return join(repoRoot, 'data', 'electric-wealth.db');
}

function openDatabase(dbPath) {
  mkdirSync(dirname(dbPath), { recursive: true });
  const db = new DatabaseSync(dbPath);
  db.exec('PRAGMA foreign_keys = ON;');
  return db;
}

/** Lists .sql files in a directory, sorted by name (001_..., 002_..., ...). */
function listSqlFiles(dir) {
  return readdirSync(dir)
    .filter((f) => f.endsWith('.sql'))
    .sort()
    .map((name) => ({ name, sql: readFileSync(join(dir, name), 'utf8') }));
}

function inTransaction(db, fn) {
  db.exec('BEGIN;');
  try {
    fn();
    db.exec('COMMIT;');
  } catch (err) {
    db.exec('ROLLBACK;');
    throw err;
  }
}

/** Applies migrations that are not yet recorded in schema_migrations. */
export function migrate(dbPath) {
  const db = openDatabase(dbPath);
  try {
    db.exec(`CREATE TABLE IF NOT EXISTS schema_migrations (
      version     TEXT PRIMARY KEY,
      applied_at  TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now'))
    );`);
    const applied = new Set(db.prepare('SELECT version FROM schema_migrations').all().map((r) => r.version));
    const pending = listSqlFiles(migrationsDir).filter((m) => !applied.has(m.name));
    for (const m of pending) {
      inTransaction(db, () => {
        db.exec(m.sql);
        db.prepare('INSERT INTO schema_migrations (version) VALUES (?)').run(m.name);
      });
      console.log(`  migrated  ${m.name}`);
    }
    console.log(pending.length ? `Applied ${pending.length} migration(s).` : 'Schema is up to date.');
  } finally {
    db.close();
  }
}

/** Loads seed data. Refuses to run twice unless force is set (use db:reset instead). */
export function seed(dbPath, { force = false } = {}) {
  const db = openDatabase(dbPath);
  try {
    const { count } = db.prepare('SELECT COUNT(*) AS count FROM users').get();
    if (count > 0 && !force) {
      console.log(`Database already has ${count} user(s); skipping seed. Run "npm run db:reset" to start fresh.`);
      return;
    }
    const files = listSqlFiles(seedDir);
    inTransaction(db, () => {
      for (const f of files) {
        db.exec(f.sql);
        console.log(`  seeded    ${f.name}`);
      }
    });
    console.log(`Loaded ${files.length} seed file(s).`);
  } finally {
    db.close();
  }
}

/** Deletes the database file and rebuilds it from migrations + seed. */
export function reset(dbPath) {
  for (const suffix of ['', '-wal', '-shm', '-journal']) {
    if (existsSync(dbPath + suffix)) rmSync(dbPath + suffix);
  }
  console.log(`Recreating ${dbPath}`);
  migrate(dbPath);
  seed(dbPath);
}

/** Prints applied migrations and row counts per table. */
export function status(dbPath) {
  if (!existsSync(dbPath)) {
    console.log(`No database at ${dbPath}. Run "npm run db:reset".`);
    return;
  }
  const db = openDatabase(dbPath);
  try {
    console.log(`Database: ${dbPath}\n`);
    const applied = db.prepare('SELECT version, applied_at FROM schema_migrations ORDER BY version').all();
    const files = listSqlFiles(migrationsDir).map((m) => m.name);
    console.log('Migrations:');
    for (const name of files) {
      const row = applied.find((a) => a.version === name);
      console.log(`  ${row ? 'applied ' : 'PENDING '} ${name}${row ? `  (${row.applied_at})` : ''}`);
    }
    const tables = db
      .prepare("SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%' ORDER BY name")
      .all();
    console.log('\nRow counts:');
    for (const { name } of tables) {
      const { n } = db.prepare(`SELECT COUNT(*) AS n FROM "${name}"`).get();
      console.log(`  ${name.padEnd(22)} ${n}`);
    }
  } finally {
    db.close();
  }
}
