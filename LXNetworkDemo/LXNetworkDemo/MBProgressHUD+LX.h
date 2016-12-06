//
//  MBProgressHUD+LX.h
//  ShangBin
//
//  Created by sharejoy_lx on 16-09-01.
//  Copyright © 2016年 com.sharejoy. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (LX)

+ (void)showBriefMsg:(NSString *)message toView:(UIView *)view;

+ (MBProgressHUD *)showIndicatorWithMsg:(NSString *)message toView:(UIView *)view;

//+ (MBProgressHUD *)showCustomWithMsg:(NSString *)message toView:(UIView *)view;

+ (void)hideHUDForView:(UIView *)view;

@end
