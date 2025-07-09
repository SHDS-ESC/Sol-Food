document.addEventListener('DOMContentLoaded', function() {
    let participants = [];
    let totalAmount = 0;

    // 1. 더치페이 API로 참여자/금액 데이터 받아오기
    fetch(window.UrlConstants.Builder.fullUrl('/user/cart/calculate-dutch-pay'), {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' }
    })
    .then(res => res.json())
    .then(data => {
        if (data.result === 'success' && data.participantList) {
            participants = data.participantList;
            totalAmount = data.totalAmount;
            document.getElementById('totalAmount').textContent = totalAmount.toLocaleString();
            renderTable();
        } else {
            showErrorPopup('참여자 정보를 불러오지 못했습니다.');
        }
    });

    // 2. 테이블 렌더링
    function renderTable() {
        const tbody = document.getElementById('billTableBody');
        tbody.innerHTML = '';
        participants.forEach((p, idx) => {
            tbody.innerHTML += `
                <tr>
                    <td>${p.userName}${p.isCurrentUser ? ' (나)' : ''}</td>
                    <td><input type="number" class="form-control amount-input" data-idx="${idx}" value="${p.amount}" min="0" required></td>
                </tr>
            `;
        });
        updateSum();
        document.querySelectorAll('.amount-input').forEach(input => {
            input.addEventListener('input', updateSum);
        });
    }

    // 3. 합계 체크 및 submit 버튼 활성화
    function updateSum() {
        let sum = 0;
        document.querySelectorAll('.amount-input').forEach(input => {
            sum += parseInt(input.value) || 0;
        });
        document.getElementById('sumAmount').textContent = sum.toLocaleString();
        const msg = document.getElementById('amountCheckMsg');
        const submitBtn = document.getElementById('submitBtn');
        if (sum === totalAmount) {
            msg.textContent = '';
            submitBtn.disabled = false;
        } else {
            msg.textContent = '합계가 총 주문금액과 일치해야 합니다.';
            submitBtn.disabled = true;
        }
    }

    // 4. submit 시 서버로 전송
    document.getElementById('billForm').addEventListener('submit', function(e) {
        e.preventDefault();
        // 입력값 반영
        document.querySelectorAll('.amount-input').forEach(input => {
            const idx = input.dataset.idx;
            participants[idx].amount = parseInt(input.value) || 0;
        });
        fetch(window.UrlConstants.Builder.fullUrl('/user/cart/submit-bill'), {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ bill: participants })
        })
        .then(res => res.json())
        .then(data => {
            if (data.result === 'success') {
                window.location.href = window.UrlConstants.Builder.fullUrl('/user/cart/waiting-approval');
            } else {
                showErrorPopup(data.message || '영수증 생성에 실패했습니다.');
            }
        });
    });

    // 뒤로가기 버튼
    window.goBack = function() {
        history.back();
    }
}); 