import { ApiError, isSessionExpiredApiError } from './api';

export type SessionActionHooks<TSession> = {
  session: TSession | null;
  operation: (session: TSession) => Promise<void>;
  refreshSession: (session: TSession) => Promise<TSession | null>;
  onSessionRecovered?: (session: TSession) => void;
  onSessionExpired?: (error: ApiError) => void;
  onError?: (message: string) => void;
  fallbackMessage: string;
  hasRetried?: boolean;
};

export type ConfirmedSessionActionHooks<TSession> = SessionActionHooks<TSession> & {
  confirm: (message: string) => boolean;
  confirmMessage: string;
};

export async function executeSessionAction<TSession>({
  session,
  operation,
  refreshSession,
  onSessionRecovered,
  onSessionExpired,
  onError,
  fallbackMessage,
  hasRetried = false,
}: SessionActionHooks<TSession>): Promise<boolean> {
  try {
    if (!session) {
      return false;
    }

    await operation(session);
    return true;
  } catch (error) {
    if (error instanceof ApiError) {
      if (isSessionExpiredApiError(error) && !hasRetried) {
        const recoveredSession = await refreshSession(session as TSession);
        if (recoveredSession) {
          onSessionRecovered?.(recoveredSession);
          return executeSessionAction({
            session: recoveredSession,
            operation,
            refreshSession,
            onSessionRecovered,
            onSessionExpired,
            onError,
            fallbackMessage,
            hasRetried: true,
          });
        }

        onSessionExpired?.(error);
        return false;
      }

      onError?.(error.message);
      return false;
    }

    onError?.(fallbackMessage);
    return false;
  }
}

export async function executeConfirmedSessionAction<TSession>({
  confirm,
  confirmMessage,
  ...hooks
}: ConfirmedSessionActionHooks<TSession>): Promise<boolean> {
  if (!confirm(confirmMessage)) {
    return false;
  }

  return executeSessionAction(hooks);
}
