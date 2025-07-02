/**
 * Sol Food 공통 JavaScript 유틸리티
 * 모든 페이지에서 재사용 가능한 함수들
 */
class SolFoodUtils {
    
    /**
     * 디바운스 함수 (연속 호출 방지)
     */
    static debounce(func, wait, immediate = false) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                timeout = null;
                if (!immediate) func(...args);
            };
            const callNow = immediate && !timeout;
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
            if (callNow) func(...args);
        };
    }
    
    /**
     * 서버 동기화 (공통 AJAX)
     */
    static async syncToServer(url, method = 'GET', data = null) {
        try {
            // 요청 옵션 기본 설정
            const options = {
                method: method,
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            };
            
            // GET 요청이 아닌 경우에만 Content-Type과 body 추가
            if (method !== 'GET' && data !== null) {
                options.headers['Content-Type'] = 'application/json';
                options.body = JSON.stringify(data);
            }
            
            const response = await fetch(UrlConstants.Builder.fullUrl(url), options);
            
            if (!response.ok) {
                throw new Error(`HTTP ${response.status}`);
            }
            
            return await response.json();
        } catch (error) {
            console.error('서버 동기화 실패:', error);
            throw error;
        }
    }
    
    /**
     * 배지 업데이트 (장바구니, 알림 등)
     */
    static updateBadge(selector, count) {
        const badges = document.querySelectorAll(selector);
        badges.forEach(badge => {
            if (badge) {
                badge.textContent = count;
                badge.style.display = count > 0 ? 'flex' : 'none';
            }
        });
    }
    
    /**
     * 로딩 상태 표시/숨김
     */
    static showLoading(element, show = true) {
        if (typeof element === 'string') {
            element = document.querySelector(element);
        }
        
        if (element) {
            if (show) {
                element.innerHTML = `
                    <div class="text-center py-4">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">로딩중...</span>
                        </div>
                        <p class="mt-2 text-muted">처리중...</p>
                    </div>
                `;
            }
        }
    }
    
    /**
     * 알림 메시지 (Toast 방식)
     */
    static showToast(message, type = 'info', duration = 3000) {
        // 기존 토스트 제거
        const existing = document.querySelector('.sol-toast');
        if (existing) existing.remove();
        
        const toast = document.createElement('div');
        toast.className = `sol-toast sol-toast-${type}`;
        toast.innerHTML = `
            <div class="sol-toast-content">
                <i class="bi bi-${this.getToastIcon(type)}"></i>
                <span>${message}</span>
                <button onclick="this.parentElement.parentElement.remove()" class="sol-toast-close">
                    <i class="bi bi-x"></i>
                </button>
            </div>
        `;
        
        // CSS 스타일 추가 (한번만)
        if (!document.querySelector('#sol-toast-styles')) {
            const styles = document.createElement('style');
            styles.id = 'sol-toast-styles';
            styles.textContent = `
                .sol-toast {
                    position: fixed;
                    top: 20px;
                    right: 20px;
                    z-index: 9999;
                    min-width: 300px;
                    animation: slideInRight 0.3s ease-out;
                }
                .sol-toast-content {
                    display: flex;
                    align-items: center;
                    padding: 12px 16px;
                    border-radius: 8px;
                    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                    background: white;
                    border-left: 4px solid;
                }
                .sol-toast-success { border-left-color: #28a745; }
                .sol-toast-error { border-left-color: #dc3545; }
                .sol-toast-warning { border-left-color: #ffc107; }
                .sol-toast-info { border-left-color: #007bff; }
                .sol-toast-content i:first-child { margin-right: 8px; }
                .sol-toast-close {
                    margin-left: auto;
                    background: none;
                    border: none;
                    cursor: pointer;
                }
                @keyframes slideInRight {
                    from { transform: translateX(100%); }
                    to { transform: translateX(0); }
                }
            `;
            document.head.appendChild(styles);
        }
        
        document.body.appendChild(toast);
        
        // 자동 제거
        setTimeout(() => {
            if (toast.parentElement) {
                toast.remove();
            }
        }, duration);
    }
    
    static getToastIcon(type) {
        switch (type) {
            case 'success': return 'check-circle-fill';
            case 'error': return 'exclamation-triangle-fill';
            case 'warning': return 'exclamation-circle-fill';
            default: return 'info-circle-fill';
        }
    }
    
    /**
     * 폼 데이터를 객체로 변환
     */
    static formToObject(form) {
        const formData = new FormData(form);
        const object = {};
        formData.forEach((value, key) => {
            object[key] = value;
        });
        return object;
    }
    
    /**
     * 숫자를 한국어 형식으로 포맷
     */
    static formatNumber(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    }
    

    
    /**
     * 로컬 스토리지 안전 사용
     */
    static setStorage(key, value) {
        try {
            localStorage.setItem(key, JSON.stringify(value));
            return true;
        } catch (e) {
            console.warn('스토리지 저장 실패:', e);
            return false;
        }
    }
    
    static getStorage(key, defaultValue = null) {
        try {
            const item = localStorage.getItem(key);
            return item ? JSON.parse(item) : defaultValue;
        } catch (e) {
            console.warn('스토리지 읽기 실패:', e);
            return defaultValue;
        }
    }
}

// 전역으로 사용 가능하게 등록
window.SolFoodUtils = SolFoodUtils; 