//
//  DRAlertView.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/11/14.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRAlertViewAnimation.h"
typedef enum : NSUInteger {
    ATClose,
    ATFirst,
    ATSecond,
} ActionType;

typedef void(^ActionBtnDidClick)(ActionType type);

@interface DRAlertView : UIView

@property (nonatomic, copy) ActionBtnDidClick action;

- (instancetype)initWithFrame:(CGRect)frame complete:(ActionBtnDidClick)complete;
- (void)show;
- (void)hideWithType:(HideType)type;
@end
