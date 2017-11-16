//
//  PictureImportMgr.h
//  ZJHPictureImport
//
//  Created by ZhangJingHao2345 on 2017/11/16.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureImportMgr : NSObject

/// 检测图片，有图片则返回图片数组，无图则返回nil
+ (NSArray *)checkImportPicture;

@end
