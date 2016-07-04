//
//  UIScrollView+LeeRefresh.m
//  MJ加载
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import "UIScrollView+LeeRefresh.h"
#import "LeeRefreshHeaderView.h"
#import "LeeRefreshFooterView.h"
#import <objc/runtime.h>

static char LeeRefreshHeaderViewKey;
static char LeeRefreshFooterViewKey;

@interface UIScrollView ()

@property (nonatomic,strong) LeeRefreshHeaderView *header;
@property (nonatomic,strong) LeeRefreshFooterView *footer;

@end

@implementation UIScrollView (LeeRefresh)

#pragma mark - 头部刷新的操作

#pragma mark - 添加属性值
- (void)setHeader:(LeeRefreshHeaderView *)header {
    
    objc_setAssociatedObject(self, &LeeRefreshHeaderViewKey,
                             header,
                             OBJC_ASSOCIATION_RETAIN);
}

- (LeeRefreshHeaderView *)header {
    
    return objc_getAssociatedObject(self, &LeeRefreshHeaderViewKey);
}

/**
 *  添加一个下拉刷新头部控件
 *
 *  @param callback 回调
 */
- (void)addHeaderWithCallback:(void (^)())callback {
    // 1.创建新的header
    if (!self.header) {
        LeeRefreshHeaderView *header = [[LeeRefreshHeaderView alloc]init];
        [self addSubview:header];
        self.header = header;
    }
    // 2.设置block回调
    self.header.beginRefreshingCallback = callback;
}

/**
 *  主动让下拉刷新头部控件进入刷新状态
 */
- (void)headerBeginRefreshing {
    
    [self.header beginRefreshing];
}

/**
 *  让下拉刷新头部控件停止刷新状态
 */
- (void)headerEndRefreshing {
    
    [self.header endRefreshing];
}

/**
 *  移除下拉刷新头部控件
 */
- (void)removeHeader {
    
    [self headerEndRefreshing];
    [self.header removeFromSuperview];
    self.header = nil;
    
}

#pragma mark -footerRefresh

- (void)setFooter:(LeeRefreshFooterView *)footer {

    objc_setAssociatedObject(self, &LeeRefreshFooterViewKey,
                             footer,
                             OBJC_ASSOCIATION_RETAIN);

}

- (LeeRefreshFooterView *)footer {
    return objc_getAssociatedObject(self, &LeeRefreshFooterViewKey);
}

/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param callback 回调
 */
- (void)addFooterWithCallback:(void (^)())callback {
    
    // 1.创建新的footer
    if (!self.footer) {
        LeeRefreshFooterView *footer = [[LeeRefreshFooterView alloc]init];
        [self addSubview:footer];
        self.footer = footer;
    }
    
    // 2.设置block回调
    self.footer.beginRefreshingCallback = callback;
}

/**
 *  主动让上拉刷新尾部控件进入刷新状态
 */
- (void)footerBeginRefreshing {
    
    [self.footer beginRefreshing];
}

/**
 *  让上拉刷新尾部控件停止刷新状态
 */
- (void)footerEndRefreshing {
    
    [self.footer endRefreshing];
}

/**
 *  移除上拉刷新尾部控件
 */
- (void)removeFooter {
    
    [self footerEndRefreshing];
    [self.footer removeFromSuperview];
    self.footer = nil;
}


@end
