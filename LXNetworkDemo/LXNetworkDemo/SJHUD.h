//
//  HUDManager.h
//  MBProgress-Demo
//
//  Created by sharejoy_lx on 16-08-02.
//  Copyright © 2016年 shangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+LX.h"

@interface SJHUD : NSObject

/** 短暂显示一条信息 */
+ (void)showBriefMsg:(NSString *)message;
+ (void)showBriefMsg:(NSString *)message toView:(UIView *)view;
+ (void)showBriefMsgOnTopWindow:(NSString *)message;

/** 显示菊花指示器和一条信息 */
+ (MBProgressHUD *)showIndicatorWithMsg:(NSString *)message;
+ (MBProgressHUD *)showIndicatorWithMsg:(NSString *)message toView:(UIView *)view;
+ (MBProgressHUD *)showIndicatorWithMsgOnTopWindow:(NSString *)message;

///** 显示定制加载动画和一条信息 */
//+ (MBProgressHUD *)showCustomWithMsg:(NSString *)message;
//+ (MBProgressHUD *)showCustomWithMsg:(NSString *)message toView:(UIView *)view;
//+ (MBProgressHUD *)showCustomWithMsgOnTopWindow:(NSString *)message;

/** 隐藏 */
+ (void)hideHUD;
+ (void)hideHUDForTopWindow;

+ (void)hideHUDForView:(UIView *)view;

+ (void)handleError:(NSInteger)code errMsg:(NSString *)errMsg;

@end
