//
//  MBProgressHUD+LX.m
//  ShangBin
//
//  Created by sharejoy_lx on 16-09-01.
//  Copyright © 2016年 com.sharejoy. All rights reserved.
//

#import "MBProgressHUD+LX.h"
//#import "LoadingImageView.h"
//#import "UIImage+animatedGIF.h"

@implementation MBProgressHUD (LX)


+ (void)showBriefMsg:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows firstObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = message;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15];
    // 再设置模式
    hud.mode = MBProgressHUDModeText;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    hud.userInteractionEnabled = NO;
    
    // 1秒之后再消失
    CGFloat time = 1.5;
    if (message.length <= 10) {
        time = 1.5;
    } else {
        time = 1.5 + (message.length-10)*0.1 > 3 ? 3 : 1.5 + (message.length-10)*0.1;
    }
    
    [hud hide:YES afterDelay:time];
}


+ (MBProgressHUD *)showIndicatorWithMsg:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows firstObject] ;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = message;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15];
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    
    return hud;
}



+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows firstObject];
    [self hideHUDForView:view animated:YES];
    
}



@end
