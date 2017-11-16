//
//  PictureImportingView.m
//  ZJHPictureImport
//
//  Created by ZhangJingHao2345 on 2017/11/16.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#import "PictureImportingView.h"
#import "PictureImportHeader.h"

@interface PictureImportingView ()

@property (nonatomic, weak) UIView *backView;
@property (nonatomic, weak) UIView *progressView;
@property (nonatomic, weak) UILabel *tipLab;

@end

@implementation PictureImportingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIWithFrame:frame];
    }
    return self;
}

- (void)setupUIWithFrame:(CGRect)frame {
    CGFloat iconWH = SCREEN_MY_WIDTH(80);
    CGFloat iconY = SCREEN_MY_WIDTH(160);
    CGFloat left = (SCREEN_WIDTH - 3 * iconWH ) / 2;
    CGFloat iconX = 0;
    NSArray *imgArr = @[@"import_picture", @"import_progress2", @"import_iphone"];
    NSMutableArray *imageArr = [NSMutableArray array];
    UIImageView *imageView = nil;
    for (int i = 0; i < 3; i++) {
        iconX = left + iconWH * i;
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, iconWH, iconWH)];
        NSString *iconStr = imgArr[i];
        iconView.image = [UIImage imageNamed:iconStr];
        [self addSubview:iconView];
        
        NSString *imageStr = [NSString stringWithFormat:@"import_progress%d",i + 1];
        UIImage *image = [UIImage imageNamed:imageStr];
        [imageArr addObject:image];
        if (i == 1) {
            imageView = iconView;
        }
    }
    imageView.animationImages = imageArr;
    imageView.animationDuration = 2;
    [imageView startAnimating];
    
    CGFloat backW = SCREEN_MY_WIDTH(300);
    CGFloat backX = (SCREEN_WIDTH - backW) / 2;
    CGFloat backY = iconY + iconWH + SCREEN_MY_WIDTH(50);
    CGFloat backH = SCREEN_MY_WIDTH(5);
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(backX, backY, backW, backH)];
    backView.backgroundColor = UIColorFromRGB(0xededed);
    backView.layer.cornerRadius = backH / 2;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    self.backView = backView;
    
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(backX, backY, 0, backH)];
    progressView.backgroundColor = UIColorFromRGB(0xffa203);
    progressView.layer.cornerRadius = backH / 2;
    progressView.layer.masksToBounds = YES;
    [self addSubview:progressView];
    self.progressView = progressView;
    
    CGFloat tipY = backY + backH;
    CGFloat tipH = SCREEN_MY_WIDTH(35);
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, tipY, SCREEN_WIDTH, tipH)];
    tipLab.text = @"准备导入……";
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.textColor = UIColorFromRGB(0x333333);
    tipLab.font = [UIFont systemFontOfSize:SCREEN_MY_WIDTH(15)];
    [self addSubview:tipLab];
    self.tipLab = tipLab;
}

- (void)updateUIWithIndex:(NSInteger)index andAllCount:(NSInteger)allCount {
    CGRect backF = self.backView.frame;
    CGFloat progressW = backF.size.width * index / allCount;
    self.progressView.frame = CGRectMake(backF.origin.x, backF.origin.y, progressW, backF.size.height);
    self.tipLab.text = [NSString stringWithFormat:@"正在导入图片（%ld/%ld)", index, allCount];
}

@end
