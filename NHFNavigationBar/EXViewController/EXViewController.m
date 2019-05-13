//
//  EXViewController.m
//  NHFNavigationBar
//
//  Created by 牛宏飞 on 2018/8/22.
//  Copyright © 2018年 网络科技. All rights reserved.
//

#import "EXViewController.h"
#import "UIViewController+NHF.h"
#import "FirstViewController.h"

@interface EXViewController ()

@end

@implementation EXViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.popGestureRecognizerEnabled = true;
    [self setNhfBarTintColor:[UIColor whiteColor] alpha:1.f];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonAction:(id)sender {
    FirstViewController *viewController = [FirstViewController new];
    viewController.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:viewController animated:true];
}

@end
