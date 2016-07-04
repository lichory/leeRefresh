//
//  UIScrollView+LeeExtension.h
//  lee加载
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (LeeExtension)

@property (assign, nonatomic) CGFloat lee_contentInsetTop;
@property (assign, nonatomic) CGFloat lee_contentInsetBottom;
@property (assign, nonatomic) CGFloat lee_contentInsetLeft;
@property (assign, nonatomic) CGFloat lee_contentInsetRight;

@property (assign, nonatomic) CGFloat lee_contentOffsetX;
@property (assign, nonatomic) CGFloat lee_contentOffsetY;

@property (assign, nonatomic) CGFloat lee_contentSizeWidth;
@property (assign, nonatomic) CGFloat lee_contentSizeHeight;

@end
