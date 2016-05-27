//
//  ViewController.m
//  YYPhotoManager
//
//  Created by Heisenbean on 16/5/27.
//  Copyright © 2016年 Heisenbean. All rights reserved.
//

#import "ViewController.h"
#import "YYPhotoManager.h"
@interface ViewController () <YYPhotoManagerDelegate>
@property (strong,nonatomic) YYPhotoManager *manager;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)singleSelection:(id)sender {
    [self.manager show];
}

- (IBAction)multiSelection:(id)sender {
    self.manager.isAllowMultiSelect = YES;
    self.manager.maxSelections = 6;
    [self.manager show];
}

- (IBAction)showCustomSheet:(id)sender {
    self.manager.isCustom = YES;
    [self.manager show];
}


- (void)didFinishEditPhoto:(UIImage *)image{
    self.imageView.image = image;
}

- (void)didFinishTakePhoto:(UIImage *)image{
    self.imageView.image = image;
}

- (void)didFinishPickingPhotos:(NSArray *)images{
    NSLog(@"%@",images);
}


#pragma mark - lazy
- (YYPhotoManager *)manager{
    if (!_manager) {
        _manager = [YYPhotoManager defaultManager];
        _manager.delegate = self;
        _manager.target = self;
    }
    return _manager;
}

@end
