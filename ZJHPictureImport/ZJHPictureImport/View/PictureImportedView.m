//
//  PictureImportedView.m
//  ZJHPictureImport
//
//  Created by ZhangJingHao2345 on 2017/11/16.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#import "PictureImportedView.h"
#import "PictureImportHeader.h"

@implementation PictureImportedView

- (void)setupUIWithPictureCount:(NSInteger)count {
    
    CGFloat iconWH = SCREEN_MY_WIDTH(60);
    CGFloat iconX = (SCREEN_WIDTH - iconWH) / 2;
    CGFloat iconY = SCREEN_MY_WIDTH(170);
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, iconWH, iconWH)];
    iconView.image = [UIImage imageNamed:@"import_complete"];
    [self addSubview:iconView];
    
    CGFloat tipY = iconY + iconWH + SCREEN_MY_WIDTH(38);
    CGFloat tipH = SCREEN_MY_WIDTH(30);
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, tipY, SCREEN_WIDTH, tipH)];
    tipLab.text = @"导入已完成";
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.textColor = UIColorFromRGB(0x333333);
    tipLab.font = [UIFont systemFontOfSize:SCREEN_MY_WIDTH(20)];
    [self addSubview:tipLab];
    
    CGFloat detailY = tipY + tipH;
    CGFloat detailH = SCREEN_MY_WIDTH(25);
    UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectMake(0, detailY, SCREEN_WIDTH, detailH)];
    detailLab.text = [NSString stringWithFormat:@"已经成功导入%ld张图片", count];
    detailLab.textAlignment = NSTextAlignmentCenter;
    detailLab.textColor = UIColorFromRGB(0x999999);
    detailLab.font = [UIFont systemFontOfSize:SCREEN_MY_WIDTH(14)];
    [self addSubview:detailLab];
    
    CGFloat btnX = SCREEN_MY_WIDTH(15);
    CGFloat btnW = SCREEN_WIDTH - 2 * btnX;
    CGFloat btnH = SCREEN_MY_WIDTH(45);
    CGFloat btnY = SCREEN_HEIGHT - btnH - SCREEN_MY_WIDTH(30);
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
    [btn setTitle:@"查看导入图片" forState:UIControlStateNormal];
    btn.backgroundColor = UIColorFromRGB(0xffa203);
    btn.titleLabel.font = [UIFont systemFontOfSize:SCREEN_MY_WIDTH(18)];
    [btn addTarget:self
            action:@selector(lookImportPicture)
  forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = SCREEN_MY_WIDTH(8) / 2;
    btn.layer.masksToBounds = YES;
    [self addSubview:btn];
}

- (void)lookImportPicture {
    if (self.lookPictureBlock) {
        self.lookPictureBlock();
    }
}

@end
