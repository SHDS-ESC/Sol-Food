<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sol-Food - 건강한 식단의 시작</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Noto Sans KR', sans-serif;
            line-height: 1.6;
            color: #333;
            overflow-x: hidden;
        }

        /* 헤더 스타일 */
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1rem 0;
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 2rem;
        }

        .logo {
            font-size: 1.8rem;
            font-weight: 700;
            text-decoration: none;
            color: white;
        }

        .nav-menu {
            display: flex;
            list-style: none;
            gap: 2rem;
        }

        .nav-menu a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .nav-menu a:hover {
            color: #ffd700;
        }

        /* 히어로 섹션 */
        .hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.1"/><circle cx="75" cy="75" r="1" fill="white" opacity="0.1"/><circle cx="50" cy="10" r="0.5" fill="white" opacity="0.1"/><circle cx="10" cy="60" r="0.5" fill="white" opacity="0.1"/><circle cx="90" cy="40" r="0.5" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            animation: float 20s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }

        .hero-content {
            max-width: 800px;
            padding: 0 2rem;
            position: relative;
            z-index: 2;
        }

        .hero h1 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            animation: fadeInUp 1s ease-out;
        }

        .hero p {
            font-size: 1.3rem;
            margin-bottom: 2rem;
            opacity: 0.9;
            animation: fadeInUp 1s ease-out 0.3s both;
        }

        .cta-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
            animation: fadeInUp 1s ease-out 0.6s both;
        }

        .btn {
            padding: 1rem 2rem;
            border: none;
            border-radius: 50px;
            font-size: 1.1rem;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: #ffd700;
            color: #333;
        }

        .btn-primary:hover {
            background: #ffed4e;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(255, 215, 0, 0.3);
        }

        .btn-secondary {
            background: transparent;
            color: white;
            border: 2px solid white;
        }

        .btn-secondary:hover {
            background: white;
            color: #667eea;
            transform: translateY(-2px);
        }

        /* 특징 섹션 */
        .features {
            padding: 5rem 0;
            background: #f8f9fa;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .section-title {
            text-align: center;
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 3rem;
            color: #333;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }

        .feature-card {
            background: white;
            padding: 2rem;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.15);
        }

        .feature-icon {
            font-size: 3rem;
            color: #667eea;
            margin-bottom: 1rem;
        }

        .feature-card h3 {
            font-size: 1.5rem;
            margin-bottom: 1rem;
            color: #333;
        }

        .feature-card p {
            color: #666;
            line-height: 1.6;
        }

        /* 통계 섹션 */
        .stats {
            padding: 5rem 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 2rem;
            text-align: center;
        }

        .stat-item {
            padding: 1rem;
        }

        .stat-number {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            display: block;
        }

        .stat-label {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        /* 푸터 */
        .footer {
            background: #333;
            color: white;
            padding: 3rem 0 1rem;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .footer-section h3 {
            margin-bottom: 1rem;
            color: #ffd700;
        }

        .footer-section p, .footer-section a {
            color: #ccc;
            text-decoration: none;
            line-height: 1.6;
        }

        .footer-section a:hover {
            color: #ffd700;
        }

        .footer-bottom {
            text-align: center;
            padding-top: 2rem;
            border-top: 1px solid #555;
            color: #999;
        }

        /* 애니메이션 */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* 반응형 디자인 */
        @media (max-width: 768px) {
            .nav-menu {
                display: none;
            }

            .hero h1 {
                font-size: 2.5rem;
            }

            .hero p {
                font-size: 1.1rem;
            }

            .cta-buttons {
                flex-direction: column;
                align-items: center;
            }

            .btn {
                width: 100%;
                max-width: 300px;
                justify-content: center;
            }

            .section-title {
                font-size: 2rem;
            }
        }

        /* 스크롤 애니메이션 */
        .scroll-reveal {
            opacity: 0;
            transform: translateY(30px);
            transition: all 0.6s ease;
        }

        .scroll-reveal.revealed {
            opacity: 1;
            transform: translateY(0);
        }
    </style>
</head>
<body>
    <!-- 헤더 -->
    <header class="header">
        <nav class="nav-container">
            <a href="#" class="logo">
                <i class="fas fa-leaf"></i> Sol-Food
            </a>
            <ul class="nav-menu">
                <li><a href="/">홈</a></li>
                <li><a href="#features">서비스</a></li>
                <li><a href="#about">소개</a></li>
                <li><a href="#contact">문의</a></li>
                                        <li><a href="${pageContext.request.contextPath}/user/login">로그인</a></li>
            </ul>
        </nav>
    </header>

    <!-- 히어로 섹션 -->
    <section class="hero" id="home">
        <div class="hero-content">
            <h1>건강한 식단의 시작</h1>
            <p>Sol-Food와 함께 맞춤형 영양 관리로 건강한 라이프스타일을 만들어보세요</p>
            <div class="cta-buttons">
                <a href="${pageContext.request.contextPath}/user/login" class="btn btn-primary">
                    <i class="fas fa-user"></i> 시작하기
                </a>
                <a href="#features" class="btn btn-secondary">
                    <i class="fas fa-info-circle"></i> 자세히 보기
                </a>
            </div>
        </div>
    </section>

    <!-- 특징 섹션 -->
    <section class="features" id="features">
        <div class="container">
            <h2 class="section-title scroll-reveal">왜 Sol-Food인가요?</h2>
            <div class="features-grid">
                <div class="feature-card scroll-reveal">
                    <div class="feature-icon">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <h3>개인 맞춤 영양 분석</h3>
                    <p>AI 기반 개인 맞춤 영양 분석으로 최적의 식단을 제안합니다.</p>
                </div>
                <div class="feature-card scroll-reveal">
                    <div class="feature-icon">
                        <i class="fas fa-mobile-alt"></i>
                    </div>
                    <h3>편리한 모바일 서비스</h3>
                    <p>언제 어디서나 모바일로 간편하게 영양 정보를 확인하고 관리하세요.</p>
                </div>
                <div class="feature-card scroll-reveal">
                    <div class="feature-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <h3>전문가 상담</h3>
                    <p>영양 전문가와의 1:1 상담을 통해 더욱 정확한 영양 관리가 가능합니다.</p>
                </div>
                <div class="feature-card scroll-reveal">
                    <div class="feature-icon">
                        <i class="fas fa-database"></i>
                    </div>
                    <h3>방대한 식품 데이터베이스</h3>
                    <p>수만 개의 식품 정보를 제공하여 정확한 영양 정보를 확인할 수 있습니다.</p>
                </div>
                <div class="feature-card scroll-reveal">
                    <div class="feature-icon">
                        <i class="fas fa-bell"></i>
                    </div>
                    <h3>스마트 알림 서비스</h3>
                    <p>식사 시간, 영양 섭취량 등을 스마트하게 알려드립니다.</p>
                </div>
                <div class="feature-card scroll-reveal">
                    <div class="feature-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h3>안전한 개인정보 보호</h3>
                    <p>최고 수준의 보안 시스템으로 개인정보를 안전하게 보호합니다.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- 통계 섹션 -->
    <section class="stats">
        <div class="container">
            <div class="stats-grid">
                <div class="stat-item scroll-reveal">
                    <span class="stat-number">10,000+</span>
                    <span class="stat-label">활성 사용자</span>
                </div>
                <div class="stat-item scroll-reveal">
                    <span class="stat-number">50,000+</span>
                    <span class="stat-label">식품 데이터</span>
                </div>
                <div class="stat-item scroll-reveal">
                    <span class="stat-number">98%</span>
                    <span class="stat-label">고객 만족도</span>
                </div>
                <div class="stat-item scroll-reveal">
                    <span class="stat-number">24/7</span>
                    <span class="stat-label">고객 지원</span>
                </div>
            </div>
        </div>
    </section>

    <!-- 푸터 -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3><i class="fas fa-leaf"></i> Sol-Food</h3>
                    <p>건강한 식단과 영양 관리의 새로운 기준을 제시하는 Sol-Food입니다.</p>
                </div>
                <div class="footer-section">
                    <h3>서비스</h3>
                    <p><a href="#">영양 분석</a></p>
                    <p><a href="#">식단 관리</a></p>
                    <p><a href="#">전문가 상담</a></p>
                    <p><a href="#">모바일 앱</a></p>
                </div>
                <div class="footer-section">
                    <h3>고객 지원</h3>
                    <p><a href="#">자주 묻는 질문</a></p>
                    <p><a href="#">1:1 문의</a></p>
                    <p><a href="#">이용약관</a></p>
                    <p><a href="#">개인정보처리방침</a></p>
                </div>
                <div class="footer-section">
                    <h3>연락처</h3>
                    <p><i class="fas fa-phone"></i> 1588-1234</p>
                    <p><i class="fas fa-envelope"></i> info@sol-food.com</p>
                    <p><i class="fas fa-map-marker-alt"></i> 서울시 강남구 테헤란로 123</p>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2024 Sol-Food. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script>
        // 스크롤 애니메이션
        function revealOnScroll() {
            const reveals = document.querySelectorAll('.scroll-reveal');
            
            reveals.forEach(element => {
                const windowHeight = window.innerHeight;
                const elementTop = element.getBoundingClientRect().top;
                const elementVisible = 150;
                
                if (elementTop < windowHeight - elementVisible) {
                    element.classList.add('revealed');
                }
            });
        }

        // 부드러운 스크롤
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // 헤더 스크롤 효과
        window.addEventListener('scroll', function() {
            const header = document.querySelector('.header');
            if (window.scrollY > 100) {
                header.style.background = 'rgba(102, 126, 234, 0.95)';
            } else {
                header.style.background = 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)';
            }
        });

        // 통계 숫자 애니메이션
        function animateNumbers() {
            const numbers = document.querySelectorAll('.stat-number');
            numbers.forEach(number => {
                const target = parseInt(number.textContent.replace(/[^0-9]/g, ''));
                const suffix = number.textContent.replace(/[0-9]/g, '');
                let current = 0;
                const increment = target / 100;
                
                const timer = setInterval(() => {
                    current += increment;
                    if (current >= target) {
                        current = target;
                        clearInterval(timer);
                    }
                    number.textContent = Math.floor(current) + suffix;
                }, 20);
            });
        }

        // 페이지 로드 시 실행
        window.addEventListener('load', function() {
            revealOnScroll();
            setTimeout(animateNumbers, 1000);
        });

        // 스크롤 이벤트
        window.addEventListener('scroll', revealOnScroll);
    </script>
</body>
</html>