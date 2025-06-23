<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sol Food - 오너 회원가입</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
            crossorigin="anonymous"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%);
            min-height: 100vh;
            padding: 20px 0;
            color: #333;
        }

        .register-container {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 600px;
            margin: 0 auto;
            position: relative;
        }

        .brand-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .brand-logo {
            font-size: 3rem;
            margin-bottom: 10px;
        }

        .brand-title {
            font-size: 2rem;
            font-weight: 700;
            color: #22c55e;
            margin-bottom: 5px;
        }

        .brand-subtitle {
            color: #666;
            font-size: 1rem;
            margin-bottom: 10px;
        }

        .register-type {
            background: linear-gradient(135deg, #4ade80, #22c55e);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            display: inline-block;
        }

        .form-section {
            margin-bottom: 30px;
        }

        .section-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #22c55e;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f9ff;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /*.form-row {*/
        /*    display: flex;*/
        /*    gap: 15px;*/
        /*    margin-bottom: 15px;*/
        /*}*/

        .form-group {
            flex: 1;
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 15px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #f9fafb;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #22c55e;
            background: white;
            box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.1);
        }

        .form-group textarea {
            height: 100px;
            resize: vertical;
        }

        .checkbox-group {
            display: flex;
            align-items: flex-start;
            margin-bottom: 20px;
            gap: 10px;
        }

        .checkbox-group input[type="checkbox"] {
            margin-top: 4px;
            transform: scale(1.2);
        }

        .checkbox-group label {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 0;
            line-height: 1.4;
        }

        .register-btn {
            width: 100%;
            background: linear-gradient(135deg, #4ade80, #22c55e);
            color: white;
            border: none;
            padding: 18px;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 20px;
        }

        .register-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(34, 197, 94, 0.2);
        }

        .register-btn:disabled {
            background: #9ca3af;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .form-links {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #e5e7eb;
        }

        .form-links a {
            color: #22c55e;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .form-links a:hover {
            color: #16a34a;
        }

        .validation-message {
            font-size: 0.8rem;
            margin-top: 5px;
            color: #dc2626;
        }

        .validation-message.success {
            color: #22c55e;
        }

        .file-upload {
            position: relative;
            display: inline-block;
            width: 100%;
        }

        .file-upload input[type="file"] {
            position: absolute;
            opacity: 0;
            width: 100%;
            height: 100%;
            cursor: pointer;
        }

        .file-upload-label {
            display: block;
            padding: 15px;
            border: 2px dashed #e5e7eb;
            border-radius: 12px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background: #f9fafb;
        }

        .file-upload-label:hover {
            border-color: #22c55e;
            background: #f0f9ff;
        }

        .file-preview {
            margin-top: 10px;
            text-align: center;
        }

        .file-preview img {
            max-width: 150px;
            max-height: 150px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        @media (max-width: 768px) {
            .register-container {
                margin: 10px;
                padding: 30px 25px;
            }

            .form-row {
                flex-direction: column;
                gap: 0;
            }

            .brand-title {
                font-size: 1.8rem;
            }
        }
    </style>
</head>
<body>
<div class="profile-container">
    <img class="profile-img" src='${user.usersProfile }' alt='카카오 프로필 이미지'>
    <div class="nickname">${user.usersNickname }님</div>
    <div class="welcome">추가 정보를 입력해주세요</div>
    <form action="<c:url value="/user/extra"/>" method="post">
        <input type="hidden" name="usersId" value="${user.usersId}">
        <input type="hidden" name="companyId" value="${user.companyId }">
        <input type="hidden" name="departmentId" value="${user.departmentId }">
        <input type="hidden" name="usersEmail" value="${user.usersEmail }">
        <input type="hidden" name="usersProfile" value="${user.usersProfile }">
        <input type="hidden" name="usersNickname" value="${user.usersNickname }">
        <input type="hidden" name="usersKakaoId" value="${user.usersKakaoId}">
        <input type="hidden" name="accessToken" value="${user.accessToken}">
        <input type="hidden" name="usersPoint" value="${user.usersPoint}">
        <input type="hidden" name="usersLoginType" value="${user.usersLoginType}">
    <div class="register-container">
        <div class="brand-header">
            <div class="brand-logo">🍽️</div>
            <h1 class="brand-title">Sol Food</h1>
            <p class="brand-subtitle">레스토랑 관리 시스템</p>
            <span class="register-type">오너 회원가입</span>
        </div>

        <form id="registerForm" action="<c:url value="/owner/register"/>" method="post" >
            <input type="hidden" name="ownerStatus" value="활성">
            <!-- 개인정보 섹션 -->
            <div class="form-section">
                <h3 class="section-title">
                    <span>👤</span>
                    개인정보
                </h3>

                <div class="form-row">
                    <div class="form-group">
                        <label for="ownerEmail">이메일 *</label>
                        <input type="email" id="ownerEmail" name="ownerEmail" placeholder="example@email.com" required>
                        <div class="validation-message" id="emailValidation"></div>
                    </div>
                    <div class="form-group">
                        <label for="ownerPassword">비밀번호 *</label>
                        <input type="password" id="ownerPassword" name="ownerPwd" placeholder="8자 이상 영문, 숫자, 특수문자" required>
                        <div class="validation-message" id="passwordValidation"></div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="passwordConfirm">비밀번호 확인 *</label>
                        <input type="password" id="passwordConfirm" placeholder="비밀번호를 다시 입력하세요" required>
                        <div class="validation-message" id="passwordConfirmValidation"></div>
                    </div>
<%--                    <div class="form-group">--%>
<%--                        <label for="ownerName">이름 *</label>--%>
<%--                        <input type="text" id="ownerName" name="ownerName" placeholder="실명을 입력하세요" required>--%>
<%--                    </div>--%>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="ownerPhone">연락처 *</label>
                        <input type="tel" id="ownerPhone" name="ownerTel" placeholder="010-0000-0000" required>
                    </div>
                </div>
            </div>

            <!-- 레스토랑 정보 섹션 -->
            <%--<div class="form-section">
                <h3 class="section-title">
                    <span>🏪</span>
                    레스토랑 정보
                </h3>

                <div class="form-row">
                    <div class="form-group">
                        <label for="restaurantName">레스토랑명 *</label>
                        <input type="text" id="restaurantName" name="restaurantName" placeholder="레스토랑 이름을 입력하세요" required>
                    </div>
                    <div class="form-group">
                        <label for="restaurantCategory">업종 *</label>
                        <select id="restaurantCategory" name="restaurantCategory" required>
                            <option value="">업종을 선택하세요</option>
                            <option value="korean">한식</option>
                            <option value="chinese">중식</option>
                            <option value="japanese">일식</option>
                            <option value="western">양식</option>
                            <option value="fusion">퓨전</option>
                            <option value="cafe">카페</option>
                            <option value="fastfood">패스트푸드</option>
                            <option value="etc">기타</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="restaurantAddress">주소 *</label>
                    <input type="text" id="restaurantAddress" name="restaurantAddress" placeholder="레스토랑 주소를 입력하세요" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="restaurantPhone">레스토랑 연락처 *</label>
                        <input type="tel" id="restaurantPhone" name="restaurantPhone" placeholder="02-0000-0000" required>
                    </div>
                    <div class="form-group">
                        <label for="businessNumber">사업자등록번호 *</label>
                        <input type="text" id="businessNumber" name="businessNumber" placeholder="000-00-00000" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="restaurantDescription">레스토랑 소개</label>
                    <textarea id="restaurantDescription" name="restaurantDescription" placeholder="레스토랑을 소개해주세요"></textarea>
                </div>

                <div class="form-group">
                    <label for="restaurantImage">레스토랑 대표 이미지</label>
                    <div class="file-upload">
                        <input type="file" id="restaurantImage" name="restaurantImage" accept="image/*">
                        <label for="restaurantImage" class="file-upload-label">
                            📷 이미지를 선택하세요
                        </label>
                    </div>
                    <div class="file-preview" id="imagePreview"></div>
                </div>
            </div>--%>

            <!-- 운영정보 섹션 -->
            <%--<div class="form-section">
                <h3 class="section-title">
                    <span>⏰</span>
                    운영정보
                </h3>

                <div class="form-row">
                    <div class="form-group">
                        <label for="openTime">오픈시간 *</label>
                        <input type="time" id="openTime" name="openTime" required>
                    </div>
                    <div class="form-group">
                        <label for="closeTime">마감시간 *</label>
                        <input type="time" id="closeTime" name="closeTime" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="closedDays">휴무일</label>
                    <select id="closedDays" name="closedDays">
                        <option value="">연중무휴</option>
                        <option value="monday">월요일</option>
                        <option value="tuesday">화요일</option>
                        <option value="wednesday">수요일</option>
                        <option value="thursday">목요일</option>
                        <option value="friday">금요일</option>
                        <option value="saturday">토요일</option>
                        <option value="sunday">일요일</option>
                    </select>
                </div>
            </div>
--%>
            <!-- 약관동의 -->
            <div class="form-section">
                <div class="checkbox-group">
                    <input type="checkbox" id="agreeTerms"  required>
                    <label for="agreeTerms">
                        <strong>[필수]</strong> 이용약관 및 개인정보처리방침에 동의합니다.<br>
                        Sol Food 서비스 이용약관과 개인정보 수집·이용에 대한 안내를 모두 읽고 동의합니다.
                    </label>
                </div>

                <div class="checkbox-group">
                    <input type="checkbox" id="agreeMarketing" >
                    <label for="agreeMarketing">
                        [선택] 마케팅 정보 수신에 동의합니다.<br>
                        새로운 서비스, 이벤트 정보 등을 SMS, 이메일로 받아보시겠습니까?
                    </label>
                </div>
            </div>

            <button type="submit" class="register-btn" id="submitBtn" disabled>
                회원가입 완료
            </button>
        </form>

        <div class="form-links">
            이미 계정이 있으신가요?
            <a href="${pageContext.request.contextPath}/owner/login">로그인</a>
        </div>
    </div>

    <script>
        $(document).ready(function() {
<<<<<<<< HEAD:src/main/webapp/WEB-INF/views/owner/register.jsp

            // 비밀번호 유효성 검사
            // $('#ownerPassword').on('input', function() {
            //     const password = $(this).val();
            //     const regex = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,}$/;
            //
            //     if (password.length === 0) {
            //         $('#passwordValidation').text('');
            //     } else if (!regex.test(password)) {
            //         $('#passwordValidation').text('8자 이상, 영문+숫자+특수문자를 포함해야 합니다.');
            //     } else {
            //         $('#passwordValidation').text('사용 가능한 비밀번호입니다.').addClass('success');
            //     }
            //     checkPasswordMatch();
            //     checkFormValid();
            // });
========
            // 아이디 유효성 검사
            $('#ownerId').on('input', function() {
                const id = $(this).val();
                const regex = /^[a-zA-Z0-9]{6,20}$/;

                if (id.length === 0) {
                    $('#idValidation').text('');
                } else if (!regex.test(id)) {
                    $('#idValidation').text('6~20자의 영문, 숫자만 사용 가능합니다.');
                } else {
                    $('#idValidation').text('사용 가능한 아이디입니다.').addClass('success');
                }
                checkFormValid();
            });

            // 비밀번호 유효성 검사
            $('#ownerPassword').on('input', function() {
                const password = $(this).val();
                const regex = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,}$/;

                if (password.length === 0) {
                    $('#passwordValidation').text('');
                } else if (!regex.test(password)) {
                    $('#passwordValidation').text('8자 이상, 영문+숫자+특수문자를 포함해야 합니다.');
                } else {
                    $('#passwordValidation').text('사용 가능한 비밀번호입니다.').addClass('success');
                }
                checkPasswordMatch();
                checkFormValid();
            });
>>>>>>>> owner:src/main/webapp/WEB-INF/views/owner/extra.jsp

            // 비밀번호 확인 검사
            $('#passwordConfirm').on('input', function() {
                checkPasswordMatch();
                checkFormValid();
            });

            function checkPasswordMatch() {
                const password = $('#ownerPassword').val();
                const confirmPassword = $('#passwordConfirm').val();

                if (confirmPassword.length === 0) {
                    $('#passwordConfirmValidation').text('');
                } else if (password !== confirmPassword) {
                    $('#passwordConfirmValidation').text('비밀번호가 일치하지 않습니다.');
                } else {
                    $('#passwordConfirmValidation').text('비밀번호가 일치합니다.').addClass('success');
                }
            }

            // 이메일 유효성 검사
            $('#ownerEmail').on('input', function() {
                const email = $(this).val();
                const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

                if (email.length === 0) {
                    $('#emailValidation').text('');
                } else if (!regex.test(email)) {
                    $('#emailValidation').text('올바른 이메일 형식이 아닙니다.');
                } else {
                    $('#emailValidation').text('사용 가능한 이메일입니다.').addClass('success');
                }
                checkFormValid();
            });

            // 이미지 미리보기
            $('#restaurantImage').on('change', function() {
                const file = this.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        $('#imagePreview').html('<img src="' + e.target.result + '" alt="미리보기">');
                    };
                    reader.readAsDataURL(file);
                }
            });

            // 약관동의 체크
            $('#agreeTerms').on('change', function() {
                checkFormValid();
            });

            // 필수 입력 항목들 체크
            $('input[required], select[required], textarea[required]').on('input change', function() {
                checkFormValid();
            });

            function checkFormValid() {
                const requiredFields = $('input[required], select[required]');
                let allValid = true;

                requiredFields.each(function() {
                    if ($(this).val().trim() === '') {
                        allValid = false;
                    }
                });

                // 유효성 검사 통과 여부 확인
                if (
                    // $('#passwordValidation').hasClass('success') &&
                    $('#passwordConfirmValidation').hasClass('success') &&
                    $('#emailValidation').hasClass('success') &&
                    $('#agreeTerms').is(':checked') &&
                    allValid) {
                    $('#submitBtn').prop('disabled', false);
                } else {
                    $('#submitBtn').prop('disabled', true);
                }
            }

            // 전화번호 자동 하이픈 추가
            $('#ownerPhone, #restaurantPhone').on('input', function() {
                let value = $(this).val().replace(/[^0-9]/g, '');
                if (value.length >= 3 && value.length <= 7) {
                    value = value.replace(/(\d{3})(\d+)/, '$1-$2');
                } else if (value.length >= 8) {
                    value = value.replace(/(\d{3})(\d{4})(\d+)/, '$1-$2-$3');
                }
                $(this).val(value);
            });

            // 사업자등록번호 자동 하이픈 추가
            $('#businessNumber').on('input', function() {
                let value = $(this).val().replace(/[^0-9]/g, '');
                if (value.length >= 3 && value.length <= 5) {
                    value = value.replace(/(\d{3})(\d+)/, '$1-$2');
                } else if (value.length >= 6) {
                    value = value.replace(/(\d{3})(\d{2})(\d+)/, '$1-$2-$3');
                }
                $(this).val(value);
            });
        });
    </script>
</body>
</html>