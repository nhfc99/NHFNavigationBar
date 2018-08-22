//
//  NHFNavigationControllerViewController.m
//  ProjectTemp
//
//  Created by 牛宏飞 on 2018/8/20.
//  Copyright © 2018年 网络科技. All rights reserved.
//

#import "NHFNavigationController.h"
#import "UINavigationBar+NHF.h"
#import "UIViewController+NHF.h"

@interface NHFNavigationController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation NHFNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.interactivePopGestureRecognizer.delegate = self;
    [self.navigationBar setTranslucent:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count > 1) {
        UIViewController *viewController = self.topViewController;
        BOOL value = viewController.popGestureRecognizerEnable;
        return value;
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end










