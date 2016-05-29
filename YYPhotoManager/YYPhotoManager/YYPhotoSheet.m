//
//  YYPhotoSheet.m
//  YYPhotoManager
//
//  Created by Heisenbean on 16/5/27.
//  Copyright © 2016年 Heisenbean. All rights reserved.
//

#import "YYPhotoSheet.h"
@implementation YYPhotoSheet


//UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:instance cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开相册",@"打开相机", nil];
- (void)awakeFromNib{
    self.takePhotoBtn.layer.borderColor = [UIColor colorWithRed:119.0/255.0 green:152.0/255.0 blue:0 alpha:1.0].CGColor;
    self.openAlbumBtn.layer.borderColor = [UIColor colorWithRed:119.0/255.0 green:152.0/255.0 blue:0 alpha:1.0].CGColor;
    self.cancelBtn.layer.borderColor = [UIColor colorWithRed:173.0/255.0 green:174.0/255.0 blue:175/255.0 alpha:1.0].CGColor;
}

- (IBAction)cancel {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kMainScreenBounds.height, kMainScreenBounds.width, kSheetHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
