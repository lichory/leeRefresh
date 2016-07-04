//
//  UIView+LeeExtension.m
//  lee加载
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import "UIView+LeeExtension.h"

@implementation UIView (LeeExtension)

- (void)setLee_x:(CGFloat)lee_x {
    
    CGRect frame = self.frame;
    frame.origin.x = lee_x;
    self.frame = frame;
}

- (CGFloat)lee_x {
    
    return self.frame.origin.x;
}

- (void)setLee_y:(CGFloat)lee_y {
    
    CGRect frame = self.frame;
    frame.origin.y = lee_y;
    self.frame = frame;
}

- (CGFloat)lee_y {
    
    return self.frame.origin.y;
}

- (void)setLee_width:(CGFloat)lee_width {
    
    CGRect frame = self.frame;
    frame.size.width = lee_width;
    self.frame = frame;
}

- (CGFloat)lee_width {
    
    return self.frame.size.width;
}

- (void)setLee_height:(CGFloat)lee_height {
    
    CGRect frame = self.frame;
    frame.size.height = lee_height;
    self.frame = frame;
}

- (CGFloat)lee_height {
    
    return self.frame.size.height;
}

- (void)setLee_size:(CGSize)lee_size {
    
    CGRect frame = self.frame;
    frame.size = lee_size;
    self.frame = frame;
}

- (CGSize)lee_size {
    
    return self.frame.size;
}

- (void)setLee_origin:(CGPoint)lee_origin {
    
    CGRect frame = self.frame;
    frame.origin = lee_origin;
    self.frame = frame;
}

- (CGPoint)lee_origin {
    
    return self.frame.origin;
}

@end
