//
//  UIScrollView+LeeRefresh.h
//  MJ加载
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (LeeRefresh)

#pragma mark - 头部刷新
/**
 *  添加一个下拉刷新头部控件
 *
 *  @param callback 回调
 */
- (void)addHeaderWithCallback:(void (^)())callback;
/**
 *  主动让下拉刷新头部控件进入刷新状态
 */
- (void)headerBeginRefreshing;
/**
 *  让下拉刷新头部控件停止刷新状态
 */
- (void)headerEndRefreshing;

/**
 *  移除下拉刷新头部控件
 */
- (void)removeHeader;

#pragma mark - 尾部刷新
/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param callback 回调
 */
- (void)addFooterWithCallback:(void (^)())callback;
/**
 *  主动让上拉刷新尾部控件进入刷新状态
 */
- (void)footerBeginRefreshing;
/**
 *  让上拉刷新尾部控件停止刷新状态
 */
- (void)footerEndRefreshing;
/**
 *  移除上拉刷新尾部控件
 */
- (void)removeFooter;
@end
