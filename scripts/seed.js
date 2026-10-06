import { seed, resolveDbPath } from './lib.js';

seed(resolveDbPath(), { force: process.argv.includes('--force') });
