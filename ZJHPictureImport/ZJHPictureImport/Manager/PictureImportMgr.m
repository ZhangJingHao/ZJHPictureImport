//
//  PictureImportMgr.m
//  ZJHPictureImport
//
//  Created by ZhangJingHao2345 on 2017/11/16.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#import "PictureImportMgr.h"
#import "ZJHTool.h"

@implementation PictureImportMgr

// 检测图片，有图片则返回图片数组，无图则返回nil
+ (NSArray *)checkImportPicture {
    // 判断文件夹
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *filePath = [self pictureFilePath];
    if (![fileMgr fileExistsAtPath:filePath]) {
        NSLog(@"请在共享目录(Documents)中 创建文件夹 ZJHPicture");
        return nil;
    }
    
    // 判断文件夹内容
    NSArray *dirArray = [fileMgr contentsOfDirectoryAtPath:filePath error:nil];
    if (!dirArray || !dirArray.count) {
        NSLog(@"请在 ZJHPicture 文件夹内添加图片");
        return nil;
    }
    
    // 判断文件是否有效
    NSMutableArray *pictureArr = [NSMutableArray arrayWithCapacity:dirArray.count];
    for (NSString *path in dirArray) {
        NSString *imagePath = [filePath stringByAppendingPathComponent:path];
        if ([self validExtentionWithPath:path]) {
            // 编码文件名，以防含有中文，导致存储失败
            NSCharacterSet *charSet = [NSCharacterSet URLQueryAllowedCharacterSet];
            NSString *encodeStr =
            [imagePath stringByAddingPercentEncodingWithAllowedCharacters:charSet];
            [pictureArr addObject:encodeStr];
        } else {
            // 删除无效文件，以防占用多余空间
            [fileMgr removeItemAtPath:imagePath error:nil];
        }
    }
    if (!pictureArr.count) {
        NSLog(@"请添加 jpg、png、jpeg、heic、mov 类型文件");
        return nil;
    }
    
    return pictureArr;
}

// 图片存在共享目录(Documents) ZJHPicture 文件夹内
+ (NSString *)pictureFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *documentsPath = paths.firstObject;
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"ZJHPicture"];
    return filePath;
}

// 支持的图片、视频类型 jpg、png、jpeg、heic、mov
+ (BOOL)validExtentionWithPath:(NSString *)path {
    NSString *ext = [path pathExtension];
    NSString *extLower = [ext lowercaseString];
    NSArray *extArr = @[@"jpg", @"png", @"jpeg", @"heic", @"mov"];
    return [extArr containsObject:extLower];
}

@end
