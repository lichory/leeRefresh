//
//  LeeRefreshConst.h
//  Lee加载
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


// 文字颜色
#define LeeRefreshLabelTextColor [UIColor colorWithWhite:150/255.0 alpha:1]
/* 资源文件里面的内容**/
#define LeeRefreshSrcName(file) [@"LeeRefresh.bundle" stringByAppendingPathComponent:file]

/* 视图的高度 **/
extern const CGFloat LeeRefreshViewHeight;
/* 隐藏 和 显示 动画的 快速 和 缓慢 的时间 **/
extern const CGFloat LeeRefreshFastAnimationDuration;
extern const CGFloat LeeRefreshSlowAnimationDuration;

/* 刷新的时间 **/
extern NSString *const LeeRefreshTimeKey;

/* 偏移量 和 size 改变的 kvo 中的key **/
extern NSString *const LeeRefreshContentOffset;
extern NSString *const LeeRefreshContentSize;

@interface LeeRefreshConst : NSObject

@end
