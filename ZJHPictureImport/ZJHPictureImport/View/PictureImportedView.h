//
//  PictureImportedView.h
//  ZJHPictureImport
//
//  Created by ZhangJingHao2345 on 2017/11/16.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureImportedView : UIView

@property (nonatomic, copy) void (^lookPictureBlock)(void);

- (void)setupUIWithPictureCount:(NSInteger)count;

@end
