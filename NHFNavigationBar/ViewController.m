//
//  ViewController.m
//  NHFNavigationBar
//
//  Created by 牛宏飞 on 2018/8/22.
//  Copyright © 2018年 网络科技. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+NHF.h"

#define JUMPViewController(navigationController, controller) \
UIViewController *viewController = [NSClassFromString(controller) new];\
[viewController setHidesBottomBarWhenPushed:true];\
[navigationController pushViewController:viewController animated:true];

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.popGestureRecognizerEnable = true;
    [self setNhfBarTintColor:[UIColor yellowColor] alpha:1];
    self.nhfHidBar = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor redColor]];
    [button setFrame:CGRectMake(0, 0, 100, 100)];
    [button setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2)];
    [self.view addSubview:button];
    
    [self.view setBackgroundColor:[UIColor orangeColor]];
}

- (void)buttonAction {
    JUMPViewController(self.navigationController, @"EXViewController");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
