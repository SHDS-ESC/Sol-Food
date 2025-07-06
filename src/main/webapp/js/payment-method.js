// 결제 방법 선택 페이지 JavaScript
let selectedPaymentMethod = null;

function goBack() {
    history.back();
}

function selectPaymentMethod(method) {
    console.log('선택된 방식:', method);
    
    // 모든 옵션의 selected 클래스 제거
    document.querySelectorAll('.payment-option').forEach(option => {
        option.classList.remove('selected');
    });
    
    // 클릭된 옵션에 selected 클래스 추가 - 여러 방법으로 시도
    let selectedOption = document.querySelector(`[data-method="${method}"]`);
    console.log('querySelector 결과:', selectedOption);
    
    if (!selectedOption) {
        // 다른 방법으로 찾기
        const allOptions = document.querySelectorAll('.payment-option');
        console.log('모든 옵션들:', allOptions);
        allOptions.forEach(option => {
            console.log('옵션 data-method:', option.getAttribute('data-method'));
            if (option.getAttribute('data-method') === method) {
                selectedOption = option;
            }
        });
    }
    
    if (selectedOption) {
        selectedOption.classList.add('selected');
        selectedPaymentMethod = method;
        console.log('selectedPaymentMethod 설정됨:', selectedPaymentMethod);
        updateContinueButton();
    } else {
        console.error('selectedOption을 찾을 수 없음. method:', method);
        // 그래도 강제로 설정
        selectedPaymentMethod = method;
        updateContinueButton();
    }
}

function updateContinueButton() {
    console.log('updateContinueButton 호출됨. selectedPaymentMethod:', selectedPaymentMethod);
    const continueBtn = document.getElementById('continueBtn');
    
    if (selectedPaymentMethod) {
        continueBtn.classList.add('active');
        continueBtn.disabled = false;
        continueBtn.style.opacity = '1';
        continueBtn.style.cursor = 'pointer';
        
        if (selectedPaymentMethod === 'group') {
            continueBtn.textContent = '친구 초대하기';
        } else {
            continueBtn.textContent = '결제하기';
        }
        console.log('버튼 활성화 완료');
    } else {
        continueBtn.classList.remove('active');
        continueBtn.disabled = true;
        continueBtn.style.opacity = '0.5';
        continueBtn.style.cursor = 'not-allowed';
        continueBtn.textContent = '결제 방식을 선택해주세요';
        console.log('버튼 비활성화');
    }
}

function proceedToNext() {
    if (!selectedPaymentMethod) return;
    
    if (selectedPaymentMethod === 'group') {
        // 함께 결제 - 친구 초대 페이지로 이동
        window.location.href = UrlConstants.Builder.fullUrl('/user/cart/invite-friends');
    } else {
        // 개인 결제
        window.location.href = UrlConstants.Builder.fullUrl('/user/cart/make-bill');
    }
}

// DOM이 로드된 후 이벤트 리스너 등록
document.addEventListener('DOMContentLoaded', function() {
    // 모든 결제 옵션에 클릭 이벤트 추가
    const paymentOptions = document.querySelectorAll('.payment-option');
    
    paymentOptions.forEach(option => {
        option.addEventListener('click', function() {
            const method = this.getAttribute('data-method');
            if (method) {
                selectPaymentMethod(method);
            }
        });
    });
    
    // 계속하기 버튼 클릭 이벤트
    const continueBtn = document.getElementById('continueBtn');
    if (continueBtn) {
        continueBtn.addEventListener('click', proceedToNext);
    }
}); 