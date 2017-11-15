//
//  DRAlertViewAnimation.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/11/14.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "DRAlertViewAnimation.h"

#define kCAAnimationDuration 0.5
#define kFadeInDuration 0.3

typedef void(^DismissDone)(void);

@interface DRAlertViewAnimation ()<CAAnimationDelegate>

@property (strong, nonatomic) UIView *backgroundView;
@property (assign, nonatomic) HideType hideType;
@property (copy,   nonatomic) DismissDone dismissDone;
@end

@implementation DRAlertViewAnimation

- (instancetype)init {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor clearColor];
        
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0.3;
        [self addSubview:_backgroundView];
    }
    return self;
}

- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    _contentView.center = self.center;
    [self addSubview:_contentView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setImage:[UIImage imageNamed:@"DRAlert_close"] forState:UIControlStateNormal];
    [self addSubview:btn];
}

- (void)show {

    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NSArray *windowViews = [window subviews];
    if(windowViews && [windowViews count] > 0){
        
        NSInteger index;
         index = [windowViews count]-1;
//        if ([windowViews containsObject:[LLLaunchADManager shareManager].advertView]) {
//            index = [windowViews count]-2;
//        }else{
//           
//        }
        
        UIView *subView = [windowViews objectAtIndex:index];
        for(UIView *aSubView in subView.subviews)
        {
            [aSubView.layer removeAllAnimations];
        }
        
        [subView addSubview:self];
        
        [self showBackground];
        [self showAlertAnimation];
    }
}


- (void)hideWithType:(HideType)type completion:(void(^)(void))complete {
    _hideType = type;
    _dismissDone = complete;
    [self hideAlertAnimation];
}

- (void)showBackground
{
    _backgroundView.alpha = 0;
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    _backgroundView.alpha = 0.6;
    [UIView commitAnimations];
}

-(void)showAlertAnimation
{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = kFadeInDuration;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.keyTimes = @[@(0),@(0.9),@(1)];
    [_contentView.layer addAnimation:animation forKey:nil];
}

- (void)hideAlertAnimation {
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = kCAAnimationDuration;
    animation.removedOnCompletion = YES;
    animation.delegate = self;
    animation.fillMode = kCAFillModeRemoved;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    animation.values = values;
    
    [_contentView.layer addAnimation:animation forKey:nil];
    
}

- (void)animationDidStart:(CAAnimation *)anim {
    NSTimeInterval animationDuration = 0;
    if (_hideType==HTEnlarge) {
        animationDuration = kFadeInDuration;
    }
    else {
        animationDuration = kCAAnimationDuration;
    }
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:animationDuration];
    _contentView.alpha = 0.0;
    _backgroundView.alpha = 0.0;
    [UIView commitAnimations];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self removeAllSubviews];
    [self removeFromSuperview];
    _dismissDone();
}

- (void)dealloc {
    NSLog(@"animation 释放");
}

@end
