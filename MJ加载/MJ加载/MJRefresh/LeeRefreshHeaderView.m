//
//  LeeRefreshHeaderView.m
//  Lee加载
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import "LeeRefreshHeaderView.h"

@interface LeeRefreshHeaderView ()

// 最后的更新时间
@property (nonatomic,strong) UILabel *lastUpdateTimeLabel;

@end

@implementation LeeRefreshHeaderView

#pragma mark --- 视图生命周期  -----



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
    
    /* 设置frame **/
    self.frame = CGRectMake(0, -LeeRefreshViewHeight, newSuperview.lee_width, LeeRefreshViewHeight);
    
}

#pragma mark ---- 私有方法 ------------

/* 初始化子视图 **/
- (void)setupViews {
    
    [self addSubview:self.lastUpdateTimeLabel];
}

// 布局 视图
- (void)configSubviews {

    // 1.箭头
    CGFloat arrowX = self.lee_width * 0.5 - 100;
    self.arrowImageView.center = CGPointMake(arrowX, self.lee_height * 0.5);
    // 2.指示器
    self.activityView.center = self.arrowImageView.center;
    
    
    CGFloat statusX = 0;
    CGFloat statusY = 0;
    CGFloat statusHeight = self.lee_height * 0.5;
    CGFloat statusWidth  = self.lee_width;
    // 3.状态标签
    self.statusLabel.frame = CGRectMake(statusX, statusY, statusWidth, statusHeight);
    
    // 4.时间标签
    CGFloat lastUpdateY = statusHeight;
    CGFloat lastUpdateX = 0;
    CGFloat lastUpdateHeight = statusHeight;
    CGFloat lastUpdateWidth = statusWidth;
    self.lastUpdateTimeLabel.frame = CGRectMake(lastUpdateX, lastUpdateY, lastUpdateWidth, lastUpdateHeight);
    
}

/*更新label中显示的 时间**/
- (void)updateTimeLabel {
    
    NSDate *lastUpdateTime = [[NSUserDefaults standardUserDefaults]objectForKey:LeeRefreshTimeKey];
    if (lastUpdateTime == nil) {
        return;
    }
    
    // 1.获得年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdateTime];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day]) { // 今天
        formatter.dateFormat = @"今天 HH:mm";
    } else if ([cmp1 year] == [cmp2 year]) { // 今年
        formatter.dateFormat = @"MM-dd HH:mm";
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    NSString *time = [formatter stringFromDate:lastUpdateTime];
    // 3.显示日期
    self.lastUpdateTimeLabel.text = [NSString stringWithFormat:@"最后更新：%@", time];
    
}


#pragma mark - get方法
/**
 *  时间标签
 */
- (UILabel *)lastUpdateTimeLabel {
    if (!_lastUpdateTimeLabel) {
        // 1.创建控件
        UILabel *lastUpdateTimeLabel = [[UILabel alloc] init];
        lastUpdateTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lastUpdateTimeLabel.font = [UIFont boldSystemFontOfSize:12];
        lastUpdateTimeLabel.textColor = LeeRefreshLabelTextColor;
        lastUpdateTimeLabel.backgroundColor = [UIColor clearColor];
        lastUpdateTimeLabel.textAlignment = NSTextAlignmentCenter;
        _lastUpdateTimeLabel = lastUpdateTimeLabel;
    }
    return _lastUpdateTimeLabel;
}


#pragma mark - 监听scrollView的偏移改变
/* kvo 监听 **/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([LeeRefreshContentOffset isEqualToString:keyPath]) {
        
        // 不能跟用户交互就直接返回
        if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden || self.isRefreshing) return;
        [self adjustStateWithContentOffset];
    }
}

/*
 * 更新状态
 **/
- (void)adjustStateWithContentOffset {
    
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.lee_contentOffsetY;
    // 头部控件刚好出现的offsetY
    CGFloat originalOffsetY = - self.scrollViewOriginalInset.top;
    /* 
     * 向上滑动 scrollview的偏移量是 一直增加的
     * 向下滑动 scrollview的偏移量是 一直减少的
     **/
    
    /* 说明scrollView是正在向上滑动 **/
    if (currentOffsetY > originalOffsetY) {
        return;
    }
    
    /* 正在往下运动 
     * 如果减少到 -self.height -self.scrollViewOriginalInset.top
     * 如果再继续减少 就要切换状态
     **/
    if (self.scrollView.isDragging) {
        /* 正在拖动 **/
        if (self.status == LeeRefreshStatusNormal && (currentOffsetY < -self.lee_height + originalOffsetY)) {
            
            /* 这里如果松手马上进入刷新状态 **/
            self.status = LeeRefreshStatusPulling;
            
        }else if (self.status == LeeRefreshStatusPulling && (currentOffsetY > -self.lee_height + originalOffsetY)) {
            
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

#pragma mark ---- 状态改变--------
/*覆盖setStatus**/
- (void)setStatus:(LeeRefreshStatus)status {
    [super setStatus:status];
    switch (status) {
            
        /* 默认的正常的状态 (下拉可以刷新)**/
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
    
    /* 更新时间 **/
    [self updateTimeLabel];
    
    self.statusLabel.text = @"下拉可以刷新";
    
    // 显示箭头
    self.arrowImageView.hidden = NO;
    // 停止转圈圈
    [self.activityView stopAnimating];
    
    // 执行动画
    [UIView animateWithDuration:LeeRefreshFastAnimationDuration animations:^{
        
        self.arrowImageView.transform = CGAffineTransformIdentity;
    }];
    
    
}

/* 下拉状态 **/
- (void)refreshStatusPulling {
    
    self.statusLabel.text = @"松开立即刷新";
    
    // 执行动画
    [UIView animateWithDuration:LeeRefreshFastAnimationDuration animations:^{
        
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    
}

/* 刷新状态 **/
- (void)refreshStatusRefreshing {
    
    /* 刷新回调 **/
    if (self.beginRefreshingCallback) {
        self.beginRefreshingCallback();
        NSLog(@"header_beginRefreshingCallback");
    }
    self.statusLabel.text = @"正在帮您刷新...";
    
    // 开始转圈圈
    [self.activityView startAnimating];
    // 隐藏箭头
    self.arrowImageView.hidden = YES;
    
    // 执行动画
    [UIView animateWithDuration:LeeRefreshFastAnimationDuration animations:^{
        // 1.增加滚动区域
        CGFloat top = self.scrollViewOriginalInset.top + self.lee_height;
        self.scrollView.lee_contentInsetTop = top;
        
        // 2.设置滚动位置
        self.scrollView.lee_contentOffsetY = - top;
        
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
        CGFloat top = self.scrollViewOriginalInset.top;
        self.scrollView.lee_contentInsetTop = top;
        
        // 2.设置滚动位置
        self.scrollView.lee_contentOffsetY = - top;
    }completion:^(BOOL finished) {
        
        self.status = LeeRefreshStatusNormal;
    }];
}



@end
