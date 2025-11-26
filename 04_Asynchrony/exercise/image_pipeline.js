import { readFile, mkdir, writeFile } from 'node:fs/promises';
import sharp from 'sharp';

await mkdir('out', { recursive: true });

async function readUrls(filename) {
    return (await readFile(filename, 'utf8')).trim().split('\n');
}

async function downloadImage(url) {
    try {
        const response = await fetch(url);
        const buffer = Buffer.from(await response.arrayBuffer());
        return buffer;
    } catch (e) {
        console.error('Failed to download:', url, e.message);
        return null;
    }
}

async function toGrayscale(imageBuffer) {
    return await sharp(imageBuffer).grayscale().toBuffer();
}

async function saveImage(buffer, filename) {
    await writeFile(filename, buffer);
}

