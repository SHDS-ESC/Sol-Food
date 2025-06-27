package kr.co.solfood.user.store;

/**
 * Store 관련 비즈니스 로직에서 발생하는 예외
 */
public class StoreException extends RuntimeException {
    
    public StoreException(String message) {
        super(message);
    }
    
    public StoreException(String message, Throwable cause) {
        super(message, cause);
    }
    
    public StoreException(Throwable cause) {
        super(cause);
    }
} 