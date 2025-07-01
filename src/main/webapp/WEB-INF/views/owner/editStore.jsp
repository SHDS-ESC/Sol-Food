<%--
  Created by IntelliJ IDEA.
  User: fzaca
  Date: 25. 6. 19.
  Time: 오후 4:29
  To change this template use File | Settings | File Templates.
--%><%--
  Created by IntelliJ IDEA.
  User: fzaca
  Date: 25. 6. 19.
  Time: 오전 9:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sol Food - 레스토랑 관리</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- 카카오맵 API -->
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=8f9034d6cf1da650e02b54751e02fcb3&libraries=services"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f8f9fa;
            color: #333;
        }

        .dashboard {
            display: flex;
            height: 100vh;
        }

        /* 사이드바 */
        .sidebar {
            width: 250px;
            background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%);
            color: white;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            z-index: 1000;
        }

        .sidebar-header {
            padding: 20px;
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .sidebar-header h2 {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .sidebar-header p {
            font-size: 0.9rem;
            opacity: 0.8;
        }

        .sidebar-menu {
            list-style: none;
            padding: 20px 0;
        }

        .sidebar-menu li {
            margin: 5px 0;
        }

        .sidebar-menu a {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            color: white;
            text-decoration: none;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }

        .sidebar-menu a:hover {
            background: rgba(255,255,255,0.1);
            border-left: 3px solid white;
        }

        .sidebar-menu a.active {
            background: rgba(255,255,255,0.2);
            border-left: 3px solid white;
        }

        .sidebar-menu a .icon {
            margin-right: 12px;
            font-size: 1.2rem;
        }

        /* 메인 콘텐츠 */
        .main-content {
            flex: 1;
            margin-left: 250px;
            display: flex;
            flex-direction: column;
        }

        /* 헤더 */
        .header {
            background: white;
            padding: 15px 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            z-index: 999;
        }

        .header-title {
            font-size: 1.8rem;
            font-weight: 600;
            color: #333;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #4ade80, #22c55e);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }

        .user-details h4 {
            font-size: 0.9rem;
            margin-bottom: 2px;
        }

        .user-details p {
            font-size: 0.8rem;
            color: #666;
        }

        .logout-btn {
            background: #ef4444;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: background 0.3s ease;
        }

        .logout-btn:hover {
            background: #dc2626;
        }

        /* 콘텐츠 영역 */
        .content {
            flex: 1;
            padding: 30px 60px;
            overflow-y: auto;
        }

        .content-header {
            margin-bottom: 30px;
        }

        .content-header h1 {
            font-size: 2rem;
            margin-bottom: 10px;
        }

        .content-header p {
            color: #666;
            font-size: 1rem;
        }

        /* 상점 관리 영역 */
        .menu-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .filter-tabs {
            display: flex;
            gap: 10px;
        }

        .tab-btn {
            padding: 8px 16px;
            border: 1px solid #ddd;
            background: white;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 0.9rem;
        }

        .tab-btn.active {
            background: #22c55e;
            color: white;
            border-color: #22c55e;
        }

        .add-menu-btn {
            background: #22c55e;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1rem;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: background 0.3s ease;
        }

        .add-menu-btn:hover {
            background: #16a34a;
        }

        /* 상점 그리드 */
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }

        .menu-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .menu-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 16px rgba(0,0,0,0.15);
        }

        .menu-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .menu-info {
            padding: 20px;
        }

        .menu-name {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .menu-description {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 15px;
            line-height: 1.4;
        }

        .menu-price {
            font-size: 1.3rem;
            font-weight: 700;
            color: #22c55e;
            margin-bottom: 15px;
        }

        .menu-actions-card {
            display: flex;
            gap: 10px;
        }

        .edit-btn, .delete-btn {
            flex: 1;
            padding: 8px 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }

        .edit-btn {
            background: #3b82f6;
            color: white;
        }

        .edit-btn:hover {
            background: #2563eb;
        }

        .delete-btn {
            background: #ef4444;
            color: white;
        }

        .delete-btn:hover {
            background: #dc2626;
        }

        /* 모달 */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 2000;
        }

        .modal-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 30px;
            border-radius: 12px;
            width: 90%;
            max-width: 800px;
            max-height: 90vh;
            overflow-y: auto;
        }

        .modified-content {
        }

        .modal-header {
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }

        .modal-header h3 {
            font-size: 1.5rem;
            margin-bottom: 5px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group.address input{
            width: inherit;
            margin-bottom:8px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #22c55e;
        }

        .form-group textarea {
            height: 100px;
            resize: vertical;
        }

        .modal-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 20px;
        }

        .btn-cancel, .btn-save {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .btn-cancel {
            background: #6b7280;
            color: white;
        }

        .btn-cancel:hover {
            background: #4b5563;
        }

        .btn-save {
            background: #22c55e;
            color: white;
        }

        .btn-save:hover {
            background: #16a34a;
        }

        .breadcrumb{display: block; color: #666; }

        #preview {padding: 10px; border-radius: 6px; border:1px solid #ddd; display: none }
        #preview img{width: 100%}

        #storeImagePreview{max-width: 900px}

    </style>
<script>
    <c:if test="${not empty errorMessage}">
        alert(${errorMessage});
    </c:if>
</script>
</head>
<body>
<div class="dashboard">
    <!-- 사이드바 -->
    <nav class="sidebar">
        <div class="sidebar-header">
            <h2>🍽️ <c:out value="${restaurantName}" default="Sol Food"/></h2>
            <p>레스토랑 관리 시스템</p>
        </div>
        <ul class="sidebar-menu">
            <li>
                <a href="<c:url value="/owner/store" /> " data-tab="store" data-tab="overview" class="active" >
                    <span class="icon">📅</span>
                    <span>상점 관리</span>
                </a>
            </li>
            <li>
                <a href="<c:url value="/owner/menu" />" data-tab="menu">
                    <span class="icon">🍽️</span>
                    <span>메뉴 관리</span>
                </a>
            </li>
            <li>
                <a href="#" >
                    <span class="icon">📊</span>
                    <span>매출 관리</span>
                </a>
            </li>
            <li>
                <a href="#" data-tab="testimonials">
                    <span class="icon">💬</span>
                    <span>리뷰 관리</span>
                </a>
            </li>
            <li>
                <a href="#" data-tab="faq">
                    <span class="icon">❓</span>
                    <span>FAQ</span>
                </a>
            </li>
        </ul>
    </nav>

    <!-- 메인 콘텐츠 -->
    <main class="main-content">
        <!-- 헤더 -->
        <header class="header">
            <h1 class="header-title"></h1>
            <div class="header-actions">
                <div class="user-info">
                    <div class="user-avatar">관</div>
                    <div class="user-details">
                        <h4>${ownerLoginSession.ownerEmail}</h4>
                        <p>레스토랑 오너</p>
                    </div>
                </div>
                <button class="logout-btn" onclick="logout()">로그아웃</button>
            </div>
        </header>

        <!-- 콘텐츠 영역 -->
        <section class="content">
            <div class="content-header">
                <span class="breadcrumb">🏠 상점 관리 > 상점 수정 </span>
                <h1>상점 관리</h1>
                <p>상점 정보를 수정하고 저장하세요. </p>
            </div>



            <div class="menu-content">

                <form id="storeForm" enctype="multipart/form-data" action="/solfood/owner/store/edit" method="post">

                    <input  type="hidden" name="storeId" value="${store.storeId}" >
<%--                    <input type="hidden" name="storeMainimage" value="${store.storeMainimage}" />--%>
                    <input type="hidden" id="storeStatus" name="storeStatus" value="승인대기">
                <div class="form-group">
                            <label for="storeName">상점명</label>
                            <input value="${store.storeName}" type="text" id="storeName" name="storeName" required>
                        </div>

                        <div class="form-group">
                            <label for="categoryId">상점 카테고리</label>
                            <select id="categoryId" name="categoryId" style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px;">
                                <option value="">--카테고리 선택--</option>
                                <c:forEach var="c" items="${categoryList}">
                                    <option value="${c.categoryId}"
                                            <c:if test="${store.categoryId == c.categoryId}">selected</c:if>>
                                            ${c.categoryName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group address">
                            <label for="storeAddress">상점 위치</label>
                            <div class="test">
                                <input type="text" id="sample3_postcode" placeholder="우편번호">
                                <input type="button" onclick="sample3_execDaumPostcode()" value="우편번호 찾기" class="btn-cancel" style="padding: 9px"><br>
                                <input type="text" id="sample3_address" placeholder="주소" style="width: 100%"><br>
                                <input type="text" id="sample3_detailAddress" style="width: 100%" placeholder="상세주소">
                                <input type="text" id="sample3_extraAddress" style="width: 100%" placeholder="참고항목">

                                <div id="wrap" style="display:none;border:1px solid;width:500px;height:300px;margin:5px 0;position:relative">
                                    <img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnFoldWrap" style="cursor:pointer;position:absolute;right:0px;top:-1px;z-index:1" onclick="foldDaumPostcode()" alt="접기 버튼">
                                </div>
                            </div>
                        </div>
                        <input type="hidden" id="storeAddress" name="storeAddress" value="${store.storeAddress}">

                        <div class="form-group">
                            <label for="storeTel">상점 번호</label>
                            <input value="${store.storeTel}" type="text" id="storeTel" name="storeTel" required>
                        </div>
                        <div class="form-group">
                            <label for="storeIntro">상점 소개</label>
                            <input value="${store.storeIntro}" type="text" id="storeIntro" name="storeIntro" required>
                        </div>
                        <div class="form-group">
                            <!-- 파일 선택 버튼 (label) -->
                            <label for="storeMainimage">상점 대표 이미지</label>
                            <input type="hidden" name="storeMainimage" id="storeMainimageId" value="${store.storeMainimage}">
                            <label for="storeMainimage" class="btn-cancel" style="display: inline-block; color: #fff; font-weight: 400">파일 선택</label>
                            <input class="btn-cancel" accept="image/*" type="file" id="storeMainimage" onchange="previewStoreMainimage(event)" style="display: none">

                        </div>
                        <div id="preview">
                            <img id="storeImagePreview" src="${store.storeMainimage}" alt="">
                            <button type="button" class="btn-cancel" id="deleteImageBtn" onclick="deleteImagePreview()" style="display:none; margin-top: 10px;">이미지 삭제</button>
                        </div>
                        <%--위도--%>
                        <input value="${store.storeLatitude}" type="hidden" name="storeLatitude" id="storeLatitude" >
                        <%--경도--%>
                        <input value="${store.storeLongitude}" type="hidden" name="storeLongitude" id="storeLongitude" >
                        <div class="modal-actions">
                            <button type="button" class="btn-cancel">취소</button>
                            <button type="submit" class="btn-save">저장</button>
                        </div>
                    </form>

            </div>
        </section>
    </main>

</div>



<script src="${pageContext.request.contextPath}/js/s3Upload.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    function logout(){
        if(confirm("로그아웃 하시겠습니까?😊")){
            window.location.href="/solfood/owner/logout";
        }
    }


    // --------------------------------위치 찾기---------------------------------
    // 우편번호 찾기 찾기 화면을 넣을 element
    var element_wrap = document.getElementById('wrap');

    function foldDaumPostcode() {
        // iframe을 넣은 element를 안보이게 한다.
        element_wrap.style.display = 'none';
    }

    function sample3_execDaumPostcode() {
        // 현재 scroll 위치를 저장해놓는다.
        var currentScroll = Math.max(document.body.scrollTop, document.documentElement.scrollTop);
        new daum.Postcode({
            oncomplete: function(data) {
                // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if(data.userSelectedType === 'R'){
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    // 조합된 참고항목을 해당 필드에 넣는다.
                    document.getElementById("sample3_extraAddress").value = extraAddr;

                } else {
                    document.getElementById("sample3_extraAddress").value = '';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('sample3_postcode').value = data.zonecode;
                document.getElementById("sample3_address").value = addr;
                // 커서를 상세주소 필드로 이동한다.
                document.getElementById("sample3_detailAddress").focus();

                // iframe을 넣은 element를 안보이게 한다.
                // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
                element_wrap.style.display = 'none';

                // 우편번호 찾기 화면이 보이기 이전으로 scroll 위치를 되돌린다.
                document.body.scrollTop = currentScroll;

                // ----------------------추가 --------------------
                const fullAddress = addr + document.getElementById("sample3_detailAddress").value+' ' + (extraAddr || '');
                document.getElementById("storeAddress").value = fullAddress;

                getLatLngFromAddress(fullAddress);
            },
            // 우편번호 찾기 화면 크기가 조정되었을때 실행할 코드를 작성하는 부분. iframe을 넣은 element의 높이값을 조정한다.
            onresize : function(size) {
                element_wrap.style.height = size.height+'px';
            },
            width : '100%',
            height : '100%'
        }).embed(element_wrap);

        // iframe을 넣은 element를 보이게 한다.
        element_wrap.style.display = 'block';
    }

    document.getElementById("sample3_detailAddress").addEventListener("blur",function (){
        const addr = document.getElementById("sample3_address").value;
        const detail = this.value;
        const extra = document.getElementById("sample3_extraAddress").value;

        document.getElementById("storeAddress").value = addr + ' ' + detail + ' ' + extra;
    })


    // ---------------------------- 대표이미지 미리보기 -------------------------------------
    async function previewStoreMainimage(event){

        let files = event.target.files; // 파일 선택 input 에서 선택된 파일 리스트 가져오기
        let reader = new FileReader(); // 파일을 읽기 위한 fileReader 객체 생성
        reader.onload = function (e){ // 파일 읽기가 완료 됐을 때 실행할 함수 정의
            let img = document.getElementById("storeImagePreview"); // 미리보기 태그
            img.setAttribute('src',e.target.result); // src 속성 설정

            /*여기 수정해야될것같음*/



            document.getElementById("preview").style.display = "block";
            document.getElementById("deleteImageBtn").style.display = "block"; // 삭제버튼 표시
        }

        const file = files[0]; // ✅ 이 줄이 꼭 필요합니다!

        reader.readAsDataURL(files[0]); // 첫번째 파일을 인코딩으로 읽기

        // S3 업로드 실행 (s3Upload.js의 s3Uploader 사용)
        const s3Url = await s3Uploader.uploadProfileImage(file, function(progress) {
            updateUploadProgress(progress);
        });

        // 업로드 성공 - hidden input에 S3 URL 저장
        document.getElementById('storeMainimageId').value = s3Url;

        console.log('프로필 이미지 업로드 완료:', s3Url);


    }


    // -----------------------------대표이미지 삭제----------------------------------

    function deleteImagePreview() {
        document.getElementById("preview").style.display = "block";
        document.getElementById("storeImagePreview").src = ""; // 제거
        document.getElementById("storeMainimage").value = ""; // ✅ 이 줄은 그대로 OK
        document.getElementById("deleteImageBtn").style.display = "none";
    }

    // ----------------------------위도 경도 ---------------------------------------
    function getLatLngFromAddress(fullAddress){
        var geocoder = new kakao.maps.services.Geocoder();

        var callback = function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                console.log(result);
                const lat = result[0].y; // 위도
                const lng = result[0].x; // 경도
                document.getElementById("storeLatitude").value = lat;
                document.getElementById("storeLongitude").value = lng;
            } else{
                alert("위도 경도 조회 실패",status)
            }
        };

        geocoder.addressSearch(fullAddress, callback);
    }
    // ----------------------페이지 로드시 미리보기 ----------------------------------------
    window.onload = function () {
        const storeMainimage = "${store.storeMainimage}";
        if (storeMainimage && storeMainimage.trim() !== "") {
            document.getElementById("preview").style.display = "block";
            document.getElementById("deleteImageBtn").style.display = "inline-block";
        }
    };


</script>
</body>
</html>
