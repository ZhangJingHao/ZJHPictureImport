# ZJHPictureImport
通过PHPhotoLibrary，将共享目录中图片批量导入相册

详情请参考：http://www.jianshu.com/p/1b3616945fc3

### 一、基本配置
开启共享目录功能，在 Info.plist 文件中添加 `UIFileSharingEnabled` 这个Key, 并设置该值为 YES 即可。在填写完 UIFileSharingEnabled 并回车后, 发现会自动更正为Application supports iTunes file sharing , 将值设置为YES 即可。

开启相册权限，info.plist 文件中添加 `NSPhotoLibraryUsageDescription` 这个Key, 并描述开启该功能理由。调用PHPhotoLibrary时，需要导入 <Photos/Photos.h> 框架。

### 二、检测共享目录中图片
将图片文件导入共享目录中。通过 NSFileManager 检测该文件夹及文件夹中的图片是否合法。然后返回有效图片数组。例：

```
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
```

### 三、判断相册权限

通过该方法 + (PHAuthorizationStatus)authorizationStatus 获取相册的授权状态。

```
// 相册授权状态
typedef NS_ENUM(NSInteger, PHAuthorizationStatus) {
    PHAuthorizationStatusNotDetermined = 0, // 用户还没有决定是否授权
    PHAuthorizationStatusRestricted,        // 访问权限受限制, 如家长模式的限制才会有
    PHAuthorizationStatusDenied,            // 用户拒绝App访问相册
    PHAuthorizationStatusAuthorized         // 用户已经授权了访问
} PHOTOS_AVAILABLE_IOS_TVOS(8_0, 10_0);
```
如果这个方法返回PHAuthorizationStatusNotDetermined，则可以使用 + (void)requestAuthorization:(void (^)(PHAuthorizationStatus status))handler 方法提示用户授权对照片库的访问。例：

```
// 判断相册权限
- (void)judgePhotoAuthor {
   
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
        // 前往设置
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}
```

### 四、获取相簿
根据相簿名获取相簿。通过 PHAssetCollection 类获取相簿集，遍历搜索集合并取出对应的相簿，然后创建相簿变动请求，若无结果，则通过 PHAssetCollectionChangeRequest 新建相簿变动请求。例：

```
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
```

### 五、存储图片、视频

+(PHPhotoLibrary *)sharedPhotoLibrary; 获取共享照片库对象，即获取 PHPhotoLibrary 的单例。

-(void)performChanges:(dispatch_block_t)changeBlock completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler; 异步运行changeBlock回调，来请求执行对照片库的修改。
Photos会在任意的串行队列上调用你的changeBlock回调和handler回调，如果你的回调中有需要与UI进行交互的内容，请将此工作分配到主线程。

注意点1：创建图片路径 url 时，需要对含中文的文件名进行编码，否则，可能导致创建失败
注意点2：iOS8系统需要在文件路径添加协议头 `file://` 否则，可能导致存储失败
注意点3：创建相片请求 `PHAssetChangeRequest` 时，图片和视频要分开创建，图片使用： creationRequestForAssetFromImageAtFileURL；视频使用：creationRequestForAssetFromVideoAtFileURL。
例：

```
// 存储图片
- (void)saveImage {    
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
        // 回调在子线程，需要转到主线程刷新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveCompleteWithSuccess:success];
        });
    }];
}
```



