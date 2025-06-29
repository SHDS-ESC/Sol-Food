<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>상점 상세보기</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/owner-detail.css">
</head>

<body>
<!-- Animated background particles -->
<div class="particles">
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
</div>

<!-- Modal Overlay -->
<div class="modal-overlay" id="rejectionModal">
    <div class="modal-container">
        <!-- Close Button -->
        <button class="modal-close" onclick="closeModal()">
            <i class="fas fa-times"></i>
        </button>

        <!-- Modal Header -->
        <div class="modal-header">
            <div class="modal-icon">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <h2 class="modal-title">승인 거절</h2>
            <p class="modal-subtitle">상점 승인을 거절하는 사유를 선택하고 상세 내용을 입력해주세요</p>
        </div>

        <!-- Store Info Card -->
        <div class="store-info-card">
            <div class="store-info-header">
                <img src="https://via.placeholder.com/60x60/38a169/ffffff?text=Store" alt="상점 이미지" class="store-avatar">
                <div class="store-details">
                    <h4>맛있는 치킨집</h4>
                    <p>owner@example.com | 서울시 강남구 테헤란로 123</p>
                </div>
            </div>
        </div>

        <!-- Rejection Form -->
        <form id="rejectionForm">
            <!-- Reason Selection -->
            <div class="form-section">
                <label class="form-label">거절 사유 선택</label>
                <div class="reason-options">
                    <label class="reason-option">
                        <input type="radio" name="rejectionReason" value="document">
                        <div class="reason-option-content">
                            <div class="reason-icon">
                                <i class="fas fa-file-alt"></i>
                            </div>
                            <div class="reason-text">
                                <h5>서류 미비</h5>
                                <p>필요한 서류가 누락되거나 불완전합니다</p>
                            </div>
                        </div>
                    </label>

                    <label class="reason-option">
                        <input type="radio" name="rejectionReason" value="location">
                        <div class="reason-option-content">
                            <div class="reason-icon">
                                <i class="fas fa-map-marker-alt"></i>
                            </div>
                            <div class="reason-text">
                                <h5>위치 부적절</h5>
                                <p>영업 허가 구역이 아니거나 부적절한 위치입니다</p>
                            </div>
                        </div>
                    </label>

                    <label class="reason-option">
                        <input type="radio" name="rejectionReason" value="info">
                        <div class="reason-option-content">
                            <div class="reason-icon">
                                <i class="fas fa-info-circle"></i>
                            </div>
                            <div class="reason-text">
                                <h5>정보 부정확</h5>
                                <p>제공된 정보가 부정확하거나 확인되지 않습니다</p>
                            </div>
                        </div>
                    </label>

                    <label class="reason-option">
                        <input type="radio" name="rejectionReason" value="policy">
                        <div class="reason-option-content">
                            <div class="reason-icon">
                                <i class="fas fa-shield-alt"></i>
                            </div>
                            <div class="reason-text">
                                <h5>정책 위반</h5>
                                <p>플랫폼 정책이나 가이드라인을 위반했습니다</p>
                            </div>
                        </div>
                    </label>

                    <label class="reason-option">
                        <input type="radio" name="rejectionReason" value="duplicate">
                        <div class="reason-option-content">
                            <div class="reason-icon">
                                <i class="fas fa-copy"></i>
                            </div>
                            <div class="reason-text">
                                <h5>중복 등록</h5>
                                <p>이미 등록된 상점이거나 중복 신청입니다</p>
                            </div>
                        </div>
                    </label>

                    <label class="reason-option">
                        <input type="radio" name="rejectionReason" value="other">
                        <div class="reason-option-content">
                            <div class="reason-icon">
                                <i class="fas fa-ellipsis-h"></i>
                            </div>
                            <div class="reason-text">
                                <h5>기타 사유</h5>
                                <p>위 항목에 해당하지 않는 기타 사유</p>
                            </div>
                        </div>
                    </label>
                </div>
            </div>

            <!-- Detailed Reason -->
            <div class="form-section">
                <label class="form-label">상세 사유 (필수)</label>
                <textarea
                        class="custom-textarea"
                        name="detailedReason"
                        placeholder="거절 사유에 대한 상세한 설명을 입력해주세요. 점주가 이해할 수 있도록 구체적으로 작성해주시기 바랍니다."
                        maxlength="500"
                        required></textarea>
                <div class="character-count">
                    <span id="charCount">0</span>/500자
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="action-buttons">
                <button type="button" class="btn-custom btn-cancel" onclick="closeModal()">
                    <i class="fas fa-times"></i> 취소
                </button>
                <button type="submit" class="btn-custom btn-submit" id="submitBtn" disabled>
                    <i class="fas fa-ban"></i> 승인 거절
                </button>
            </div>
        </form>
    </div>
</div>

<div class="container">
    <!-- Page Header -->
    <div class="page-header">
        <h1 class="page-title">Store Details</h1>
        <p class="page-subtitle">상점 상세 정보</p>
    </div>

    <!-- Store Card -->
    <div class="store-card">
        <!-- Store Header -->
        <div class="store-header">
            <img src="${owner.storeMainImage != null ? owner.storeMainImage : 'https://via.placeholder.com/180x180/38a169/ffffff?text=Store'}"
                 alt="상점 이미지" class="store-avatar">
            <h2 class="store-name">${owner.storeName}</h2>
            <div class="store-category">${owner.categoryName}</div>
        </div>

        <!-- Details Grid -->
        <div class="details-grid">
            <!-- 점주 이메일 -->
            <div class="detail-card">
                <div class="detail-header">
                    <div class="detail-icon">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <h4 class="detail-title">점주 이메일</h4>
                </div>
                <p class="detail-content">${owner.ownerEmail}</p>
            </div>

            <!-- 상점 주소 -->
            <div class="detail-card">
                <div class="detail-header">
                    <div class="detail-icon">
                        <i class="fas fa-map-marker-alt"></i>
                    </div>
                    <h4 class="detail-title">상점 주소</h4>
                </div>
                <p class="detail-content">${owner.storeAddress}</p>
            </div>

            <!-- 점주 전화번호 -->
            <div class="detail-card">
                <div class="detail-header">
                    <div class="detail-icon">
                        <i class="fas fa-user-tie"></i>
                    </div>
                    <h4 class="detail-title">점주 전화번호</h4>
                </div>
                <p class="detail-content">${owner.ownerTel}</p>
            </div>

            <!-- 지점 전화번호 -->
            <div class="detail-card">
                <div class="detail-header">
                    <div class="detail-icon">
                        <i class="fas fa-phone"></i>
                    </div>
                    <h4 class="detail-title">지점 전화번호</h4>
                </div>
                <p class="detail-content">${owner.storeTel}</p>
            </div>

            <!-- 별점 -->
            <div class="detail-card">
                <div class="detail-header">
                    <div class="detail-icon">
                        <i class="fas fa-star"></i>
                    </div>
                    <h4 class="detail-title">별점</h4>
                </div>
                <div class="rating-container">
                    <div class="stars">
                        <c:forEach begin="1" end="5" var="i">
                            <i class="fas fa-star ${i <= owner.storeAvgStar ? '' : 'text-muted'}"></i>
                        </c:forEach>
                    </div>
                    <div class="rating-number">${owner.storeAvgStar}</div>
                </div>
            </div>

            <!-- 상점 상태 -->
            <div class="detail-card">
                <div class="detail-header">
                    <div class="detail-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <h4 class="detail-title">상점 상태</h4>
                </div>
                <label class="ownerSelectBody">
                    <select class="status-select">
                        <option value="승인완료" ${owner.storeStatus == '승인완료' ? 'selected' : ''}>승인완료
                        </option>
                        <option value="승인대기" ${owner.storeStatus == '승인대기' ? 'selected' : ''}>승인대기
                        </option>
                        <option value="승인거절" ${owner.storeStatus == '승인거절' ? 'selected' : ''}>승인거절
                        </option>
                    </select>
                </label>
            </div>
        </div>

        <!-- 상점 소개 (Full Width) -->
        <div class="detail-card" style="margin-top: 25px;">
            <div class="detail-header">
                <div class="detail-icon">
                    <i class="fas fa-info-circle"></i>
                </div>
                <h4 class="detail-title">상점 소개</h4>
            </div>
            <p class="detail-content">${owner.storeIntro}</p>
        </div>

        <!-- 거절 사유 (if exists) -->
        <c:if test="${owner.storeRejectReason != null && !empty owner.storeRejectReason}">
            <div class="detail-card" style="margin-top: 25px; border-left: 4px solid #f56565; background: rgba(245, 101, 101, 0.1);">
                <div class="detail-header">
                    <div class="detail-icon" style="background: linear-gradient(135deg, #f56565, #e53e3e);">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <h4 class="detail-title">거절 사유</h4>
                </div>
                <p class="detail-content">${owner.storeRejectReason}</p>
            </div>
        </c:if>
    </div>

    <div class="footer">
        <p>&copy; 2024 Store Management System. All rights reserved.</p>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
        crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>window.APP_CTX = "${pageContext.request.contextPath}";</script>
<script src="${pageContext.request.contextPath}/js/admin/owner-detail.js"></script>

</body>

</html>