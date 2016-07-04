//
//  LeeRefreshBaseView.h
//  MJ加载
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LeeRefreshConst.h"
#import "UIView+LeeExtension.h"
#import "UIScrollView+LeeExtension.h"
#import "UIScrollView+LeeRefresh.h"

/*
 * 思路 状态 ==控制==》 1.状态文字 2.状态箭头 3.状态转圈圈
 * 
   baseview(初始化一些公共的控件)
    /   \
   /     \
  Head   footer
  
  我的意思是：不要在baseView中设置 setStatus，这些逻辑都放到他的子控件里面处理
 
 **/

typedef NS_ENUM(NSInteger,LeeRefreshStatus) {
    
    LeeRefreshStatusNormal = 1 ,/* 默认的正常的状态 (下拉可以刷新)**/
    LeeRefreshStatusPulling ,/* 下拉或者的状态(松开立即刷新)**/
    LeeRefreshStatusRefreshing, /* 正在刷新的状态（正在刷新） **/
    LeeRefreshStatusNone /* 一个空的状态**/
};


@interface LeeRefreshBaseView : UIView

#pragma mark - 公共的状态和图片状态
/* 状态**/
@property (assign, nonatomic) LeeRefreshStatus status;

/* 状态文字 **/
@property (nonatomic,readonly) UILabel * statusLabel;
/* 状态图片 **/
@property (nonatomic,readonly) UIImageView * arrowImageView;
/* 状态圈圈**/
@property (nonatomic,readonly) UIActivityIndicatorView *activityView;

/**
 *  是否正在刷新
 */
@property (nonatomic,assign,readonly) BOOL isRefreshing;

#pragma mark - 父视图 保留
/* 保留父亲视图的**/
@property (nonatomic,weak,readonly) UIScrollView *scrollView;
@property (nonatomic,assign,readonly) UIEdgeInsets scrollViewOriginalInset;

#pragma mark - 公共的方法

@property (nonatomic, copy) void (^beginRefreshingCallback)();
/**
 *  开始刷新
 */
- (void)beginRefreshing;
/**
 *  结束刷新
 */
- (void)endRefreshing;

@end
