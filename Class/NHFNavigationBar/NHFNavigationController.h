//
//  NHFNavigationControllerViewController.h
//  ProjectTemp
//
//  Created by 牛宏飞 on 2018/8/20.
//  Copyright © 2018年 网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NHFNavigationController : UINavigationController

@property (nonatomic, retain) UIScreenEdgePanGestureRecognizer *panGestureRecognizer;


/**
 解决手势冲突问题

 @param view --
 */
- (void)requireGestureRecognizerToFailByScrollView:(UIScrollView *)scrollView;

@end
