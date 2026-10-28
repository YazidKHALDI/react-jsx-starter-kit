import { clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs) {
    return twMerge(clsx(inputs));
}

export function toUrl(url) {
    return typeof url === 'string' ? url : url.url;
}

