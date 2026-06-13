import request from '@/utils/request';

export interface NewsPublishData {
    title: string;
    content: string;
    categoryId: number;
    imageUrl: string;
    publishDate: string;
    newsCategory: string;
}

export function publishNews(data: NewsPublishData) {
    return request({
        url: '/news/publish',
        method: 'post',
        data
    });
}

export function getNewsList() {
    return request({
        url: '/news/list',
        method: 'get'
    });
}

export function getNewsByCategory(categoryId: number) {
    return request({
        url: `/news/category/${categoryId}`,
        method: 'get'
    });
}
