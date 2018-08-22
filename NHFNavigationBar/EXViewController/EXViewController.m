//
//  EXViewController.m
//  NHFNavigationBar
//
//  Created by 牛宏飞 on 2018/8/22.
//  Copyright © 2018年 网络科技. All rights reserved.
//

#import "EXViewController.h"
#import "UIViewController+NHF.h"

@interface EXViewController ()

@end

@implementation EXViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.popGestureRecognizerEnable = true;
    [self setNhfBarTintColor:[UIColor greenColor] alpha:0.1];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
