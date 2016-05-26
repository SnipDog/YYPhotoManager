//
//  YYPhotoManager.m
//  YYPhotoManager
//
//  Created by Heisenbean on 16/5/25.
//  Copyright © 2016年 Heisenbean. All rights reserved.
//

#import "YYPhotoManager.h"
@implementation YYPhotoManager

static id instance;

+(instancetype)defaultManager{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    
    return instance;
}

- (void)show{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *ablum = [UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [instance openAblum];
    }];
    
    
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [instance openCamera];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:ablum];
    [alert addAction:camera];
    [alert addAction:cancel];
    [self.target presentViewController:alert animated:YES completion:nil];
}

- (void)openAblum{
    QBImagePickerController *picker = [[QBImagePickerController alloc]init];
    picker.delegate = instance;
    picker.filterType = QBImagePickerControllerFilterTypePhotos;
    picker.allowsMultipleSelection = self.isAllowMultiSelect;
    picker.showsNumberOfSelectedAssets = YES;
    picker.maximumNumberOfSelection = self.maxSelections;
    [self.target presentViewController:picker animated:YES completion:nil];
}

- (void)openCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePk = [[UIImagePickerController alloc] init];
        imagePk.allowsEditing = YES;
        imagePk.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePk.cameraDevice =  UIImagePickerControllerCameraDeviceRear;
        imagePk.cameraCaptureMode =  UIImagePickerControllerCameraCaptureModePhoto;
        imagePk.delegate = instance;
        [self.target presentViewController:imagePk animated:YES completion:nil];
    }
}

#pragma mark - QBImagePickerControllerDelegate
// 多选
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets{
    NSMutableArray *temp = [NSMutableArray array];
    for (ALAsset *asset in assets) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        CGImageRef resolutionRef = [representation fullResolutionImage];
        UIImage *image = [UIImage imageWithCGImage:resolutionRef scale:1.0f orientation:(UIImageOrientation)representation.orientation];
        [temp addObject:image];
    }
    
    [self.target dismissViewControllerAnimated:YES completion:^{
        [self.delegate didFinishPickingPhotos:temp];
    }];
}

// 单选
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset{
    [self.target dismissViewControllerAnimated:NO completion:^{
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        CGImageRef resolutionRef = [representation fullResolutionImage];
        UIImage *image = [UIImage imageWithCGImage:resolutionRef scale:1.0f orientation:(UIImageOrientation)representation.orientation];
        
        VPImageCropperViewController *vp = [[VPImageCropperViewController alloc]initWithImage:image cropFrame:CGRectMake(0, 100.0f, self.target.view.frame.size.width, self.target.view.frame.size.width) limitScaleRatio:3.0];
        vp.delegate = instance;
        [self.target presentViewController:vp animated:YES completion:nil];
    }];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [self.target dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = nil;
    if (picker.allowsEditing) {
        // 允许编辑
        image = info[UIImagePickerControllerEditedImage];
    }else
    {
        image = info[UIImagePickerControllerOriginalImage];
    }
    [self.delegate didFinishTakePhoto:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - VPImageCropperDelegate

- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage{
    [self.target dismissViewControllerAnimated:YES completion:^{
        [self.delegate didFinishEditPhoto:editedImage];
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController{
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
