//
//  ViewController.m
//  BaseProject
//
//  Created by jiyingxin on 15/10/22.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "ViewController.h"
#import "NSString+QRCode.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//输入输出的中间桥
@property (nonatomic,strong)AVCaptureSession *session;
//把摄像的画面显示在界面上的layer
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *layer;

@end

@implementation ViewController
//扫描 二维码，需要av框架支持
- (IBAction)scanQRCod:(id)sender {
//获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
//创建输出流
    AVCaptureMetadataOutput *output = [AVCaptureMetadataOutput new];
//设置代理，在主线程中刷新
   [ output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
//初始化输入输出会话对象
    _session = [AVCaptureSession new];
//设置高质量传输
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
//设置输出流
    [_session addInput:input];
//设置输入流
    [_session addOutput:output];
//设置扫描支持的格式
    output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code];
//把session中的画面读出来
    self.layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
//设置铺满全屏
    self.layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//设置layer的大小
    self.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.layer];
//启动扫描
    [_session startRunning];
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
//        
//        [_session stopRunning];
//        [self.layer removeFromSuperlayer];
        [self showSuccessMsg:obj.stringValue];
        NSLog(@"扫描结果 %@",obj.stringValue);
    }

}

//生成二维码
- (IBAction)createQRCod:(id)sender {
    
      _imageView.image = [@" 打开附近丢失了飞机上的李开复；历史的快乐；但是开放了；电视剧费拉达斯积分多少；" imageForQRCode:_imageView.frame.size.width];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
