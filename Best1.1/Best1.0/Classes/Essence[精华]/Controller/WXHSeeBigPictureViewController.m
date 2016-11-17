//
//  WXHSeeBigPictureViewController.m
//  Best1.0
//
//  Created by 初七 on 2016/11/14.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHSeeBigPictureViewController.h"
#import <UIImageView+WebCache.h>
#import "WXHTopic.h"
#import <SVProgressHUD.h>
#import <Photos/Photos.h>
@interface WXHSeeBigPictureViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property(nonatomic,weak) UIScrollView *scrollView;
@property(nonatomic,weak) UIImageView *imageView;
@end

@implementation WXHSeeBigPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupSubviews];
}

-(void)setupSubviews{

    // 滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = [UIScreen mainScreen].bounds;
    self.scrollView = scrollView;
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction)]];
    [self.view insertSubview:scrollView atIndex:0];
    
    // 图片视图
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.image1] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
     
        if (!image) return;
        self.saveButton.enabled = YES;
        
    }];
    imageView.wxh_width = scrollView.wxh_width;
    imageView.wxh_height = imageView.wxh_width * self.topic.height / self.topic.width;
    imageView.wxh_x = 0;
    if (imageView.wxh_height > kHeight) { // 需要滚动
        imageView.wxh_y = 0;
        scrollView.contentSize = CGSizeMake(0, imageView.wxh_height);
    }else{
        imageView.wxh_centerY = scrollView.wxh_height * 0.5;
    }
    [scrollView addSubview:imageView];
    // 缩放比例
    CGFloat maxScale = self.topic.width / imageView.wxh_width;
    if (maxScale > 1) {
        scrollView.maximumZoomScale = maxScale;
        scrollView.delegate = self;
    }
    
}
#pragma mark - <UIScrollViewDelegate>
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}
- (IBAction)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 保存图片
- (IBAction)saveAction:(UIButton *)sender {
    
    // 请求\检查访问权限:
    // 如果用户还没有做出选择，会自动弹框，用户对弹框做出选择后，才会调用block
    // 如果之前已经做过选择，会直接执行block
    
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前App访问相册
                if (oldStatus != PHAuthorizationStatusNotDetermined) {
                    WXHLOG(@"提醒用户打开开关");
                }
            } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前App访问相册
                [self savePictureIntoAlbum];
            } else if (status == PHAuthorizationStatusRestricted) { // 无法访问相册
                [SVProgressHUD showErrorWithStatus:@"因系统原因，无法访问相册！"];
            }

        });
    }];

}

#pragma mark - 保存图片到自定义相册
-(void)savePictureIntoAlbum{

    // 获得相片(保存的照片)
    PHFetchResult<PHAsset *> *assets = [self createAssets];
    if (assets == nil) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败"];
        return;
    }
    // 获得相册(自定义相册)
    PHAssetCollection *assetCollection = [self createCollection];
    if (assetCollection == nil) {
        [SVProgressHUD showErrorWithStatus:@"创建或者获取相册失败"];
        return;
    }
    // 添加刚才保存的照片到自定义相册
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *collectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        [collectionRequest insertAssets:assets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    // 最后的判断
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存图片成功"];
    }
}
#pragma mark * 获得相片(保存的照片)
-(PHFetchResult<PHAsset *> *)createAssets{
    
    NSError *error = nil;
    __block NSString *assetID = nil;
    // 保存图片到相机胶卷
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        assetID = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    if (error) return nil;
    // 获取刚才保存的照片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil];
}
#pragma mark * 获得相册(自定义相册)
-(PHAssetCollection *)createCollection{

    // 获取app的名字
    NSString *title = [NSBundle mainBundle].infoDictionary[(__bridge NSString *)kCFBundleNameKey];
    // 获取所有的自定义相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 查找当前app对应的自定义相册
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) return collection;
    }
    
    /** 当前app对应的自定义相册没有被创建**/
    // 创建一个自定义相册
    NSError *error = nil;
    __block NSString *assetCollectionID = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        assetCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    if (error) return nil;
    // 根据唯一标识获得刚才创建的相册
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionID] options:nil].firstObject;
}

@end
