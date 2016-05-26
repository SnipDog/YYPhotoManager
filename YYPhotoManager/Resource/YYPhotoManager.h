//
//  YYPhotoManager.h
//  YYPhotoManager
//
//  Created by Heisenbean on 16/5/25.
//  Copyright © 2016年 Heisenbean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QBImagePickerController.h"
#import "VPImageCropperViewController.h"

@protocol YYTakePhotoToolDelegate <NSObject>
/**
 *  照片选择完成
 */
- (void)didFinishPickingAssets:(NSArray *)assets;
/**
 *  拍照完成
 */
- (void)didFinishTakePhoto:(UIImage *)image;

/**
 *  编辑照片完成
 */
- (void)didFinishEditPhoto:(UIImage *)image;
@end


@interface YYPhotoManager : NSObject <QBImagePickerControllerDelegate,UIImagePickerControllerDelegate,VPImageCropperDelegate>

+ (instancetype)defaultManager;

- (void)show;
/**
 * 最大照片选择数
 */
@property (nonatomic,assign) NSInteger maxSelections;
/**
 *  是否允许多选
 */
@property (nonatomic,assign) BOOL isAllowMultiSelect;

/**
 *  源控制器
 */
@property (strong,nonatomic) UIViewController *target;

@property (nonatomic,weak) id <YYTakePhotoToolDelegate> delegate;

@end
