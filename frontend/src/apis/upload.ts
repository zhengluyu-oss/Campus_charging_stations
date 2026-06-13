import request from "../utils/request.ts";

//上传图片（管理员）
export function uploadImage(rawFile: any) {
    return request({
        url: '/user-api/upload/image',
        method: 'post',
        data: {image: rawFile}
    })
}

//上传头像（用户）
export function uploadAvatar(imageFile: any) {
    const formData = new FormData();
    formData.append('image', imageFile);

    return request({
        url: '/upload/image',
        method: 'post',
        data: formData,
        headers: {
            'Content-Type': 'multipart/form-data'
        }
    });
}

//上传视频
export function uploadVideo(rawFile: any) {
    return request({
        url: '/user-api/upload/video',
        method: 'post',
        data: {video: rawFile}
    })
}

//上传文件
export function uploadFile(rawFile: any) {
    return request({
        url: '/user-api/upload/file',
        method: 'post',
        data: {file: rawFile}
    })
}
