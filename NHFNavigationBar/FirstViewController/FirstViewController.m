//
//  FirstViewController.m
//  NHFNavigationBar
//
//  Created by 牛宏飞 on 2019/5/13.
//  Copyright © 2019 网络科技. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)buttonAction:(id)sender {
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    SecondViewController *viewController = [SecondViewController new];
    viewController.hidesBottomBarWhenPushed = true;
    [viewControllers removeLastObject];
    [viewControllers addObject:viewController];
    [self.navigationController setViewControllers:viewControllers animated:YES];
}

@end
