//
//  SJUIKit.h
//  LXProject
//
//  Created by sharejoy_lx on 16-10-18.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJUIKit : NSObject

#pragma mark --------- UILabel --------

/** Label 字色 字号 */
+ (UILabel *)labelTextColor:(UIColor *)textColor
                   fontSize:(CGFloat)size;

/** Label 文字 字号 */
+ (UILabel *)labelWithText:(NSString *)text
                  fontSize:(CGFloat)size;

/** Label 字色 行数 文字 字号 */
+ (UILabel *)labelWithTextColor:(UIColor *)textColor
                  numberOfLines:(NSInteger)numberOfLines
                           text:(NSString *)text
                       fontSize:(CGFloat)size;

/** Label 背景色 字色 对其 行数 文字 字号 */
+ (UILabel *)labelWithBackgroundColor:(UIColor *)backgroundColor
                            textColor:(UIColor *)textColor
                        textAlignment:(NSTextAlignment)textAlignment
                        numberOfLines:(NSInteger)numberOfLines
                                 text:(NSString *)text
                             fontSize:(CGFloat)size;

#pragma mark --------- UIImageView --------

/** ImageView 图片 */
+ (UIImageView *)imageViewWithImage:(UIImage *)image;

/** ImageView 图片 交互 */
+ (UIImageView *)imageViewWithImage:(UIImage *)image
             userInteractionEnabled:(BOOL)enabled;

/** ImageView 填充方式 图片 */
+ (UIImageView *)imageViewWithContentMode:(UIViewContentMode)mode
                                    image:(UIImage *)image;

/** ImageView 填充方式 交互 图片 */
+ (UIImageView *)imageViewWithContentMode:(UIViewContentMode)mode
                   userInteractionEnabled:(BOOL)enabled
                                    image:(UIImage *)image;

#pragma mark --------- UIButton --------

/** UIButton 前景图 */
+ (UIButton *)buttonWithImage:(UIImage *)image;

/** UIButton 背景色 标题色 标题 字号 */
+ (UIButton *)buttonWithBackgroundColor:(UIColor *)backgroundColor
                             titleColor:(UIColor *)titleColor
                                  title:(NSString *)title
                               fontSize:(CGFloat)size;

/** UIButton 背景色 标题色 标题高亮色 标题 字号 */
+ (UIButton *)buttonWithBackgroundColor:(UIColor *)backgroundColor
                             titleColor:(UIColor *)titleColor
                    titleHighlightColor:(UIColor *)titleHighlightColor
                                  title:(NSString *)title
                               fontSize:(CGFloat)size;


#pragma mark --------- TableView --------

+ (UITableView *)tableViewWithFrame:(CGRect)frame
                              style:(UITableViewStyle)style
                           delegate:(id)delegate;

+ (void)sj_tableView:(UITableView *)tableView withDelegate:(id)delegate;


@end
