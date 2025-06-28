let hasDrawn = false;

const prizes = [
    {id: 'prize-sangUn', name: '이상윤', message: '🎉 이상윤님이 카드로 계산합니다!', probability: 19},
    {id: 'prize-jiwon', name: '박지원', message: '🎉 박지원님이 카드로 계산합니다!', probability: 19},
    {id: 'prize-gahee', name: '오가희', message: '🎉 오가희님이 카드로 계산합니다!', probability: 19},
    {id: 'prize-sunwoo', name: '이선우', message: '🎉 이선우님이 카드로 계산합니다!', probability: 19},
    {id: 'prize-minseok', name: '안민석', message: '🎉 안민석님이 카드로 계산합니다!', probability: 19},
    {id: 'prize-again', name: '다시 뽑기', message: '🔄 다시 한번 뽑아주세요!', probability: 5}
];

function drawPrize() {
    if (hasDrawn) return;

    const button = document.getElementById('lotteryButton');
    const screen = document.getElementById('lotteryScreen');

    // 버튼 비활성화 및 애니메이션
    button.disabled = true;
    button.classList.add('spinning');

    // 화면에 추첨 중 표시
    screen.innerHTML = '🎲 추첨 중...<br>두근두근 ❤️';

    // 랜덤 추첨 시뮬레이션
    let counter = 0;
    const maxCount = 20 + Math.floor(Math.random() * 20); // 2-4초 정도

    const interval = setInterval(() => {
        const randomPrize = prizes[Math.floor(Math.random() * prizes.length)];
        screen.innerHTML = `🎲 추첨 중...<br>${randomPrize.name}`;
        counter++;

        if (counter >= maxCount) {
            clearInterval(interval);
            finalDraw();
        }
    }, 100);
}

function finalDraw() {
    // 확률에 따른 실제 추첨
    const random = Math.random() * 100;
    let cumulative = 0;
    let selectedPrize = null;

    for (const prize of prizes) {
        cumulative += prize.probability;
        if (random <= cumulative) {
            selectedPrize = prize;
            break;
        }
    }

    if (!selectedPrize) selectedPrize = prizes[0]; // 폴백

    // 다시 뽑기가 나온 경우 처리
    if (selectedPrize.id === 'prize-again') {
        const screen = document.getElementById('lotteryScreen');
        screen.innerHTML = selectedPrize.message;

        // 당첨된 카드 하이라이트
        document.getElementById(selectedPrize.id).classList.add('won');

        // 버튼 재활성화
        const button = document.getElementById('lotteryButton');
        button.classList.remove('spinning');
        button.disabled = false;
        button.innerHTML = '다시<br>뽑기!';
        button.style.background = 'linear-gradient(45deg, #f39c12, #e67e22)';

        return; // 게임 종료하지 않음
    }

    // 결과 표시
    const screen = document.getElementById('lotteryScreen');
    screen.innerHTML = `🎉 결과 발표! 🎉<br><br>${selectedPrize.message}`;

    // 당첨된 카드 하이라이트
    document.getElementById(selectedPrize.id).classList.add('won');

    // 축하 효과
    createCelebration();

    // 버튼 상태 변경
    const button = document.getElementById('lotteryButton');
    button.classList.remove('spinning');
    button.innerHTML = '완료!';
    button.style.background = '#2ecc71';

    hasDrawn = true;
}

function createCelebration() {
    const celebration = document.getElementById('celebration');

    // 색종이 효과
    for (let i = 0; i < 50; i++) {
        setTimeout(() => {
            const confetti = document.createElement('div');
            confetti.className = 'confetti';
            confetti.style.left = Math.random() * 100 + '%';
            confetti.style.backgroundColor = ['#ff6b6b', '#4ecdc4', '#45b7d1', '#f9ca24', '#f0932b'][Math.floor(Math.random() * 5)];
            confetti.style.animationDelay = Math.random() * 2 + 's';

            celebration.appendChild(confetti);

            setTimeout(() => {
                confetti.remove();
            }, 3000);
        }, i * 100);
    }
}

function resetGame() {
    // 게임 상태 초기화
    hasDrawn = false;

    // UI 초기화
    document.getElementById('lotteryScreen').innerHTML = '🎲 버튼을 눌러서<br>카드 계산 뽑기에 도전하세요!';

    // 버튼 초기화
    const button = document.getElementById('lotteryButton');
    button.disabled = false;
    button.innerHTML = '뽑기<br>START!';
    button.style.background = 'linear-gradient(45deg, #ff4757, #c44569)';
    button.classList.remove('spinning');

    // 당첨 카드 초기화
    document.querySelectorAll('.prize-card').forEach(card => {
        card.classList.remove('won');
    });
}

// 초기화
document.addEventListener('DOMContentLoaded', function () {
    // 초기 설정
});