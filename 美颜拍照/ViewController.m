//
//  ViewController.m
//  美颜拍照
//
//  Created by TOPTEAM on 16/9/13.
//  Copyright © 2016年 TOPTEAM. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"
#define VIDEO_RECT CGRectMake(40, 64, 240, 320)



@interface ViewController ()

@end

@implementation ViewController
{
    GPUImageStillCamera *_stillCamera;  /// 照相机
    GPUImageView        *_frameView;    /// 图像框
    GPUImageBeautifyFilter *_beautifyFilter; /// 美颜滤镜
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
     [self beautifyVideo];
}
- (void)beautifyVideo {
    _stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    _beautifyFilter = [GPUImageBeautifyFilter new];
    _frameView      = [[GPUImageView alloc] initWithFrame:VIDEO_RECT];
    
    [_beautifyFilter addTarget:_frameView];
    [_stillCamera addTarget:_beautifyFilter];
    
    [self.view addSubview:_frameView];
    [_stillCamera startCameraCapture];
}

- (IBAction)takePhotoBtnClick {
    [_stillCamera capturePhotoAsPNGProcessedUpToFilter:_beautifyFilter withCompletionHandler:^(NSData *processedPNG, NSError *error) {
        if (error) NSLog(@"error = %@", error);
        
        UIImage *image = [UIImage imageWithData:processedPNG];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:VIDEO_RECT];
        imageView.image = image;
        [self.view addSubview:imageView];
        
        NSLog(@"image = %@", image);
        NSLog(@"currentThread = %@", [NSThread currentThread]);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
