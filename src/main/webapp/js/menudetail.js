let quantity = 1;

function updateQty() {
    document.getElementById('quantity').innerText = quantity + '개';
    document.getElementById('addCartBtn').innerText = quantity + '개 담기';
}

function changeQty(delta) {
    qty += delta;
    if (quantity < 1) quantity = 1;
    updateQty();
}

// 장바구니 버튼
document.addEventListener("DOMContentLoaded", function() {
    document.getElementById('addCartBtn').addEventListener('click', function() {
        alert(quantity + '개가 장바구니에 담겼습니다.');
    });
    updateQty();
});
