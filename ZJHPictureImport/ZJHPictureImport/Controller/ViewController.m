//
//  ViewController.m
//  ZJHPictureImport
//
//  Created by ZhangJingHao2345 on 2017/11/16.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#import "ViewController.h"
#import "ZJHTool.h"
#import "PictureImportViewController.h"
#import "PictureImportMgr.h"

@interface ViewController ()

@end

@implementation ViewController

// 检测可导入图片 图片存在共享目录(Documents) ZJHPicture 文件夹内
- (IBAction)checkPicture {
    NSArray *pictureArr = [PictureImportMgr checkImportPicture];
    if (!pictureArr) {
        [ZJHTool showAlertWithMessage:@"无可导入图片" action:nil];
    } else {
        [ZJHTool showAlertWithTitle:@"导入提示"
                            message:@"检测有图片需要导入，是否导入？"
                        cancelTitle:@"取消"
                       confirmTitle:@"立即导入"
                             action:^(NSInteger btnIdx) {
                                 if (btnIdx) {
                                     PictureImportViewController *vc = [PictureImportViewController new];
                                     vc.pictureArr = pictureArr;
                                     [self.navigationController pushViewController:vc animated:YES];
                                 }
                             }];
    }    
}



@end
