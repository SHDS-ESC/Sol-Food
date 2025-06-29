const ctx = window.APP_CTX;

document.addEventListener('DOMContentLoaded', function() {
    const observer = new IntersectionObserver((entries) => {
        entries.forEach((entry) => {
            if (entry.isIntersecting) {
                entry.target.style.animation = 'slideUp 0.6s ease-out';
            }
        });
    });

    document.querySelectorAll('.detail-card').forEach((card) => {
        observer.observe(card);
    });

    window.addEventListener('scroll', () => {
        const scrolled = window.pageYOffset;
        const particles = document.querySelectorAll('.particle');

        particles.forEach((particle, index) => {
            const speed = (index + 1) * 0.1;
            particle.style.transform = `translateY(${scrolled * speed}px)`;
        });
    });

    $(document).on('change', '.status-select', function () {
        const status = $(this).val();
        const urlParams = new URLSearchParams(window.location.search);
        const ownerId = urlParams.get('ownerId');
        if(status === '승인거절'){
            openRejectionModal()
        }
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

    function showPopup() { window.open("reject-popup", "a", "width=400, height=300, left=100, top=50"); }
});

// Form validation and interaction
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('rejectionForm');
    const textarea = document.querySelector('textarea[name="detailedReason"]');
    const charCount = document.getElementById('charCount');
    const submitBtn = document.getElementById('submitBtn');
    const reasonOptions = document.querySelectorAll('input[name="rejectionReason"]');

    // Character count update
    textarea.addEventListener('input', function() {
        const currentLength = this.value.length;
        charCount.textContent = currentLength;

        if (currentLength > 450) {
            charCount.style.color = '#f56565';
        } else {
            charCount.style.color = 'rgba(255, 255, 255, 0.6)';
        }

        validateForm();
    });

    // Reason option selection
    reasonOptions.forEach(option => {
        option.addEventListener('change', function() {
            // Remove selected class from all options
            document.querySelectorAll('.reason-option').forEach(opt => {
                opt.classList.remove('selected');
            });

            // Add selected class to current option
            this.closest('.reason-option').classList.add('selected');

            validateForm();
        });
    });

    // Form validation
    function validateForm() {
        const selectedReason = document.querySelector('input[name="rejectionReason"]:checked');
        const detailedReason = textarea.value.trim();

        if (selectedReason && detailedReason.length >= 10) {
            submitBtn.disabled = false;
            submitBtn.style.opacity = '1';
        } else {
            submitBtn.disabled = true;
            submitBtn.style.opacity = '0.6';
        }
    }

    // Form submission
    form.addEventListener('submit', function(e) {
        e.preventDefault();

        const selectedReason = document.querySelector('input[name="rejectionReason"]:checked');
        const detailedReason = textarea.value.trim();

        if (!selectedReason || detailedReason.length < 10) {
            alert('거절 사유를 선택하고 상세 내용을 10자 이상 입력해주세요.');
            return;
        }

        // Show loading state
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 처리중...';
        submitBtn.disabled = true;

        // Simulate API call
        setTimeout(() => {
            alert('거절 사유가 성공적으로 등록되었습니다.');
            closeModal();
        }, 2000);
    });

    // Add parallax effect to particles
    window.addEventListener('scroll', () => {
        const scrolled = window.pageYOffset;
        const particles = document.querySelectorAll('.particle');

        particles.forEach((particle, index) => {
            const speed = (index + 1) * 0.1;
            particle.style.transform = `translateY(${scrolled * speed}px)`;
        });
    });
});

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


// Close modal when clicking outside
document.getElementById('rejectionModal').addEventListener('click', function(e) {
    if (e.target === this) {
        closeModal();
    }
});

// ESC key to close modal
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeModal();
    }
});

function openRejectionModal() {
    const modal = document.getElementById('rejectionModal');
    modal.style.display = 'flex';
    modal.style.animation = 'fadeIn 0.3s ease-out';
}