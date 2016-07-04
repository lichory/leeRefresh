//
//  LeeRefreshFooterView.m
//  Lee加载
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import "LeeRefreshFooterView.h"

@implementation LeeRefreshFooterView

#pragma mark --- 视图生命周期  -----

- (void)dealloc {
    
    [self.scrollView removeObserver:self forKeyPath:LeeRefreshContentSize context:nil];
}

// 初始化 重写
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupViews];
        
        [self configSubviews];
        
        self.status = LeeRefreshStatusNormal;
    }
    return self;
}

/* 重新布局视图 **/
- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self configSubviews];
}

/* 将要移动到父视图中**/
- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    [super willMoveToSuperview:newSuperview];
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:LeeRefreshContentSize context:nil];
    if (newSuperview) {
        
        /* 设置frame **/
        self.frame = CGRectMake(0, 0, newSuperview.lee_width, LeeRefreshViewHeight);
        // 重新调整frame
        [self adjustFrameWithContentSize];
        [newSuperview addObserver:self forKeyPath:LeeRefreshContentSize options:NSKeyValueObservingOptionNew context:nil];
        
    }
    
}

#pragma mark ---- 私有方法 ------------


/* 初始化子视图 **/
- (void)setupViews {
    
    
}

// 布局 视图
- (void)configSubviews {
    
    // 1.箭头
    CGFloat arrowX = self.lee_width * 0.5 - 100;
    self.arrowImageView.center = CGPointMake(arrowX, self.lee_height * 0.5);
    //self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    
    // 2.指示器
    self.activityView.center = self.arrowImageView.center;
    
    // 3.状态标签
    self.statusLabel.frame = self.bounds;
    
}

#pragma mark 重写调整frame
- (void)adjustFrameWithContentSize {
    // 内容的高度
    CGFloat contentHeight = self.scrollView.lee_contentSizeHeight;
    // 表格的高度
    CGFloat scrollHeight = self.scrollView.lee_height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom;
    // 设置位置和尺寸
    self.lee_y = MAX(contentHeight, scrollHeight);
}


#pragma mark - 监听scrollView的偏移改变
/* kvo 监听 **/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([LeeRefreshContentOffset isEqualToString:keyPath]) {
        
        // 不能跟用户交互就直接返回
        if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden || self.isRefreshing) return;
        
        [self adjustStateWithContentOffset];
        
    }else if([LeeRefreshContentSize isEqualToString:keyPath]) {
        
        // 调整frame
        [self adjustFrameWithContentSize];
        
    }
}

/*
 * 更新状态
 **/
- (void)adjustStateWithContentOffset {
    
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.lee_contentOffsetY;
    // 尾部控件刚好出现一点点的offsetY
    CGFloat happenOffsetY = [self happenOffsetY];
    NSLog(@"happenOffsetY = %f",happenOffsetY);
    /* 说明scrollView是正在向下滑动 这种情况不考虑**/
    if (currentOffsetY <= happenOffsetY) {
        return;
    }
    if (self.scrollView.isDragging) {
        
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetY = happenOffsetY + self.lee_height;

        /* 正在拖动 **/
        if (self.status == LeeRefreshStatusNormal && (currentOffsetY > normal2pullingOffsetY)) {
            
            /* 这里如果松手马上进入刷新状态 **/
            self.status = LeeRefreshStatusPulling;
            
        }else if (self.status == LeeRefreshStatusPulling && (currentOffsetY <= normal2pullingOffsetY)) {
            
            self.status = LeeRefreshStatusNormal;
        }
        
    }else {
        /* 松开手了 **/
        if (self.status == LeeRefreshStatusPulling) {
            
            /* 开始 进入刷新状态**/
            self.status = LeeRefreshStatusRefreshing;
        }else {
            self.status = LeeRefreshStatusNormal;
        }
    }
    
}

#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)heightBetweenContentSizeHeightAndScrollViewHeight {
    
    /* 真实内容的高度 **/
    CGFloat h = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
    /* scrollView 超出 内容的高度 **/
    return self.scrollView.contentSize.height - h;
}

#pragma mark - 在父类中用得上
/**
 *  尾部控件刚好出现一点点的offsetY
 */
- (CGFloat)happenOffsetY {
    
    CGFloat deltaH = [self heightBetweenContentSizeHeightAndScrollViewHeight];
    if (deltaH > 0) {
        return deltaH - self.scrollViewOriginalInset.top;
    } else {
        return - self.scrollViewOriginalInset.top;
    }
}

#pragma mark ---- 状态改变--------
/*覆盖setStatus**/
- (void)setStatus:(LeeRefreshStatus)status {
    [super setStatus:status];
    switch (status) {
            
            /* 默认的正常的状态 (上拉可以刷新)**/
        case LeeRefreshStatusNormal:{
            
            [self refreshStatusNormal];
            break;
        }
            /* 下拉或者的状态(松开立即刷新)**/
        case LeeRefreshStatusPulling:{
            
            [self refreshStatusPulling];
            break;
        }
            /* 正在刷新的状态（正在刷新） **/
        case LeeRefreshStatusRefreshing:{
            
            [self refreshStatusRefreshing];
            break;
        }
            /* None状态 **/
        default:{
            
        }
    }
    
}

/* 正常状态 **/
- (void)refreshStatusNormal {
    
    self.statusLabel.text = @"上拉可以刷新";
    
    // 显示箭头
    self.arrowImageView.hidden = NO;
    // 停止转圈圈
    [self.activityView stopAnimating];
    
    
    // 执行动画
    [UIView animateWithDuration:LeeRefreshFastAnimationDuration animations:^{
        
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
        
    }];
    
    
}

/* 下拉状态 **/
- (void)refreshStatusPulling {
    
    self.statusLabel.text = @"松开立即刷新";
    
    // 执行动画
    [UIView animateWithDuration:LeeRefreshFastAnimationDuration animations:^{
        
        self.arrowImageView.transform = CGAffineTransformIdentity;
    }];
    
}

/* 刷新状态 **/
- (void)refreshStatusRefreshing {
    
    /* 刷新回调 **/
    if (self.beginRefreshingCallback) {
        self.beginRefreshingCallback();
        NSLog(@"footer_beginRefreshingCallback");
    }
    
    self.statusLabel.text = @"正在帮您加载...";
    
    // 开始转圈圈
    [self.activityView startAnimating];
    // 隐藏箭头
    self.arrowImageView.hidden = YES;
    
    // 执行动画
    [UIView animateWithDuration:LeeRefreshFastAnimationDuration animations:^{
        // 1.增加滚动区域
        CGFloat bottom = self.lee_height + self.scrollViewOriginalInset.bottom;
        CGFloat deltaH = [self heightBetweenContentSizeHeightAndScrollViewHeight];
        if (deltaH < 0) { // 如果内容高度小于view的高度
            bottom -= deltaH;
        }
        self.scrollView.lee_contentInsetBottom = bottom;
        
    }];
    
}


/**
 *  开始刷新
 */
- (void)beginRefreshing {
    
    [super beginRefreshing];
    
    if (self.status == LeeRefreshStatusRefreshing) {
        return;
    }
    self.status = LeeRefreshStatusRefreshing;
}
/**
 *  结束刷新
 */
- (void)endRefreshing {
    
    [super endRefreshing];
    
    if (self.status == LeeRefreshStatusNormal) {
        return;
    }
    
    [UIView animateWithDuration:LeeRefreshFastAnimationDuration animations:^{
        // 1.增加滚动区域
        CGFloat bottom = self.scrollViewOriginalInset.bottom;
        self.scrollView.lee_contentInsetBottom = bottom;
        
    }completion:^(BOOL finished) {
        
        self.status = LeeRefreshStatusNormal;
    }];
}


@end
