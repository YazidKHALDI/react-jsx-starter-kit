// Credit: https://usehooks-ts.com/
import { useCallback, useState } from 'react';

export function useClipboard() {
    const [copiedText, setCopiedText] = useState(null);

    const copy = useCallback(async (text) => {
        if (!navigator?.clipboard) {
            console.warn('Clipboard not supported');

            return false;
        }

        try {
            await navigator.clipboard.writeText(text);
            setCopiedText(text);

            return true;
        }
        catch (error) {
            console.warn('Copy failed', error);
            setCopiedText(null);

            return false;
        }
    }, []);

    return [copiedText, copy];
}

