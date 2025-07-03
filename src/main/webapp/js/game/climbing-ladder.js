let ladderData = [];
let currentParticipants = 4;
let currentLines = 10;

function generateLadder() {
    currentParticipants = parseInt(document.getElementById('participants').value);
    currentLines = parseInt(document.getElementById('lines').value);

    if (currentParticipants < 2 || currentParticipants > 10) {
        alert('참가자 수는 2~10명 사이로 설정해주세요!');
        return;
    }

    if (currentLines < 5 || currentLines > 20) {
        alert('가로줄 수는 5~20개 사이로 설정해주세요!');
        return;
    }

    generateLabels();
    createLadder();
    document.getElementById('result').classList.remove('show');
}

function generateLabels() {
    const container = document.getElementById('labelsContainer');
    container.innerHTML = '';

    const startDiv = document.createElement('div');
    startDiv.innerHTML = '<h4 style="margin-bottom: 10px; color: #667eea;">시작점 (참가자)</h4>';
    for (let i = 0; i < currentParticipants; i++) {
        const input = document.createElement('input');
        input.type = 'text';
        input.className = 'label-input';
        input.placeholder = `참가자 ${i + 1}`;
        input.id = `start-${i}`;
        startDiv.appendChild(input);
    }

    const endDiv = document.createElement('div');
    endDiv.innerHTML = '<h4 style="margin: 20px 0 10px; color: #ff6b6b;">도착점 (결과)</h4>';
    for (let i = 0; i < currentParticipants; i++) {
        const input = document.createElement('input');
        input.type = 'text';
        input.className = 'label-input';
        input.placeholder = `결과 ${i + 1}`;
        input.id = `end-${i}`;
        endDiv.appendChild(input);
    }

    container.appendChild(startDiv);
    container.appendChild(endDiv);
}

function createLadder() {
    const ladderElement = document.getElementById('ladder');
    ladderElement.innerHTML = '';

    ladderData = [];

    // 각 참가자의 세로줄에 대한 가로선 데이터 초기화
    for (let i = 0; i < currentParticipants; i++) {
        ladderData[i] = [];
        for (let j = 0; j < currentLines; j++) {
            ladderData[i][j] = false;
        }
    }

    // 랜덤하게 가로선 생성 (연속된 가로선 방지)
    for (let line = 0; line < currentLines; line++) {
        for (let col = 0; col < currentParticipants - 1; col++) {
            const shouldHaveLine = Math.random() > 0.6;
            if (shouldHaveLine && !ladderData[col][line]) {
                ladderData[col][line] = true;
                col++; // 다음 열은 건너뛰어 연속된 가로선 방지
            }
        }
    }

    // 시각적 사다리 생성
    const lineHeight = 400 / currentLines;

    for (let i = 0; i < currentParticipants; i++) {
        const ladderLine = document.createElement('div');
        ladderLine.className = 'ladder-line';

        const verticalLine = document.createElement('div');
        verticalLine.className = 'vertical-line';
        verticalLine.style.height = '400px';

        // 시작 라벨 (클릭 가능)
        const startLabel = document.createElement('div');
        startLabel.className = 'start-label';
        startLabel.textContent = `시작 ${i + 1}`;
        startLabel.onclick = () => playLadder(i);
        verticalLine.appendChild(startLabel);

        // 도착 라벨
        const endLabel = document.createElement('div');
        endLabel.className = 'end-label';
        endLabel.textContent = `결과 ${i + 1}`;
        verticalLine.appendChild(endLabel);

        // 가로선 추가
        for (let j = 0; j < currentLines; j++) {
            if (ladderData[i][j]) {
                const horizontalLine = document.createElement('div');
                horizontalLine.className = 'horizontal-line';
                horizontalLine.style.top = (j * lineHeight + lineHeight / 2) + 'px';
                verticalLine.appendChild(horizontalLine);
            }
        }

        ladderLine.appendChild(verticalLine);
        ladderElement.appendChild(ladderLine);
    }

    addSparkles();
}

function addSparkles() {
    const ladder = document.getElementById('ladder');
    for (let i = 0; i < 10; i++) {
        setTimeout(() => {
            const sparkle = document.createElement('div');
            sparkle.className = 'sparkle';
            sparkle.style.left = Math.random() * 100 + '%';
            sparkle.style.top = Math.random() * 100 + '%';
            sparkle.style.animationDelay = Math.random() * 2 + 's';
            ladder.appendChild(sparkle);

            setTimeout(() => {
                if (sparkle.parentNode) {
                    sparkle.parentNode.removeChild(sparkle);
                }
            }, 3000);
        }, i * 200);
    }
}

function playLadder(startCol) {
    if (ladderData.length === 0) {
        alert('먼저 사다리를 생성해주세요!');
        return;
    }

    // 기존 활성 상태 제거
    document.querySelectorAll('.start-label').forEach(label => {
        label.classList.remove('active');
    });

    // 클릭한 시작점 활성화
    document.querySelectorAll('.start-label')[startCol].classList.add('active');

    const result = tracePath(startCol);
    showPath(startCol, result.path);

    setTimeout(() => {
        const startName = document.getElementById(`start-${startCol}`).value || `참가자 ${startCol + 1}`;
        const endName = document.getElementById(`end-${result.end}`).value || `결과 ${result.end + 1}`;

        showResult(startName, endName);
    }, result.path.length * 200);
}

function tracePath(startCol) {
    let currentCol = startCol;
    const path = [];
    const lineHeight = 400 / currentLines;

    for (let line = 0; line < currentLines; line++) {
        const currentTop = line * lineHeight;
        const nextTop = (line + 1) * lineHeight;

        // 현재 위치에서 오른쪽으로 가는 가로선이 있는지 확인
        if (currentCol < currentParticipants - 1 && ladderData[currentCol][line]) {
            // 반 높이까지 세로 이동
            path.push({
                type: 'vertical',
                col: currentCol,
                top: currentTop,
                height: lineHeight / 2
            });
            // 가로 이동
            path.push({
                type: 'horizontal',
                col: currentCol,
                top: currentTop + lineHeight / 2 - 3
            });
            currentCol++;
            // 나머지 반 높이 세로 이동
            path.push({
                type: 'vertical',
                col: currentCol,
                top: currentTop + lineHeight / 2,
                height: lineHeight / 2
            });
        }
        // 왼쪽에서 오는 가로선이 있는지 확인
        else if (currentCol > 0 && ladderData[currentCol - 1][line]) {
            // 반 높이까지 세로 이동
            path.push({
                type: 'vertical',
                col: currentCol,
                top: currentTop,
                height: lineHeight / 2
            });
            // 가로 이동
            path.push({
                type: 'horizontal',
                col: currentCol - 1,
                top: currentTop + lineHeight / 2 - 3
            });
            currentCol--;
            // 나머지 반 높이 세로 이동
            path.push({
                type: 'vertical',
                col: currentCol,
                top: currentTop + lineHeight / 2,
                height: lineHeight / 2
            });
        }
        // 가로선이 없으면 직진
        else {
            path.push({
                type: 'vertical',
                col: currentCol,
                top: currentTop,
                height: lineHeight
            });
        }
    }

    return { end: currentCol, path: path };
}

function showPath(startCol, path) {
    // 기존 경로 제거
    const existingPaths = document.querySelectorAll('.selected-path');
    existingPaths.forEach(pathEl => pathEl.remove());

    const ladderLines = document.querySelectorAll('.ladder-line');

    // 각 경로 요소를 순차적으로 표시
    path.forEach((pathElement, index) => {
        setTimeout(() => {
            const targetLine = ladderLines[pathElement.col].querySelector('.vertical-line');
            const pathEl = document.createElement('div');
            pathEl.className = 'selected-path';

            if (pathElement.type === 'vertical') {
                pathEl.classList.add('path-vertical');
                pathEl.style.top = pathElement.top + 'px';
                pathEl.style.height = pathElement.height + 'px';
            } else if (pathElement.type === 'horizontal') {
                pathEl.classList.add('path-horizontal');
                pathEl.style.top = pathElement.top + 'px';
            }

            targetLine.appendChild(pathEl);
        }, index * 200);
    });
}

function showResult(startName, endName) {
    const resultElement = document.getElementById('result');
    resultElement.innerHTML = `
                <h3>🎉 결과 발표! 🎉</h3>
                <p><strong>${startName}</strong> → <strong>${endName}</strong></p>
            `;
    resultElement.classList.add('show');
}

function resetLadder() {
    document.getElementById('ladder').innerHTML = '';
    document.getElementById('result').classList.remove('show');
    document.getElementById('result').innerHTML = '';
    document.querySelectorAll('.start-label').forEach(label => {
        label.classList.remove('active');
    });
    ladderData = [];
}

// 초기 사다리 생성
generateLadder();