document.getElementById('all-menu-btn').onclick = function() {
    document.getElementById('all-menu-overlay').style.display = 'block';
};
document.getElementById('close-all-menu').onclick = function() {
    document.getElementById('all-menu-overlay').style.display = 'none';
};
document.getElementById('all-menu-overlay').onclick = function(e) {
    if (e.target === this) this.style.display = 'none';
};

// 로고 테마 변경 함수
function setLogoByTheme() {
    const mainLogo = document.getElementById('mainLogo');
    if (!mainLogo) return;
    
    const isDarkMode = document.body.classList.contains('dark');
    const logoPath = isDarkMode ? 
        window.contextPath + '/img/logo-dark.png' : 
        window.contextPath + '/img/logo.png';
    
    // 로고 파일 존재 여부 확인 후 변경
    const img = new Image();
    img.onload = function() {
        mainLogo.src = logoPath;
    };
    img.onerror = function() {
        // 다크모드 로고가 없으면 기본 로고 유지
        console.log('다크모드 로고를 찾을 수 없습니다. 기본 로고를 사용합니다.');
    };
    img.src = logoPath;
}
