//
//  PictureImportViewController.h
//  ZJHPictureImport
//
//  Created by ZhangJingHao2345 on 2017/11/16.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureImportViewController : UIViewController

@property (nonatomic, strong) NSArray *pictureArr;

- (void)judgePhotoAuthor;

@end
