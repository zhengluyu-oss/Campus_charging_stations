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

export async function getNewsList() {
    const categories = ['event', 'policy', 'lost'];
    const responses: any[] = await Promise.all(categories.map(newsCategory => request({
        url: '/news/listByCategory',
        method: 'post',
        data: { newsCategory }
    })));
    return { data: responses.flatMap(response => Array.isArray(response?.data) ? response.data : []) };
}

export function getNewsByCategory(categoryId: number) {
    const categories: Record<number, string> = { 1: 'event', 2: 'policy', 3: 'lost' };
    return request({
        url: '/news/listByCategory',
        method: 'post',
        data: { newsCategory: categories[categoryId] || 'policy' }
    });
}
