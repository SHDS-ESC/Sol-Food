// 결제 방법 선택 페이지 JavaScript
let selectedMethod = null;
const continueBtn = document.getElementById('continueBtn');
const paymentOptions = document.querySelectorAll('.payment-option');

function goBack() {
    history.back();
}

function selectPaymentMethod(method) {
    console.log('선택된 방식:', method);
    
    // 모든 옵션의 selected 클래스 제거
    paymentOptions.forEach(option => {
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
        selectedMethod = method;
        console.log('selectedPaymentMethod 설정됨:', selectedMethod);
        updateContinueButton();
    } else {
        console.error('selectedOption을 찾을 수 없음. method:', method);
        // 그래도 강제로 설정
        selectedMethod = method;
        updateContinueButton();
    }
}

function updateContinueButton() {
    console.log('updateContinueButton 호출됨. selectedPaymentMethod:', selectedMethod);
    
    if (selectedMethod) {
        continueBtn.classList.add('active');
        continueBtn.disabled = false;
        continueBtn.style.opacity = '1';
        continueBtn.style.cursor = 'pointer';
        
        if (selectedMethod === 'group') {
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
    if (!selectedMethod) return;
    
    if (selectedMethod === 'group') {
        // 함께 결제 - 친구 초대 페이지로 이동
        window.location.href = UrlConstants.Builder.fullUrl('/user/cart/invite-friends');
    } else {
        // 개인 결제
        window.location.href = UrlConstants.Builder.fullUrl('/user/cart/make-bill');
    }
}

// DOM이 로드된 후 이벤트 리스너 등록
document.addEventListener('DOMContentLoaded', function() {
    // 옵션 정보 렌더링
    const menuOptions = document.querySelectorAll('.menu-options');
    menuOptions.forEach(function(menuOption) {
        const optionsData = menuOption.querySelector('.options-data');
        const menuExtraData = menuOption.querySelector('.menu-extra-data');
        if (optionsData && menuExtraData) {
            try {
                const selectedOptions = JSON.parse(optionsData.textContent.trim());
                const optionGroups = JSON.parse(menuExtraData.textContent.trim());
                let optionsHtml = '';
                Object.entries(selectedOptions).forEach(([category, selected]) => {
                    const group = optionGroups.find(g => g.groupName === category);
                    if (group && Array.isArray(selected)) {
                        optionsHtml += '<div class="option-title">추가옵션</div>';
                        selected.forEach((optionName) => {
                            const optionInfo = group.options.find(opt => opt.name === optionName);
                            if (optionInfo) {
                                const cleanOptionName = optionName.replace(/^\+\s*/, '').replace(/^\+/, '').trim();
                                optionsHtml +=
                                    '<div class="option-row">' +
                                        '<span class="option-plus">+</span>' +
                                        '<span class="option-name">' + cleanOptionName + '</span>' +
                                        '<span class="option-price">(' + (optionInfo.price > 0 ? '+' + optionInfo.price.toLocaleString() : '0') + '원)</span>' +
                                    '</div>';
                            }
                        });
                    }
                });
                menuOption.innerHTML = optionsHtml;
            } catch (e) {
                console.error('옵션 파싱 에러:', e);
                menuOption.innerHTML = '옵션 정보를 불러올 수 없습니다.';
            }
        }
    });

    // 모든 결제 옵션에 클릭 이벤트 추가
    paymentOptions.forEach(option => {
        option.addEventListener('click', function() {
            // 이전 선택 제거
            paymentOptions.forEach(opt => opt.classList.remove('selected'));

            // 현재 선택 추가
            this.classList.add('selected');
            selectedMethod = this.dataset.method;

            // 다음 단계 버튼 활성화
            continueBtn.removeAttribute('disabled');
        });
    });
    
    // 계속하기 버튼 클릭 이벤트
    const continueBtn = document.getElementById('continueBtn');
    if (continueBtn) {
        continueBtn.addEventListener('click', proceedToNext);
    }
});

// payment-method 페이지 진입 시 inviteMap 초기화 (뒤로가기/캐시 복원 포함)
window.addEventListener('pageshow', function(event) {
    var contextPath = window.contextPath || '';
    console.log('contextPath:', contextPath);
    fetch(contextPath + '/user/cart/invite-reset', { method: 'POST', credentials: 'include' });
});
// 다음 단계 버튼 클릭 처리
continueBtn.addEventListener('click', function() {
    if (!selectedMethod) return;
    if (selectedMethod === 'group') {
        window.location.href = UrlConstants.Builder.fullUrl('/user/cart/invite-friends');
    } else {
        window.location.href = UrlConstants.Builder.fullUrl('/user/cart/make-bill');
    }
});