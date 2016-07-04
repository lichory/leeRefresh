//
//  UIScrollView+LeeExtension.m
//  lee加载
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import "UIScrollView+LeeExtension.h"

@implementation UIScrollView (LeeExtension)

- (void)setLee_contentInsetTop:(CGFloat)lee_contentInsetTop {
    
    UIEdgeInsets inset = self.contentInset;
    inset.top = lee_contentInsetTop;
    self.contentInset = inset;
}

- (CGFloat)lee_contentInsetTop {
    
    return self.contentInset.top;
}

- (void)setLee_contentInsetBottom:(CGFloat)lee_contentInsetBottom {
    
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = lee_contentInsetBottom;
    self.contentInset = inset;
}

- (CGFloat)lee_contentInsetBottom
{
    return self.contentInset.bottom;
}

- (void)setLee_contentInsetLeft:(CGFloat)lee_contentInsetLeft {
    
    UIEdgeInsets inset = self.contentInset;
    inset.left = lee_contentInsetLeft;
    self.contentInset = inset;
}

- (CGFloat)lee_contentInsetLeft {
    
    return self.contentInset.left;
}

- (void)setLee_contentInsetRight:(CGFloat)lee_contentInsetRight {
    
    UIEdgeInsets inset = self.contentInset;
    inset.right = lee_contentInsetRight;
    self.contentInset = inset;
}

- (CGFloat)lee_contentInsetRight {
    
    return self.contentInset.right;
}

- (void)setLee_contentOffsetX:(CGFloat)lee_contentOffsetX {
    
    CGPoint offset = self.contentOffset;
    offset.x = lee_contentOffsetX;
    self.contentOffset = offset;
}

- (CGFloat)lee_contentOffsetX {
    
    return self.contentOffset.x;
}

- (void)setLee_contentOffsetY:(CGFloat)lee_contentOffsetY {
    
    CGPoint offset = self.contentOffset;
    offset.y = lee_contentOffsetY;
    self.contentOffset = offset;
}

- (CGFloat)lee_contentOffsetY {
    
    return self.contentOffset.y;
}

- (void)setLee_contentSizeWidth:(CGFloat)lee_contentSizeWidth {
    
    CGSize size = self.contentSize;
    size.width = lee_contentSizeWidth;
    self.contentSize = size;
}

- (CGFloat)lee_contentSizeWidth {
    
    return self.contentSize.width;
}

- (void)setLee_contentSizeHeight:(CGFloat)lee_contentSizeHeight {
    
    CGSize size = self.contentSize;
    size.height = lee_contentSizeHeight;
    self.contentSize = size;
}

- (CGFloat)lee_contentSizeHeight {
    
    return self.contentSize.height;
}

@end
