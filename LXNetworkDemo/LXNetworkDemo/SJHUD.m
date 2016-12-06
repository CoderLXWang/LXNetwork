//
//  HUDManager.m
//  MBProgress-Demo
//
//  Created by sharejoy_lx on 16-08-02.
//  Copyright © 2016年 shangbin. All rights reserved.
//

#import "SJHUD.h"

@interface SJHUD () 


@end

@implementation SJHUD

+ (void)showBriefMsg:(NSString *)message {
    [self showBriefMsg:message toView:nil];
}

+ (void)showBriefMsg:(NSString *)message toView:(UIView *)view {
    [MBProgressHUD showBriefMsg:message toView:view];
}

+ (void)showBriefMsgOnTopWindow:(NSString *)message {
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    [MBProgressHUD showBriefMsg:message toView:view];
}


+ (MBProgressHUD *)showIndicatorWithMsg:(NSString *)message {
    return [self showIndicatorWithMsg:message toView:nil];
}

+ (MBProgressHUD *)showIndicatorWithMsg:(NSString *)message toView:(UIView *)view {
    return [MBProgressHUD showIndicatorWithMsg:message toView:view];
}

+ (MBProgressHUD *)showIndicatorWithMsgOnTopWindow:(NSString *)message {
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    return [MBProgressHUD showIndicatorWithMsg:message toView:view];
}


+ (void)hideHUDForView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view];
}

+ (void)hideHUD {
    [self hideHUDForView:nil];
}

+ (void)hideHUDForTopWindow {
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view];
}

+ (void)handleError:(NSInteger)code errMsg:(NSString *)errMsg {

    if (code == 404000) {
#ifdef DEBUG
        [SJHUD showBriefMsg:[NSString stringWithFormat:@"404000 测试信息：正式版不会出现\n%@", errMsg]];
#else
        
#endif
        return;
    }
    if (errMsg && errMsg.length != 0) {
        [SJHUD showBriefMsg:errMsg];
    }else{
        [SJHUD showBriefMsg:[NSString stringWithFormat:@"返回码：%zd，请稍后重试", code]];
    }
}



@end




















