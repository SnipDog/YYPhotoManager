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
    if (self.isCustom) {
        self.cover = [[UIButton alloc]initWithFrame:self.target.view.frame];
        self.cover.backgroundColor = [UIColor blackColor];
        self.cover.alpha = 0.3;
        [[UIApplication sharedApplication].keyWindow addSubview:self.cover];
        [self.cover addTarget:self action:@selector(clickedCover) forControlEvents:UIControlEventTouchUpInside];
        YYPhotoSheet *sheet = [[NSBundle mainBundle]loadNibNamed:@"YYPhotoSheet" owner:nil options:nil].lastObject;
        [sheet.openAlbumBtn addTarget:self action:@selector(openAlbum) forControlEvents:UIControlEventTouchUpInside];
        [sheet.takePhotoBtn addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
        [sheet.cancelBtn addTarget:self action:@selector(clickedCover) forControlEvents:UIControlEventTouchUpInside];
        sheet.frame = CGRectMake(0, kMainScreenBounds.height, kMainScreenBounds.width, kSheetHeight);
        [[UIApplication sharedApplication].keyWindow addSubview:sheet];
        [UIView animateWithDuration:0.3 animations:^{
            sheet.frame = CGRectMake(0, kMainScreenBounds.height - kSheetHeight, kMainScreenBounds.width, kSheetHeight);
            self.sheet = sheet;
        }];
    }else{

        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:instance cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开相册",@"打开相机", nil];
        [sheet showInView:self.target.view];
    }
}

- (void)clickedCover{
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.alpha = 0.0;
        self.sheet.frame = CGRectMake(0, kMainScreenBounds.height, kMainScreenBounds.width, kSheetHeight);
    } completion:^(BOOL finished) {
        [self.sheet removeFromSuperview];
    }];
}

- (void)openAlbum{
    [self clickedCover];
    QBImagePickerController *picker = [[QBImagePickerController alloc]init];
    picker.delegate = instance;
    picker.filterType = QBImagePickerControllerFilterTypePhotos;
    picker.allowsMultipleSelection = self.isAllowMultiSelect;
    picker.showsNumberOfSelectedAssets = YES;
    picker.maximumNumberOfSelection = self.maxSelections;
    [self.target presentViewController:picker animated:YES completion:nil];
}

- (void)openCamera{
        [self clickedCover];
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

#pragma mark - 
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self openAlbum];
    }else if (buttonIndex == 1){
        [self openCamera];
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
