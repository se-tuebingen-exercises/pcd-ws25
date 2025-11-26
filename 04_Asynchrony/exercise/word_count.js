import { readFile } from 'node:fs/promises';

const urls = (await readFile('books.csv', 'utf8')).trim().split('\n');

