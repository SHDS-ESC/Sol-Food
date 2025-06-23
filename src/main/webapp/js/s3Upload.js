/**
 * S3 파일 업로드 유틸리티
 */
class S3FileUploader {
    
    constructor() {
        this.apiBasePath = '/solfood/api/file';
    }
    
    /**
     * 프로필 이미지 업로드
     * @param {File} file - 업로드할 파일
     * @param {Function} onProgress - 진행률 콜백 (선택적)
     * @returns {Promise<string>} - 업로드된 파일의 S3 URL
     */
    async uploadProfileImage(file, onProgress = null) {
        try {
            // 1. 파일 검증
            if (!this.validateImageFile(file)) {
                throw new Error('지원하지 않는 파일 형식입니다. (jpg, jpeg, png, gif만 가능)');
            }
            
            // 2. 파일 확장자 추출
            const fileExtension = this.getFileExtension(file.name);
            
            // 3. Pre-signed URL 요청
            const uploadUrlResponse = await this.requestUploadUrl(fileExtension);
            
            if (!uploadUrlResponse.success) {
                throw new Error(uploadUrlResponse.message);
            }
            
            // 4. S3에 파일 직접 업로드
            await this.uploadToS3(uploadUrlResponse.presignedUrl, file, onProgress);
            
            // 5. 업로드 완료 후 공개 URL 받기
            const publicUrlResponse = await this.getPublicUrl(uploadUrlResponse.fileName);
            
            if (!publicUrlResponse.success) {
                throw new Error(publicUrlResponse.message);
            }
            
            return publicUrlResponse.fileUrl;
            
        } catch (error) {
            console.error('파일 업로드 실패:', error);
            throw error;
        }
    }
    
    /**
     * Pre-signed URL 요청
     */
    async requestUploadUrl(fileExtension) {
        const response = await fetch(`${this.apiBasePath}/profile/upload-url`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                fileExtension: fileExtension
            })
        });
        
        return await response.json();
    }
    
    /**
     * S3에 파일 직접 업로드
     */
    async uploadToS3(presignedUrl, file, onProgress) {
        return new Promise((resolve, reject) => {
            const xhr = new XMLHttpRequest();
            
            // 진행률 추적
            if (onProgress) {
                xhr.upload.addEventListener('progress', (event) => {
                    if (event.lengthComputable) {
                        const percentComplete = (event.loaded / event.total) * 100;
                        onProgress(percentComplete);
                    }
                });
            }
            
            xhr.addEventListener('load', () => {
                if (xhr.status === 200) {
                    resolve();
                } else {
                    reject(new Error(`S3 업로드 실패: ${xhr.status}`));
                }
            });
            
            xhr.addEventListener('error', () => {
                reject(new Error('S3 업로드 중 오류 발생'));
            });
            
            xhr.open('PUT', presignedUrl);
            xhr.setRequestHeader('Content-Type', file.type);
            xhr.send(file);
        });
    }
    
    /**
     * 업로드 완료 후 공개 URL 받기
     */
    async getPublicUrl(fileName) {
        const response = await fetch(`${this.apiBasePath}/profile/complete`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                fileName: fileName
            })
        });
        
        return await response.json();
    }
    
    /**
     * 이미지 파일 검증
     */
    validateImageFile(file) {
        const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
        const maxSize = 5 * 1024 * 1024; // 5MB
        
        if (!allowedTypes.includes(file.type)) {
            return false;
        }
        
        if (file.size > maxSize) {
            alert('파일 크기는 5MB 이하여야 합니다.');
            return false;
        }
        
        return true;
    }
    
    /**
     * 파일 확장자 추출
     */
    getFileExtension(fileName) {
        return fileName.split('.').pop().toLowerCase();
    }
}

// 전역 인스턴스 생성
const s3Uploader = new S3FileUploader();

/**
 * 사용 예제 함수
 */
async function handleProfileImageUpload(fileInput) {
    const file = fileInput.files[0];
    if (!file) return;
    
    try {
        // 로딩 UI 표시
        showUploadProgress(true);
        
        // 파일 업로드
        const s3Url = await s3Uploader.uploadProfileImage(file, (progress) => {
            updateUploadProgress(progress);
        });
        
        console.log('업로드 완료! S3 URL:', s3Url);
        
        // 프로필 이미지 미리보기 업데이트
        updateProfilePreview(s3Url);
        
        // 숨겨진 input에 S3 URL 저장 (회원가입 시 사용)
        document.getElementById('usersProfile').value = s3Url;
        
    } catch (error) {
        alert('파일 업로드 실패: ' + error.message);
    } finally {
        showUploadProgress(false);
    }
}

/**
 * UI 헬퍼 함수들
 */
function showUploadProgress(show) {
    const progressDiv = document.getElementById('uploadProgress');
    if (progressDiv) {
        progressDiv.style.display = show ? 'block' : 'none';
    }
}

function updateUploadProgress(percent) {
    const progressBar = document.getElementById('uploadProgressBar');
    const progressText = document.getElementById('uploadProgressText');
    
    if (progressBar) {
        progressBar.style.width = percent + '%';
    }
    if (progressText) {
        progressText.textContent = Math.round(percent) + '%';
    }
}

function updateProfilePreview(imageUrl) {
    const preview = document.getElementById('profilePreview');
    if (preview) {
        preview.src = imageUrl;
        preview.style.display = 'block';
    }
} 