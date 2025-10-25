import { clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs) {
    return twMerge(clsx(inputs));
}

export function isSameUrl(url1, url2) {
    return resolveUrl(url1) === resolveUrl(url2);
}

export function resolveUrl(url) {
    return typeof url === 'string' ? url : url.url;
}
