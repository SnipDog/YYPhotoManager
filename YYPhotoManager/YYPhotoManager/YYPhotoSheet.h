//
//  YYPhotoSheet.h
//  YYPhotoManager
//
//  Created by Heisenbean on 16/5/27.
//  Copyright © 2016年 Heisenbean. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMainScreenBounds [UIScreen mainScreen].bounds.size
#define kSheetHeight 222
@interface YYPhotoSheet : UIView
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *openAlbumBtn;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoBtn;
@end
