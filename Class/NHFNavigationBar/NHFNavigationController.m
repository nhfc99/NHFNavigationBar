//
//  NHFNavigationControllerViewController.m
//  ProjectTemp
//
//  Created by 牛宏飞 on 2018/8/20.
//  Copyright © 2018年 网络科技. All rights reserved.
//

#define  NHFCoverAlpha 0.8

#import "NHFNavigationController.h"
#import "UINavigationBar+NHF.h"
#import "UIViewController+NHF.h"
#import "NHFCustomDispatchQueue.h"

@interface NHFNavigationController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *lastVCScreenShootArray;
@property (nonatomic, strong) UIImageView *lastVCScreenShootImageView;
@property (nonatomic, strong) UIView *lastVCScreenCoverView;
@property (nonatomic, strong) UIImageView *screenImageView;

@end

@implementation NHFNavigationController

- (UIImageView *)screenImageView {
    if (_screenImageView == nil) {
        _screenImageView = [UIImageView new];
        _screenImageView.frame = CGRectMake(100, 400, 100, 100);
        [[UIApplication sharedApplication].keyWindow addSubview:_screenImageView];
    }
    return _screenImageView;
}

//截频资源
- (NSMutableArray *)lastVCScreenShootArray {
    if (!_lastVCScreenShootArray) {
        _lastVCScreenShootArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _lastVCScreenShootArray;
}

//进行截频
- (void)takeScreenShoot {
    //    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size,NO,0);
    //    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    //    UIImage * newScreenSnapImg = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    
    //    [NHFCustomDispatchQueue dispatchByGlobal_mainqueue:^{
    //        UIImage * newScreenSnapImg = [UIImage imageWithData:[self imageDataScreenShot]];
    //        self.screenImageView.image = newScreenSnapImg;
    //        [self.lastVCScreenShootArray addObject:newScreenSnapImg];
    //    }];
    
    
    UIImage *newScreenSnapImg = [UIImage imageWithData:[self imageDataScreenShot]];
    [self.lastVCScreenShootArray addObject:newScreenSnapImg];
}

- (NSData *)imageDataScreenShot {
    CGSize imageSize = CGSizeZero;
    imageSize = [UIScreen mainScreen].bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

//最后一张截频
- (UIImageView *)lastVCScreenShootImageView {
    [_lastVCScreenShootImageView removeFromSuperview];
    UIImageView *shootImageView = [[UIImageView alloc] init];
    shootImageView.alpha= 0;
    shootImageView.frame = self.view.bounds;
    [self.view.superview insertSubview:shootImageView atIndex:0];
    [self.view.superview insertSubview:self.lastVCScreenCoverView atIndex:1];
    _lastVCScreenShootImageView = shootImageView;
    return _lastVCScreenShootImageView;
}

//图片上边的一个视图
- (UIView *)lastVCScreenCoverView {
    if (!_lastVCScreenCoverView) {
        UIView *converView = [[UIView alloc] init];
        converView.backgroundColor = [UIColor grayColor];
        converView.frame = self.view.bounds;
        converView.alpha = NHFCoverAlpha;
        [self.view.superview addSubview:converView];
        _lastVCScreenCoverView = converView;
    }
    
    return _lastVCScreenCoverView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.interactivePopGestureRecognizer.delegate = self;
    [self.navigationBar setTranslucent:YES];
    
    self.interactivePopGestureRecognizer.enabled = NO;
    [self addPanGestureRecognizer];
}

//添加手势
- (void)addPanGestureRecognizer {
    _panGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(popViewController:)];
    _panGestureRecognizer.edges = UIRectEdgeLeft;
    _panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_panGestureRecognizer];
}

- (void)popViewController:(UIPanGestureRecognizer *)recognizer {
    CGPoint transition = [recognizer translationInView:self.view];
    if (transition.x > 0) {
        UIImageView *lastVCScreenShootImageView = _lastVCScreenShootImageView;
        lastVCScreenShootImageView.alpha = 1;
        
        self.view.transform = CGAffineTransformMakeTranslation(transition.x, 0);
        
        NSInteger curItem = [self.viewControllers indexOfObjectIdenticalTo:self.topViewController];
        if (self.lastVCScreenShootArray.count > curItem) {
            UIImage *lastImage = [self.lastVCScreenShootArray objectAtIndex:curItem];
            lastVCScreenShootImageView.image = lastImage;
        }
        self.lastVCScreenCoverView.alpha = NHFCoverAlpha * (1 - transition.x / self.view.frame.size.width);
        
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            if (transition.x > self.view.frame.size.width / 3) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.lastVCScreenCoverView.alpha = 0;
                    self.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
                } completion:^(BOOL finished) {
                    self.view.transform = CGAffineTransformIdentity;
                    [super popViewControllerAnimated:NO];
                    
                    self.lastVCScreenShootArray = [[NSMutableArray alloc] initWithArray:[self.lastVCScreenShootArray subarrayWithRange:NSMakeRange(0, curItem)]];
                }];
            } else {
                [UIView animateWithDuration:0.25 animations:^{
                    self.lastVCScreenCoverView.alpha = NHFCoverAlpha;
                    self.view.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    self.view.transform = CGAffineTransformIdentity;
                }];
            }
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (!self.popGestureRecognizerEnable) {
        return NO;
    }
    if (self.childViewControllers.count <= 1) {
        return NO;
    }
    return YES;
}

- (void)requireGestureRecognizerToFailByScrollView:(UIScrollView *)scrollView {
    [scrollView.panGestureRecognizer requireGestureRecognizerToFail:_panGestureRecognizer];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //截频
    [self takeScreenShoot];
    //跳转
    [super pushViewController:viewController animated:animated];
    //更新视图
    [self lastVCScreenShootImageView];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    [self.lastVCScreenShootArray removeLastObject];
    return [super popViewControllerAnimated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end










