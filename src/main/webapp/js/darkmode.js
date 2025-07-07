// 다크모드 상태 관리
let isDarkMode = localStorage.getItem('darkMode') === 'true';

// 다크모드 토글 버튼 요소
const darkModeToggle = document.getElementById('darkmode-toggle');
const darkModeIcon = darkModeToggle.querySelector('i');

// 다크모드 적용 함수
function enableDarkMode() {
    document.body.classList.add('dark');
    darkModeIcon.className = 'bi bi-sun';
    localStorage.setItem('darkMode', 'true');
    isDarkMode = true;
}

// 다크모드 해제 함수
function disableDarkMode() {
    document.body.classList.remove('dark');
    darkModeIcon.className = 'bi bi-moon';
    localStorage.setItem('darkMode', 'false');
    isDarkMode = false;
}

// 초기 다크모드 상태 설정
if (isDarkMode) {
    enableDarkMode();
} else {
    disableDarkMode();
}

// 다크모드 토글 이벤트 리스너
darkModeToggle.addEventListener('click', () => {
    isDarkMode ? disableDarkMode() : enableDarkMode();
}); 