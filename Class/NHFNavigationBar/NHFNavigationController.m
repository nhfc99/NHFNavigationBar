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

@property(nonatomic, strong) NSMutableArray *blackList;
@property(nonatomic, retain) UIPanGestureRecognizer *fullScreenGes;

@end

@implementation NHFNavigationController

#pragma mark - Lazy load
- (NSMutableArray *)blackList {
    if (!_blackList) {
        _blackList = [NSMutableArray array];
    }
    return _blackList;
}

#pragma mark - Public
- (void)addFullScreenPopBlackListItem:(UIViewController *)viewController {
    if (!viewController) {
        return ;
    }
    [self.blackList addObject:viewController];
}

- (void)removeFromFullScreenPopBlackList:(UIViewController *)viewController {
    for (UIViewController *vc in self.blackList) {
        if (vc == viewController) {
            [self.blackList removeObject:vc];
        }
    }
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationBar setTranslucent:YES];
    
    id target = self.interactivePopGestureRecognizer.delegate;
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    _fullScreenGes = [[UIPanGestureRecognizer alloc] initWithTarget:target action:handler];
    _fullScreenGes.delegate = self;
    
    self.fullPop = false;
}

- (void)setFullPop:(BOOL)fullPop {
    _fullPop = fullPop;
    
    UIView *targetView = self.interactivePopGestureRecognizer.view;
    if (fullPop) {
        [targetView addGestureRecognizer:_fullScreenGes];
        [self.interactivePopGestureRecognizer setEnabled:NO];
    } else {
        self.interactivePopGestureRecognizer.delegate = self;
        [self.interactivePopGestureRecognizer setEnabled:YES];
        [targetView removeGestureRecognizer:_fullScreenGes];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if (_fullPop) {
        for (UIViewController *viewController in self.blackList) {
            if ([self topViewController] == viewController) {
                return NO;
            }
        }
        
        if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
            return NO;
        }
        CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
        if (translation.x <= 0) {
            return NO;
        }
        return self.childViewControllers.count == 1 ? NO : YES;
    } else {
        if (self.viewControllers.count > 1) {
            UIViewController *viewController = self.topViewController;
            BOOL value = viewController.popGestureRecognizerEnable;
            return value;
        }
        return NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end










