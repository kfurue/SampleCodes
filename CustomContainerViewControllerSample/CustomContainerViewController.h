//
//  PageBaseViewController.h
//  CustomContainerViewControllerSample
//
//  Created by kfurue on 2013/02/24.
//  Copyright (c) 2013年 kfurue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomContainerViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *rotationView;

@property (strong, nonatomic) IBOutlet UIRotationGestureRecognizer *rotationRecognizer;
@property (strong, nonatomic) IBOutlet UIView *contentView;
- (IBAction)recognizedRotationGesture:(id)sender;
@end
