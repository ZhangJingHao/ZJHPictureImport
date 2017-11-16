//
//  ZJHTool.h
//  ZJHPictureImport
//
//  Created by ZhangJingHao2345 on 2017/11/16.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ZJHAlertBlock)(NSInteger btnIdx);

@interface ZJHTool : NSObject

/**
 文字弹框（单选）
 
 @param message 内容
 @param action 事件
 */
+ (UIAlertController *)showAlertWithMessage:(NSString *)message
                                     action:(ZJHAlertBlock)action;

/**
 文字弹框（双选）
 
 @param title 标题
 @param message 内容
 @param action 事件
 @param cancelTitle 左边按钮标题
 @param confirmTitle 右边按钮标题
 */
+ (UIAlertController *)showAlertWithTitle:(NSString *)title
                                  message:(NSString *)message
                              cancelTitle:(NSString *)cancelTitle
                             confirmTitle:(NSString *)confirmTitle
                                   action:(ZJHAlertBlock)action;

@end
