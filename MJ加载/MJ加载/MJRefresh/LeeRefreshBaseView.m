//
//  LeeRefreshBaseView.m
//  MJ加载
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import "LeeRefreshBaseView.h"

@interface LeeRefreshBaseView ()

/* 状态文字 **/
@property (nonatomic,strong) UILabel * statusLabel;
/* 状态图片 **/
@property (nonatomic,strong) UIImageView * arrowImageView;
/* 状态圈圈**/
@property (nonatomic,strong) UIActivityIndicatorView *activityView;

/* 父视图 **/
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic,assign) UIEdgeInsets scrollViewOriginalInset;

@end

@implementation LeeRefreshBaseView

#pragma mark ------- 初始化 ------------

- (void)dealloc {
    
    [self.scrollView removeObserver:self forKeyPath:LeeRefreshContentOffset context:nil];
}


// 初始化 重写
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubViews];
        // 1.自己的属性
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)setupSubViews {
    
    [self addSubview:self.statusLabel];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.activityView];
    
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    
    [super willMoveToSuperview:newSuperview];
    
    /* 记录父亲视图 **/
    self.scrollView = (UIScrollView *)newSuperview;
    self.scrollViewOriginalInset = self.scrollView.contentInset;
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:LeeRefreshContentOffset context:nil];
    if (newSuperview) {
        [newSuperview addObserver:self forKeyPath:LeeRefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
    }
    

    
}

#pragma mark - 公共接口
#pragma mark - get方法
/**
 *  状态标签
 */
- (UILabel *)statusLabel {
    
    if (!_statusLabel) {
        UILabel *statusLabel = [[UILabel alloc] init];
        statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        statusLabel.font = [UIFont boldSystemFontOfSize:13];
        statusLabel.textColor = LeeRefreshLabelTextColor;
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_statusLabel = statusLabel];
    }
    return _statusLabel;
}

/**
 *  箭头图片
 */
- (UIImageView *)arrowImageView {
    
    if (!_arrowImageView) {
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:LeeRefreshSrcName(@"arrow.png")]];
        arrowImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _arrowImageView = arrowImage;
    }
    return _arrowImageView;
}

/**
 *  转圈圈
 */
- (UIActivityIndicatorView *)activityView {
    
    if (!_activityView) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.bounds = self.arrowImageView.bounds;
        activityView.autoresizingMask = self.arrowImageView.autoresizingMask;
        _activityView = activityView;
    }
    return _activityView;
}
/* 设置 状态 **/
- (void)setStatus:(LeeRefreshStatus)status {
    
    _status = status;
}
/* 是否正在刷新**/
- (BOOL)isRefreshing {
    
    return LeeRefreshStatusRefreshing == self.status;
}

#pragma mark - 公共的方法
/**
 *  开始刷新
 */
- (void)beginRefreshing {
    
    
}
/**
 *  结束刷新
 */
- (void)endRefreshing {
    
    [self updateUserdefaultRefreshTime];
    
}


/* 存储 新的 时间 **/
- (void)updateUserdefaultRefreshTime {
    
    // 1.NSUserDefaults 存储当前的时间
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:LeeRefreshTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end












