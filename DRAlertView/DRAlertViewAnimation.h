//
//  DRAlertViewAnimation.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/11/14.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HTShrink, // 缩小并消失
    HTEnlarge, // 晕开并消失
} HideType;

@interface DRAlertViewAnimation : UIView

@property (strong, nonatomic) UIView *contentView;

- (void)show;
- (void)hideWithType:(HideType)type completion:(void(^)(void))complete;

@end


