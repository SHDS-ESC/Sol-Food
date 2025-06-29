const ctx = window.APP_CTX;
    let currentPage = 1;
    let firstPage = 1;
    let lastPage = 10;

    // 1) 점주 목록 렌더링 함수
    function renderOwnerRows(ownerList) {
        const $tbody = $('#ownerListBody');
        $tbody.empty();

        if (!ownerList || ownerList.length === 0) {
            $tbody.append(
                '<tr><td colspan="11" class="text-center">검색 결과가 없습니다.</td></tr>'
            );
            return;
        }

        ownerList.forEach(owner => {
            console.log(owner)
            const profileHtml = owner.storeMainImage
                ? '<img src="' + owner.storeMainImage +
                '" class="owner-avatar" alt="프로필">'
                : `<div class="owner-avatar" style="background:#e9ecef;display:flex;align-items:center;justify-content:center;">` +
                `<svg width="24" height="24" fill="#adb5bd" viewBox="0 0 24 24">` +
                `<circle cx="12" cy="8" r="4"/>` +
                `<path d="M12 14c-4.418 0-8 1.79-8 4v2h16v-2c0-2.21-3.582-4-8-4z"/>` +
                `</svg></div>`;

            const $row = $('<tr>');
            $row.append($('<td>').text(owner.ownerId || ''));
            $row.append($('<td>').html(profileHtml));
            $row.append($('<td>').text(owner.storeName || ''));
            $row.append($('<td>').text(owner.ownerEmail || ''));
            $row.append($('<td>').text(owner.categoryName || ''));
            $row.append($('<td>').text(owner.storeAvgStar || ''));
            $row.append($('<td>').text(owner.ownerTel || ''));
            $row.append($('<td>').text(owner.storeTel || ''));
            $row.append($('<td>').text(owner.storeAddress || ''));
            $row.append($('<td>').text(owner.storeIntro || ''));
            const $tdStatus = $('<td>');
            const $select = $('<select>').addClass('status-select');

            ['승인완료', '승인대기', '승인거절'].forEach(status => {
                const $opt = $('<option>')
                    .val(status)
                    .text(status);

                if (owner.ownerStatus === status) {
                    $opt.prop('selected', true);
                }

                $select.append($opt);
            });

            $tdStatus.append($select);
            $row.append($tdStatus);

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
    function searchOwners(query, page, size) {
        $.ajax({
            url: ctx + '/admin/home/owner-management/search',
            type: 'GET',
            data: {query, currentPage: page, pageSize: size},
            success: function (response) {
                renderOwnerRows(response.list);
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
                alert('검색 중 오류가 발생했습니다.');
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
        const $pageSize = $('.form-select');

        // 검색 폼 제출
        $('#searchForm').on('submit', function (e) {
            e.preventDefault();
            currentPage = 1;
            const query = $(this).find('input[name="query"]').val();
            searchOwners(query, currentPage, $pageSize.val());
        });

        // 페이지 번호 클릭
        $('.pagination').on('click', '.page-item:not(.previous):not(.next) .page-link', function (e) {
            e.preventDefault();
            const query = $('#searchForm').find('input[name="query"]').val();
            currentPage = parseInt($(this).text(), 10);
            updatePaginationUI($(this));
            searchOwners(query, currentPage, $pageSize.val());
        });

        // Previous 클릭
        $('.pagination').on('click', '.previous .page-link', function (e) {
            e.preventDefault();
            const query = $('#searchForm').find('input[name="query"]').val();
            searchOwners(query, firstPage - $pageSize.val(), $pageSize.val());
        });

        // Next 클릭
        $('.pagination').on('click', '.next .page-link', function (e) {
            e.preventDefault();
            const query = $('#searchForm').find('input[name="query"]').val();
            searchOwners(query, lastPage + 1, $pageSize.val());
        });

        // 페이지 크기 변경
        $pageSize.on('change', function () {
            currentPage = 1;
            $('#searchForm').submit();
        });

        $('#ownerListBody').on('change', '.status-select', function () {
            const status = $(this).val()
            const ownerId = $(this).closest('tr').find('td:first').text();
            console.log(status, ownerId);
            $.ajax({
                url: ctx + '/admin/home/owner-management/status-update',
                type: 'GET',
                data: {
                    ownerId: ownerId,
                    status: status
                },
                error: function () {
                    alert('업데이트에 실패하였습니다.');
                }
            });


        });
    });