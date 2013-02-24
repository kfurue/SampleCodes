//
//  PageBaseAppDelegate.h
//  CustomContainerViewControllerSample
//
//  Created by kfurue on 2013/02/24.
//  Copyright (c) 2013年 kfurue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomContainerViewController;

@interface CustomContainerViewControllerSampleDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CustomContainerViewController *viewController;

@end
