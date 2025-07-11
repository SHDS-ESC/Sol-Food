const ctx = window.APP_CTX;
let currentPage = 1;
let firstPage = 1;
let lastPage = 10;

function renderPaymentRow(paymentList) {
    const $tbody = $('#paymentListBody');
    $tbody.empty();

    if (!paymentList || paymentList.length === 0) {
        $tbody.append(
            '<tr><td colspan="11" class="text-center">검색 결과가 없습니다.</td></tr>'
        );
        return;
    }

    paymentList.forEach(payment => {
        const $row = $('<tr>');
        $row.append($('<td>').text(payment.integratedpaymentId || ''));
        $row.append($('<td>').text(payment.usersName || ''));
        $row.append($('<td>').text(payment.paymentPaidAmount || '0'));
        $row.append($('<td>').text(payment.paymentUsedPoint || '0'));
        $row.append($('<td>').text(payment.paymentMethod || '미결제'));
        $row.append($('<td>').text(payment.paymentPgProvider || 'pg'));
        $row.append($('<td>').text(payment.paymentCreatedAt || ''));

        $row.append(
            $('<td>').append(
                payment.paymentReceiptUrl
                    ? $('<a>')
                        .attr('href', payment.paymentReceiptUrl)
                        .attr('target', '_blank')
                        .text('영수증 보기')
                    : $('<span>').text('영수증 없음')
            )
        );

        $row.append($('<td>').text(payment.paymentStatus || ''));
        $row.append($('<td>').append($('<button>').addClass('detail-button').text('자세히 보기 >>')));
        $tbody.append($row);
    });
}

function renderPagination(firstPage, lastPage, currentPage) {
    $('.pagination .page-item').not('.previous, .next').remove();
    for (let i = firstPage; i <= lastPage; i++) {
        const $li = $('<li>').addClass('page-item');
        if (i === currentPage) {
            $li.addClass('active').attr('aria-current', 'page');
        }
        const $a = $('<a>').addClass('page-link').text(i);
        $li.append($a);
        $('.pagination .next').before($li);
    }
}

// 2) AJAX 호출 함수
function searchPayment(query, page, size, paymentStatus = '') {
    const toDate = $('#toDate').val();
    const fromDate = $('#fromDate').val();
    console.log(toDate)

    $.ajax({
        url: ctx + '/admin/payment-management/search',
        type: 'GET',
        data: {
            query,
            currentPage: page,
            pageSize: size,
            toDate: toDate,
            fromDate: fromDate,
            paymentStatus: paymentStatus
        },
        success: function (response) {
            renderPaymentRow(response.list);
            console.log(response)
            if (response.lastPage * size < response.count) {
                $('.pagination .next').removeClass('disabled');
            } else {
                $('.pagination .next').addClass('disabled');
            }

            if (response.firstPage === 1) {
                $('.pagination .previous').addClass('disabled');
            } else {
                $('.pagination .previous').removeClass('disabled');
            }
            lastPage = response.lastPage;
            firstPage = response.firstPage;
            renderPagination(firstPage, lastPage, page);
        },
        error: function () {
            showErrorPopup('검색 중 오류가 발생했습니다.');
        }
    });
}

// 3) 페이지네이션 UI 업데이트
function updatePaginationUI($clicked) {
    $clicked.parent()
        .siblings()
        .removeClass('active')
        .removeAttr('aria-current')
        .end()
        .addClass('active')
        .attr('aria-current', 'page');
}

$(document).ready(function () {
    const query = $('#searchPaymentForm').find('input[name="query"]').val();
    const $pageSize = $('.form-select-count');
    const $status = $('.form-select-status');
    const $pagination = $('.pagination')
    // 검색 폼 제출
    $('#searchPaymentForm').on('submit', function (e) {
        e.preventDefault();
        currentPage = 1;
        const query = $(this).find('input[name="query"]').val();
        searchPayment(query, currentPage, $pageSize.val(), $status.val());
    });

    // 페이지 번호 클릭
    $pagination.on('click', '.page-item:not(.previous):not(.next) .page-link', function (e) {
        e.preventDefault();
        const query = $('#searchPaymentForm').find('input[name="query"]').val();
        currentPage = parseInt($(this).text(), 10);
        updatePaginationUI($(this));
        searchPayment(query, currentPage, $pageSize.val(), $status.val());
    });

    // Previous 클릭
    $pagination.on('click', '.previous .page-link', function (e) {
        e.preventDefault();
        const query = $('#searchPaymentForm').find('input[name="query"]').val();
        searchPayment(query, firstPage - $pageSize.val(), $pageSize.val(), $status.val());
    });

    // Next 클릭
    $pagination.on('click', '.next .page-link', function (e) {
        e.preventDefault();
        const query = $('#searchPaymentForm').find('input[name="query"]').val();
        searchPayment(query, lastPage + 1, $pageSize.val(), $status.val());
    });

    // 페이지 크기 변경
    $pageSize.on('change', function () {
        const query = $('#searchPaymentForm').find('input[name="query"]').val();
        currentPage = 1;
        searchPayment(query, currentPage, $pageSize.val(), $status.val());
    });

    // 페이지 크기 변경
    $pageSize.on('change', function () {
        const query = $('#searchPaymentForm').find('input[name="query"]').val();
        currentPage = 1;
        searchPayment(query, currentPage, $pageSize.val(), $status.val());
    });

    $status.on('change', function () {
        const query = $('#searchPaymentForm').find('input[name="query"]').val();
        currentPage = 1;
        searchPayment(query, currentPage, $pageSize.val(), $(this).val());
        console.log($status.val())
    });

    $(document).on('click', '.detail-button', function () {
        const $row = $(this).closest('tr');
        const paymentId = $row.find('td:first').text();
        const url = ctx + '/admin/payment-management/detail?integratedpaymentId=' + paymentId;
        window.location.href = url;
    });

    searchPayment(query, currentPage, $pageSize.val(), $status.val());
});