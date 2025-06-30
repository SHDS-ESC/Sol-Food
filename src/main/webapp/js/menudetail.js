let qty = 1;

function updateQty() {
    document.getElementById('qty').innerText = qty + '개';
    document.getElementById('addCartBtn').innerText = qty + '개 담기';
}

function changeQty(delta) {
    qty += delta;
    if (qty < 1) qty = 1;
    updateQty();
}

// 장바구니 버튼
document.addEventListener("DOMContentLoaded", function() {
    document.getElementById('addCartBtn').addEventListener('click', function() {
        alert(qty + '개가 장바구니에 담겼습니다.');
    });
    updateQty();
});
