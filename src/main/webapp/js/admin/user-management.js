const ctx = window.APP_CTX;
let currentPage = 1;
let firstPage = 1;
let lastPage = 10;
let signupChart = null;  // 전역 변수로 선언
let userId = null;


const textarea = document.getElementById('detailedReason');
const charCount = document.getElementById('charCount');
const submitBtn = document.getElementById('submitBtn');

textarea.addEventListener('input', () => {
    const length = textarea.value.length;
    charCount.textContent = length;

    // 예: 최소 1자 이상 입력해야 제출 가능하도록 설정
    submitBtn.disabled = length === 0;
});


function renderUserRows(userList) {
    const userListBody = $('#userListBody');
    userListBody.empty();

    if (!userList || userList.length === 0) {
        userListBody.append('<tr><td colspan="10" class="text-center">검색 결과가 없습니다.</td></tr>');
        return;
    }

    userList.forEach(user => {
        const profileHtml = user.usersProfile
            ? '<img src="' + user.usersProfile + '" class="user-avatar" alt="프로필">'
            : `<div class="user-avatar" style="background:#e9ecef;display:flex;align-items:center;justify-content:center;">
                       <svg width="24" height="24" fill="#adb5bd" viewBox="0 0 24 24">
                           <circle cx="12" cy="8" r="4"/>
                           <path d="M12 14c-4.418 0-8 1.79-8 4v2h16v-2c0-2.21-3.582-4-8-4z"/>
                       </svg>
                   </div>`;
        let loginTypeHtml = '';
        if (!user.usersLoginType) {
            loginTypeHtml = '<span class="login-label login-label-web">X</span>';
        } else if (user.usersLoginType === 'kakao') {
            loginTypeHtml = '<span class="login-label login-label-kakao">카카오</span>';
        } else if (user.usersLoginType === 'native') {
            loginTypeHtml = '<span class="login-label login-label-native">네이티브</span>';
        } else {
            loginTypeHtml = `<span class.login-label login-label-web">${user.usersLoginType}</span>`;
        }

        const $row = $('<tr>');
        $row.append($('<td>').text(user.usersId || ''));
        $row.append($('<td>').html(profileHtml));
        $row.append($('<td>').text(user.usersName || ''));
        $row.append($('<td>').text(user.usersNickname || ''));
        $row.append($('<td>').html(loginTypeHtml));
        $row.append($('<td>').text(user.usersEmail || ''));
        $row.append($('<td>').text(user.departmentName || ''));
        $row.append($('<td>').text(user.usersAge || ''));
        $row.append($('<td>').text(user.usersGender || ''));


        const $tdStatus = $('<td>');
        const $select = $('<select>').addClass('status_selector');

        ['active', 'inactive'].forEach(status => {
            const $opt = $('<option>')
                .val(status)
                .text(status);

            if (user.usersStatus === status) {
                $opt.prop('selected', true);
            }

            $select.append($opt);
        });

        $tdStatus.append($select);
        $row.append($tdStatus);
        $row.append($('<td>').text(user.usersRejectedReason || ''));

        userListBody.append($row);
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

function searchUsers(query, page, size) {
    $.ajax({
        url: ctx + '/admin/user-management/search',
        type: 'GET',
        data: {query, currentPage: page, pageSize: size},
        success: function (response) {
            renderUserRows(response.list);
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

// Close modal when clicking outside
document.getElementById('rejectionModal').addEventListener('click', function (e) {
    if (e.target === this) {
        closeModal();
    }
});

// ESC key to close modal
document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        closeModal();
    }
});

function openRejectionModal(userProfile, userName, userNickName, userEmail) {
    $('#moal_image').attr('src', userProfile)
    $('#modal_user_name').text(userName)
    $('#modal_user_nickname').text(userNickName)
    $('#modal_user_info').text(userEmail)
    const modal = document.getElementById('rejectionModal');
    modal.style.display = 'flex';
    modal.style.animation = 'fadeIn 0.3s ease-out';
}

// Modal control functions
function closeModal() {
    const modal = document.getElementById('rejectionModal');
    modal.style.animation = 'fadeOut 0.3s ease-out';

    setTimeout(() => {
        modal.style.display = 'none';
        document.body.style.overflow = ''; // 스크롤 복구

        // ✅ [1] 버튼 초기화
        const submitBtn = document.getElementById('submitBtn');
        submitBtn.innerHTML = '<i class="fas fa-ban"></i> 승인 거절';
        submitBtn.disabled = true;
        submitBtn.style.opacity = '0.6';

        // ✅ [2] 선택된 라디오 해제
        document.querySelectorAll('input[name="rejectionReason"]').forEach(r => r.checked = false);
        document.querySelectorAll('.reason-option').forEach(opt => opt.classList.remove('selected'));

        // ✅ [3] 상세 사유 초기화
        const textarea = document.querySelector('textarea[name="detailedReason"]');
        textarea.value = '';
        document.getElementById('charCount').textContent = '0';

    }, 300);
}

$(document).ready(function () {

    $(document).on('change', '.status_selector', function () {
        const newStatus = $(this).val(); // 선택된 값
        userId = $(this).closest('tr').find('td:first').text(); // 첫 번째 <td>가 id라고 가정

        const userProfile = $(this).closest('tr').find('td').eq(1).find('img').attr('src'); // 두 번째 td
        const userName = $(this).closest('tr').find('td').eq(2).text()
        const userNickName = $(this).closest('tr').find('td').eq(3).text()
        const userEmail = $(this).closest('tr').find('td').eq(5).text()

        console.log(`사용자 ID: ${userId}, 변경된 상태: ${newStatus}`);

        if (newStatus === 'inactive') {
            openRejectionModal(userProfile, userName, userNickName, userEmail)
            return
        }

        sendUpdateUserState('active')
    });

    $('.filter-btns button').on('click', function () {
        // 모든 버튼에서 active 클래스 제거
        $('.filter-btns button').removeClass('active');
        // 클릭된 버튼에 active 클래스 추가
        $(this).addClass('active');
        const date = $(this).attr('name');

        $.ajax({
            url: ctx + '/admin/user-management/chart',
            type: 'GET',
            data: {date: date},
            success: function (response) {
                const dateList = response.map(item => item.createdAt);
                const countList = response.map(item => item.userCount);
                const canvas = document.getElementById('signupChart');
                const chartCtx = canvas.getContext('2d');
                const label = $('.btn.btn-outline-success.active').attr('name') + ' 가입자 수 변화';
                $('.text-muted').text(label + ' 가입자 수 변화');

                if (signupChart !== null) {
                    signupChart.destroy();
                }

                const chartData = {
                    labels: dateList,
                    datasets: [{
                        label: '가입자 수',
                        data: countList,
                        fill: true,
                        borderWidth: 2,
                        tension: 0.3,
                        borderColor: 'rgba(40, 167, 69, 0.8)',
                        backgroundColor: 'rgba(40, 167, 69, 0.2)'
                    }]
                };

                signupChart = new Chart(chartCtx, {
                    type: 'line',
                    data: chartData,
                    options: {
                        responsive: true,
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    stepSize: Math.ceil(Math.max(...countList) / 5)
                                }
                            }
                        },
                        plugins: {
                            legend: {
                                display: false
                            },
                            tooltip: {
                                padding: 10,
                                displayColors: false,
                                callbacks: {
                                    title: () => '',
                                    label: function (context) {
                                        return context.raw + '명';
                                    }
                                }
                            }
                        }
                    }
                });
            }
        });
    });

    $('.filter-btns button[name="연간"]').click();

    const $pageSize = $('.form-select');
    const $pagination = $('.pagination');

    // 검색 폼 제출
    $('#searchForm').on('submit', function (e) {
        e.preventDefault();
        currentPage = 1;
        const query = $(this).find('input[name="query"]').val();
        searchUsers(query, currentPage, $pageSize.val());
    });

    // 페이지 번호 클릭
    $pagination.on('click', '.page-item:not(.previous):not(.next) .page-link', function (e) {
        e.preventDefault();
        const query = $('#searchForm').find('input[name="query"]').val();
        currentPage = parseInt($(this).text(), 10);
        updatePaginationUI($(this));
        searchUsers(query, currentPage, $pageSize.val());
    });

    // Previous 클릭
    $pagination.on('click', '.previous .page-link', function (e) {
        e.preventDefault();
        const query = $('#searchForm').find('input[name="query"]').val();
        searchUsers(query, firstPage - $pageSize.val(), $pageSize.val());
    });

    // Next 클릭
    $pagination.on('click', '.next .page-link', function (e) {
        e.preventDefault();
        const query = $('#searchForm').find('input[name="query"]').val();
        searchUsers(query, lastPage + 1, $pageSize.val());
    });

    // 페이지 크기 변경
    $pageSize.on('change', function () {
        currentPage = 1;
        $('#searchForm').submit();
    });

    $('#submitBtn').on('click', function (e) {
        e.preventDefault();

        const reason = $('#detailedReason').val().trim();

        console.log(reason)

        // 예시: 서버에 거절 사유 전송
        sendUpdateUserState('inactive',reason)

    });

    function sendUpdateUserState(status = '',reason = ''){
        $.ajax({
            type: 'GET',
            url: ctx + '/admin/user-management/status-update',
            contentType: 'application/json',
            data: {usersId: userId, status: status, usersRejectedReason: reason},
            success: function () {
                showSuccessPopup('승인이 처리되었습니다.');
                closeModal();
                // 페이지 새로고침 또는 리스트 재요청 등
            },
            error: function () {
                showErrorPopup('처리 중 오류가 발생했습니다.');
            }
        });
    }

});
