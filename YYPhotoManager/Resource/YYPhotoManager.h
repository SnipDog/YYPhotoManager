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
#import "YYPhotoSheet.h"
@protocol YYPhotoManagerDelegate <NSObject>
/**
 *  照片选择完成
 */
- (void)didFinishPickingPhotos:(NSArray *)images;
/**
 *  拍照完成
 */
- (void)didFinishTakePhoto:(UIImage *)image;

/**
 *  编辑照片完成
 */
- (void)didFinishEditPhoto:(UIImage *)image;
@end


@interface YYPhotoManager : NSObject <UIImagePickerControllerDelegate,UIActionSheetDelegate,QBImagePickerControllerDelegate,VPImageCropperDelegate>

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

/**
 *  蒙版
 */
@property (strong,nonatomic) UIButton *cover;

/**
 *  自定义sheet
 */
@property (strong,nonatomic) YYPhotoSheet *sheet;

/**
 *  是否使用自定义sheet
 */
@property (nonatomic,assign) BOOL isCustom;


@property (nonatomic,weak) id <YYPhotoManagerDelegate> delegate;

@end
