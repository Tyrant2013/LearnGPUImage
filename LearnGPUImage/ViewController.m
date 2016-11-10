//
//  ViewController.m
//  LearnGPUImage
//
//  Created by 庄晓伟 on 16/11/9.
//  Copyright © 2016年 Zhuang Xiaowei. All rights reserved.
//

#import "ViewController.h"
#import <GPUImage.h>

@interface ViewController () <
  UIScrollViewDelegate
>

@property (nonatomic, weak) UIImageView                     *mixImageView;
@property (nonatomic, assign) CGFloat                       originHeight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat startPos = 400.0f;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:imageView];
    UIImage *image = [UIImage imageNamed:@"aa.jpg"];
    imageView.image = image;
    
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.bounces = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    UIView *topView = [[UIView alloc] initWithFrame:(CGRect){0, 0, screenWidth, startPos}];
    topView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:topView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:(CGRect){0, startPos, screenWidth, screenHeight}];
    bottomView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:bottomView];
    scrollView.contentSize = (CGSize){screenWidth, screenHeight + startPos};
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
    CGFloat posY = startPos;
    CGFloat height = screenHeight - startPos;
    self.originHeight = height;
    UIImageView *mixImageView = [[UIImageView alloc] initWithFrame:(CGRect){0, 0, screenWidth, height}];
    self.mixImageView = mixImageView;
    [bottomView addSubview:mixImageView];
    
    
    GPUImageGaussianBlurFilter *gaussianFilter = [[GPUImageGaussianBlurFilter alloc] init];
    gaussianFilter.blurRadiusInPixels = 5.0f;
    UIImage *gaussianImage = [gaussianFilter imageByFilteringImage:image];
    mixImageView.image = gaussianImage;
    CGFloat unintY = posY / screenHeight;
    CGFloat unintH = (screenHeight - startPos) / screenHeight;
    mixImageView.backgroundColor = [UIColor blueColor];
    mixImageView.layer.contentsRect = (CGRect){0, unintY, 1.0f, unintH};
    mixImageView.layer.contentsScale = [UIScreen mainScreen].scale;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height = self.originHeight;
    CGFloat offsetY = scrollView.contentOffset.y;
    height += offsetY;
    CGRect frame = self.mixImageView.frame;
    frame.size.height = height;
    
    CGFloat unitH = height / CGRectGetHeight([UIScreen mainScreen].bounds);
    CGRect rect = self.mixImageView.layer.contentsRect;
    rect.size.height = unitH;
    rect.origin.y = (CGRectGetHeight([UIScreen mainScreen].bounds) - height) / CGRectGetHeight([UIScreen mainScreen].bounds);
    self.mixImageView.layer.contentsRect = rect;
    self.mixImageView.frame = frame;
}


@end
