//
//  ZJHTool.m
//  ZJHPictureImport
//
//  Created by ZhangJingHao2345 on 2017/11/16.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#import "ZJHTool.h"

@implementation ZJHTool


+ (UIAlertController *)showAlertWithMessage:(NSString *)message
                                     action:(ZJHAlertBlock)action {
    return [self showAlertWithTitle:@"温馨提示"
                            message:message
                        cancelTitle:@"确定"
                       confirmTitle:nil
                             action:action];
}

+ (UIAlertController *)showAlertWithTitle:(NSString *)title
                                  message:(NSString *)message
                              cancelTitle:(NSString *)cancelTitle
                             confirmTitle:(NSString *)confirmTitle
                                   action:(ZJHAlertBlock)action {
    ZJHAlertBlock callBack = ^(NSInteger btnIdx){
        if (action) {
            action(btnIdx);
        }
    };
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    if (cancelTitle) {
        UIAlertAction *cancel =
        [UIAlertAction actionWithTitle:cancelTitle
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction *action) {
                                   callBack(0);
                               }];
        [alert addAction:cancel];
    }
    if (confirmTitle) {
        UIAlertAction *confirm =
        [UIAlertAction actionWithTitle:confirmTitle
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   callBack(1);
                               }];
        [alert addAction:confirm];
    }
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVc presentViewController:alert
                         animated:YES
                       completion:nil];
    return alert;
}

@end
