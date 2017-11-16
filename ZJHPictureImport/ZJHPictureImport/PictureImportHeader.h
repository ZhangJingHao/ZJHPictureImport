//
//  PictureImportHeader.h
//  ZJHPictureImport
//
//  Created by ZhangJingHao2345 on 2017/11/16.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#define SCREEN_WIDTH                                ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT                               ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MY_WIDTH(a)                          ((a) * SCREEN_WIDTH / 375.f)

#define UIColorFromRGB(rgbValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]
