//
//  PictureImportViewController.m
//  ZJHPictureImport
//
//  Created by ZhangJingHao2345 on 2017/11/16.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#import "PictureImportViewController.h"
#import <Photos/Photos.h>
#import "PictureImportHeader.h"
#import "PictureImportedView.h"
#import "PictureImportingView.h"
#import "ZJHTool.h"

/// 导入图片状态
typedef NS_ENUM(NSInteger, ImportStates) {
    ImportStatePrepare    = 0, // 准备导入
    ImportStateImporting  = 1, // 导入中
    ImportStateImported   = 2, // 导入成功
};

@interface PictureImportViewController ()

@property (nonatomic, weak  ) PictureImportingView *importingView;
@property (nonatomic, assign) ImportStates state;
@property (nonatomic, assign) int index; // 图片导入位置
@property (nonatomic, assign) int succCount; // 导入成功数

@end

@implementation PictureImportViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图片导入";
    self.view.backgroundColor = [UIColor whiteColor];
    self.state = ImportStatePrepare;
    self.index = 0;
    self.succCount = 0;
    
    [self judgePhotoAuthor];
}

// 导入中UI
- (void)setupImportingUI {
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    PictureImportingView *importingView =
    [[PictureImportingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:importingView];
    self.importingView = importingView;
}

// 导入完成UI
- (void)setupImportedUI {
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    PictureImportedView *importedView =
    [[PictureImportedView alloc] initWithFrame:self.view.bounds];
    [importedView setupUIWithPictureCount:self.succCount];
    [self.view addSubview:importedView];
    __weak id wkSelf = self;
    importedView.lookPictureBlock = ^{
        [wkSelf lookImportPicture];
    };
}

#pragma mark - Save Image

// 判断相册权限
- (void)judgePhotoAuthor {
    if (self.state == ImportStateImporting) {
        return;
    } else {
        self.state = ImportStatePrepare;
        self.index = 0;
        self.succCount = 0;
        [self setupImportingUI];
    }
    
    // 获取当前App的相册授权状态
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    // 判断授权状态
    if (authorizationStatus == PHAuthorizationStatusAuthorized) {
        // 如果已经授权, 保存图片
        [self saveImage];
    }
    // 如果没决定, 弹出指示框, 让用户选择
    else if (authorizationStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            // 如果用户选择授权, 则保存图片
            if (status == PHAuthorizationStatusAuthorized) {
                [self saveImage];
            }
        }];
    } else {
        [ZJHTool showAlertWithTitle:@"此功能需要相册授权"
                            message:@"请您在设置系统中打开授权开关"
                        cancelTitle:@"取消"
                       confirmTitle:@"前往设置"
                             action:^(NSInteger btnIdx) {
                                 if (btnIdx) {
                                     NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                     [[UIApplication sharedApplication] openURL:url];
                                 }
                             }];
    }
}

// 存储图片
- (void)saveImage {
    self.state = ImportStateImporting;
    
    // 获取相片库对象
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    
    // 调用changeBlock
    [library performChanges:^{
        
        // 创建一个相册变动请求
        PHAssetCollectionChangeRequest *collectionRequest = [self getCurrentPhotoCollection];
        
        // 根据传入的相片, 创建相片变动请求
        NSString *imgStr = self.pictureArr[self.index];
        // iOS8系统需要添加 file:// 协议头
        NSString *fileStr = [NSString stringWithFormat:@"file://%@", imgStr];
        NSURL *fileUrl = [NSURL URLWithString:fileStr];
        
        // 视频、图片类型分开创建 Request
        NSString *ext = imgStr.pathExtension;
        NSString *extLower = ext.lowercaseString;
        PHAssetChangeRequest *assetRequest = nil;
        if ([extLower isEqualToString:@"mov"]) {
            assetRequest =
            [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:fileUrl];
        } else {
            assetRequest =
            [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:fileUrl];
        }
        
        // 创建一个占位对象
        PHObjectPlaceholder *placeholder = [assetRequest placeholderForCreatedAsset];
        // 将占位对象添加到相册请求中
        [collectionRequest addAssets:@[placeholder]];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        // 成功回调在子线程，需要转到主线程刷新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveCompleteWithSuccess:success];
        });
    }];
}

// 创建一个相簿变动请求
- (PHAssetCollectionChangeRequest *)getCurrentPhotoCollection{
    // 相簿名
    NSString *collName = self.title;
    // 获取相簿集合
    PHFetchResult *result =
    [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                             subtype:PHAssetCollectionSubtypeAlbumRegular
                                             options:nil];

    // 遍历选取已创建的相簿
    for (PHAssetCollection *assetCollection in result) {
        if ([assetCollection.localizedTitle containsString:collName]) {
            return [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];;
        }
    }
    
    // 创建新的相簿
    return [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:collName];
}

- (void)saveCompleteWithSuccess:(BOOL)success {
    NSString *filePath = self.pictureArr[self.index];
    self.index = self.index + 1;
    if (success) { // 删除已存储成功图片
        self.succCount = self.succCount + 1;
        NSString *decodePath = [filePath stringByRemovingPercentEncoding];
        [[NSFileManager defaultManager] removeItemAtPath:decodePath error:nil];
    }

    if (self.index >= self.pictureArr.count) {
        self.state = ImportStateImported;
        [self setupImportedUI];
    } else {
        [self.importingView updateUIWithIndex:self.index
                                  andAllCount:self.pictureArr.count];
        [self saveImage];
    }
}

#pragma mark - Other

// 打开相册，此方法调用了私有API,不建议使用
- (void)lookImportPicture {
// 消除警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    Class LSAppClass = NSClassFromString(@"LSApplicationWorkspace");
    id workSpace = [(id)LSAppClass performSelector:@selector(defaultWorkspace)];
    [workSpace performSelector:@selector(openApplicationWithBundleID:)
                    withObject:@"com.apple.mobileslideshow"];
#pragma clang diagnostic pop
}

@end
