//request就是axios对象（经过自己处理的）
import request from "../utils/request";
import type {User} from "../viewmodel/UserModel.ts"

//登录函数，返回值是Promise对象
export function userLogin(username: string, password: string) {
    return request({
        url: '/user-api/login',//请求后端url
        method: 'post',
        //参数值封装对象，无论什么请求（json、form-urlencoded、上传文件 post请求参数值都是 对象）
        //标准写法
        //data: {username:username, password:password}
        //简化属性
        data: {username, password}
    })
}

// 更新用户信息
export function updateUser(userInfo: User, endpoint: string = '/user-api/user/update', oldPassword?: string) {
    const config: any = {
        url: endpoint,
        method: 'post',
        headers: {
            'Content-Type': 'application/json'
        },
        data: userInfo
    };

    // 如果提供了旧密码，添加到请求头或参数中
    if (oldPassword) {
        if (!config.params) config.params = {};
        config.params.oldPassword = oldPassword;
    }

    return request(config);
}

// 更新个人信息（匹配后端接口）
export function updateOwnMessage(userId: number, username: string, password: string, avatarPath: string, email: string, phone: string, userType: string = 'student') {
    return request({
        url: '/user/updateOwnMessage',
        method: 'post',
        headers: {
            'Content-Type': 'application/json'
        },
        data: {
            userId,
            username,
            password,
            avatarPath,
            email,
            phone,
            userType
        }
    });
}

// 获取当前用户信息
export function getCurrentUser() {
    return request({
        url: '/user-api/user/current',
        method: 'get'
    })
}

/**
 * 更改密码函数
 */
export function changePassword(oldPassword: string, newPassword: string) {
    return request({
        url: '/user-api/user/changePassword',
        method: 'post',
        data: {
            oldPassword,
            newPassword
        }
    })
}

/**
 * 用户注册函数
 * @param username 用户名
 * @param password 密码
 * @param email 邮箱
 * @param phone 手机号
 * @param userType 用户类型（student/teacher）
 */
export function userRegister(username: string, password: string, email: string, phone: string, userType: string = 'student') {
    return request({
        url: '/user-api/register',
        method: 'post',
        data: {
            username,
            password,
            email,
            phone,
            userType
        }
    })
}

