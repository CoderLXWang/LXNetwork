//
//  FirstCell.m
//  LXNetworkDemo
//
//  Created by sharejoy_lx on 16-12-06.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import "FirstCell.h"
#import "SJUIKit.h"
#import <Masonry.h>
#import "FirstModel.h"

@interface FirstCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *creteTimeLabel;
@property (nonatomic, strong) UILabel *shareCountLabel;
@property (nonatomic, strong) UILabel *upCountLabel;
@property (nonatomic, strong) UILabel *downCountLabel;
@property (nonatomic, strong) UIImageView *upImgView;
@property (nonatomic, strong) UIImageView *downImgView;
@property (nonatomic, strong) UIImageView *shareImgView;

@end

@implementation FirstCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self configView];
    }
    return self;
}

//项目中布局，应适当分区， 不应直接罗列所有UI控件， demo为演示方便，直接布局，做法并不好
- (void)configView {
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    [self.contentView addSubview:self.creteTimeLabel];
    [self.creteTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.nameLabel).offset(0);
    }];

    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.nameLabel).offset(0);
        make.right.equalTo(self.creteTimeLabel).offset(0);
    }];
    
    [self.contentView addSubview:self.upCountLabel];
    [self.upCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(25);
    }];
    
    [self.contentView addSubview:self.upImgView];
    [self.upImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.upCountLabel);
        make.right.equalTo(self.upCountLabel.mas_left).offset(-2);
        make.size.mas_equalTo(CGSizeMake(52/3, 48/3));
    }];
    
    [self.contentView addSubview:self.downCountLabel];
    [self.downCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upCountLabel).offset(0);
        make.left.equalTo(self.upCountLabel.mas_right).offset(25);
    }];
    
    [self.contentView addSubview:self.downImgView];
    [self.downImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.downCountLabel);
        make.right.equalTo(self.downCountLabel.mas_left).offset(-2);
        make.size.mas_equalTo(CGSizeMake(52/3, 48/3));
    }];
    
    [self.contentView addSubview:self.shareCountLabel];
    [self.shareCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upCountLabel).offset(0);
        make.right.equalTo(self.creteTimeLabel).offset(0);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.contentView addSubview:self.shareImgView];
    [self.shareImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shareCountLabel);
        make.right.equalTo(self.shareCountLabel.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(58/3, 48/3));
    }];
}

- (void)setFirstModel:(FirstModel *)firstModel {
    if (!firstModel) return;
    
    _firstModel = firstModel;
    
    self.nameLabel.text = firstModel.user_name;
    self.contentLabel.text = firstModel.content;
    self.upCountLabel.text = firstModel.votes_up;
    self.downCountLabel.text = firstModel.votes_down;
    self.shareCountLabel.text = firstModel.share_count;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[firstModel.created_at longLongValue]];
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"MM-dd hh:mm:ss";
    NSString *timeStr = [df stringFromDate:date];
    self.creteTimeLabel.text = timeStr;
}

#pragma mark --------- 懒加载UI --------

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [SJUIKit labelWithTextColor:[UIColor blackColor] numberOfLines:1 text:@"" fontSize:15];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [SJUIKit labelWithTextColor:[UIColor blackColor] numberOfLines:0 text:@"" fontSize:16];
    }
    return _contentLabel;
}

- (UILabel *)creteTimeLabel {
    if (!_creteTimeLabel) {
        _creteTimeLabel = [SJUIKit labelWithTextColor:[UIColor lightGrayColor] numberOfLines:1 text:@"" fontSize:13];
    }
    return _creteTimeLabel;
}

- (UILabel *)shareCountLabel {
    if (!_shareCountLabel) {
        _shareCountLabel = [SJUIKit labelWithTextColor:[UIColor lightGrayColor] numberOfLines:1 text:@"" fontSize:13];
    }
    return _shareCountLabel;
}

- (UILabel *)upCountLabel {
    if (!_upCountLabel) {
        _upCountLabel = [SJUIKit labelWithTextColor:[UIColor lightGrayColor] numberOfLines:1 text:@"" fontSize:13];
    }
    return _upCountLabel;
}

- (UILabel *)downCountLabel {
    if (!_downCountLabel) {
        _downCountLabel = [SJUIKit labelWithTextColor:[UIColor lightGrayColor] numberOfLines:1 text:@"" fontSize:13];
    }
    return _downCountLabel;
}

- (UIImageView *)upImgView {
    if (!_upImgView) {
        _upImgView = [SJUIKit imageViewWithImage:[UIImage imageNamed:@"up"]];
    }
    return _upImgView;
}

- (UIImageView *)downImgView {
    if (!_downImgView) {
        _downImgView = [SJUIKit imageViewWithImage:[UIImage imageNamed:@"down"]];
    }
    return _downImgView;
}

- (UIImageView *)shareImgView {
    if (!_shareImgView) {
        _shareImgView = [SJUIKit imageViewWithImage:[UIImage imageNamed:@"share"]];
    }
    return _shareImgView;
}


@end
