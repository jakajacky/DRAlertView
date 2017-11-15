//
//  DRAlertView.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/11/14.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "DRAlertView.h"

@interface DRAlertView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *bg;
@property (weak, nonatomic) IBOutlet UIView *Big_bg;
@property (weak, nonatomic) IBOutlet UIView *btn_bg;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (nonatomic, strong) DRAlertViewAnimation *animation;

@end

@implementation DRAlertView

- (instancetype)initWithFrame:(CGRect)frame complete:(ActionBtnDidClick)complete {
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
        
        _action = complete;
        
        [self.closeBtn addTarget:self action:@selector(closeBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.firstBtn addTarget:self action:@selector(firstBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.secondBtn addTarget:self action:@selector(secondBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.contentView = [[[NSBundle mainBundle] loadNibNamed:@"DRAlertView" owner:self options:nil] lastObject];
    self.contentView.frame = self.bounds;
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
//    self.contentView.layer.masksToBounds = YES;
    self.contentView.clipsToBounds       = NO;
    
    [self addSubview:self.contentView];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // Big_bg右上内圆角和左上外圆角
    UIBezierPath *Big_bezier = [UIBezierPath bezierPath];
    [Big_bezier moveToPoint:CGPointMake(0, 0)];
    [Big_bezier addLineToPoint:CGPointMake(0, self.Big_bg.height)];
    [Big_bezier addLineToPoint:CGPointMake(self.Big_bg.width, self.Big_bg.height)];
    [Big_bezier addLineToPoint:CGPointMake(self.Big_bg.width, 10)];
    //右上内圆角
    [Big_bezier addQuadCurveToPoint:CGPointMake(self.Big_bg.width-10, 0) controlPoint:CGPointMake(self.Big_bg.width-10, 10)];
    [Big_bezier addLineToPoint:CGPointMake(4, 0)];
    //左上外圆角
    [Big_bezier addQuadCurveToPoint:CGPointMake(0, 4) controlPoint:CGPointMake(0, 0)];
    [Big_bezier closePath];
    
    CAShapeLayer *Big_shape = [[CAShapeLayer alloc] init];
    Big_shape.path = Big_bezier.CGPath;
    
    Big_shape.frame = self.Big_bg.bounds;
    self.Big_bg.layer.mask = Big_shape;
    
    // btn_bg左下和右下外圆角
    UIBezierPath *btn_bezier = [UIBezierPath bezierPath];
    [btn_bezier moveToPoint:CGPointMake(0, 0)];
    [btn_bezier addLineToPoint:CGPointMake(0, self.btn_bg.height-4)];
    //左下外圆角
    [btn_bezier addQuadCurveToPoint:CGPointMake(4, self.btn_bg.height) controlPoint:CGPointMake(0, self.btn_bg.height)];
    [btn_bezier addLineToPoint:CGPointMake(self.btn_bg.width-4, self.btn_bg.height)];
    //右下外圆角
    [btn_bezier addQuadCurveToPoint:CGPointMake(self.btn_bg.width, self.btn_bg.height-4) controlPoint:CGPointMake(self.btn_bg.width, self.btn_bg.height)];
    [btn_bezier addLineToPoint:CGPointMake(self.btn_bg.width, 0)];
    [btn_bezier closePath];
    
    CAShapeLayer *btn_shape = [[CAShapeLayer alloc] init];
    btn_shape.path = btn_bezier.CGPath;
    btn_shape.frame = self.btn_bg.bounds;
    self.btn_bg.layer.mask = btn_shape;
}

- (void)closeBtnDidClicked:(UIButton *)sender {
    [self hideWithType:HTShrink completion:^{
       _action(ATClose);
    }];
}
- (void)firstBtnDidClicked:(UIButton *)sender {
    
    [self hideWithType:HTEnlarge completion:^{
        _action(ATFirst);
    }];
}
- (void)secondBtnDidClicked:(UIButton *)sender {
    
    [self hideWithType:HTEnlarge completion:^{
        _action(ATSecond);
    }];
}

/**
 * 显示
 */
- (void)show {
    _animation = [[DRAlertViewAnimation alloc] init];
    _animation.contentView = self;
    [_animation show];
}

/**
 * 隐藏
 */
- (void)hideWithType:(HideType)type completion:(void(^)(void))complete {
    [_animation hideWithType:type completion:^{
        //
        NSLog(@"alert dismiss");
        complete();
        [_animation removeAllSubviews];
        [_animation removeFromSuperview];
        _animation = nil;
    }];
}

- (void)dealloc {
    NSLog(@"alert 释放");
    [self removeAllSubviews];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    if (!result) {
        CGPoint res_point = [self.closeBtn convertPoint:point fromView:self];
        result = [self.closeBtn hitTest:res_point withEvent:event];
    }
    return result;
}

@end
