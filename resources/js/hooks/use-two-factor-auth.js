import { useCallback, useMemo, useState } from 'react';
import { qrCode, recoveryCodes, secretKey } from '@/routes/two-factor';

export const OTP_MAX_LENGTH = 6;

const fetchJson = async (url) => {
    const response = await fetch(url, {
        headers: { Accept: 'application/json' },
    });

    if (!response.ok) {
        throw new Error(`Failed to fetch: ${response.status}`);
    }

    return response.json();
};

export const useTwoFactorAuth = () => {
    const [qrCodeSvg, setQrCodeSvg] = useState(null);
    const [manualSetupKey, setManualSetupKey] = useState(null);
    const [recoveryCodesList, setRecoveryCodesList] = useState([]);
    const [errors, setErrors] = useState([]);

    const hasSetupData = useMemo(() => qrCodeSvg !== null && manualSetupKey !== null, [qrCodeSvg, manualSetupKey]);

    const fetchQrCode = useCallback(async () => {
        try {
            const { svg } = await fetchJson(qrCode.url());
            setQrCodeSvg(svg);
        }
        catch {
            setErrors((prev) => [...prev, 'Failed to fetch QR code']);
            setQrCodeSvg(null);
        }
    }, []);

    const fetchSetupKey = useCallback(async () => {
        try {
            const { secretKey: key } = await fetchJson(secretKey.url());
            setManualSetupKey(key);
        }
        catch {
            setErrors((prev) => [...prev, 'Failed to fetch a setup key']);
            setManualSetupKey(null);
        }
    }, []);

    const clearErrors = useCallback(() => {
        setErrors([]);
    }, []);

    const clearSetupData = useCallback(() => {
        setManualSetupKey(null);
        setQrCodeSvg(null);
        clearErrors();
    }, [clearErrors]);

    const fetchRecoveryCodes = useCallback(async () => {
        try {
            clearErrors();
            const codes = await fetchJson(recoveryCodes.url());
            setRecoveryCodesList(codes);
        }
        catch {
            setErrors((prev) => [...prev, 'Failed to fetch recovery codes']);
            setRecoveryCodesList([]);
        }
    }, [clearErrors]);

    const fetchSetupData = useCallback(async () => {
        try {
            clearErrors();
            await Promise.all([fetchQrCode(), fetchSetupKey()]);
        }
        catch {
            setQrCodeSvg(null);
            setManualSetupKey(null);
        }
    }, [clearErrors, fetchQrCode, fetchSetupKey]);

    return {
        qrCodeSvg,
        manualSetupKey,
        recoveryCodesList,
        hasSetupData,
        errors,
        clearErrors,
        clearSetupData,
        fetchQrCode,
        fetchSetupKey,
        fetchSetupData,
        fetchRecoveryCodes,
    };
};

