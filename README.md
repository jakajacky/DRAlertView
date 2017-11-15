# DRAlertView
一个稍微nice的alert

<h3>使用</h3>
    
    DRAlertView *alert_view = [[DRAlertView alloc] initWithFrame:CGRectMake(0, 0, 270, 270) complete:^(ActionType type) {
        if (type==ATClose) { // 关闭
                    
        }
        else if (type==ATFirst) { // 第一个
                    
        }
        else if (type==ATSecond) { // 第二个
                    
        }
    }];
    [alert_view show];

<h3>效果图</h3>
<img src='https://github.com/jakajacky/DRAlertView/blob/master/IMG_0018.PNG' width='40%'>
