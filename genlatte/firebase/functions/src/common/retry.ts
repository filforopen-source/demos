import * as logger from "firebase-functions/logger";

/**
 * Helper function to retry an async operation with exponential backoff.
 */
export async function withRetry<T>(
    fn: () => Promise<T>,
    maxRetries: number = 3,
    baseDelayMs: number = 1000,
    orderId?: string
): Promise<T> {
    let lastError: any;
    for (let i = 0; i <= maxRetries; i++) {
        try {
            return await fn();
        } catch (e) {
            lastError = e;
            logger.error(`Error for orderId ${orderId}: ${JSON.stringify(e)}`);
            if (i < maxRetries) {
                const delay = baseDelayMs * Math.pow(2, i);
                logger.warn(`Retry attempt ${i + 1} after error for orderId ${orderId}. Retrying in ${delay}ms...`);
                await new Promise((resolve) => setTimeout(resolve, delay));
            }
        }
    }
    throw lastError;
}
