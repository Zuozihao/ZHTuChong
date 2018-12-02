//
//  ViewController.m
//  ZHTuChong
//
//  Created by 左梓豪 on 2018/11/30.
//  Copyright © 2018 左梓豪. All rights reserved.
//

#import "ViewController.h"
#import "ZHScrollMenu.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubViews];
    NSLog(@"naviheight%f",self.navigationController.navigationBar.frame.size.height);
}

- (void)initSubViews {
    ZHScrollMenu *menu = [[ZHScrollMenu alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    menu.titleHeight = 40;
    menu.titles = @[@"关注",@"推荐",@"壁纸",@"萌宠",@"美食",@"教程",@"热门",@"视频",@"最新",@"人像"];
    [self.view addSubview:menu];
}

- (UIImage*)createImageWithColor:(UIColor*)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
