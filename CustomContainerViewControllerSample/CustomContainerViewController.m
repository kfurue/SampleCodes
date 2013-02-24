//
//  PageBaseViewController.m
//  CustomContainerViewControllerSample
//
//  Created by kfurue on 2013/02/24.
//  Copyright (c) 2013年 kfurue. All rights reserved.
//

#import "CustomContainerViewController.h"
#import "ContentViewController1.h"
#import "ContentViewController2.h"
#import "ContentViewController3.h"

@interface CustomContainerViewController ()
@property UIViewController *currentContentViewController;
@property NSMutableArray *contentViewControllers;
- (void)layoutContentView;
@end

@implementation CustomContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _contentViewControllers = [NSMutableArray array];
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setRotationView:nil];
    [self setRotationRecognizer:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}

- (void)loadView {
    [super loadView];
    
    ContentViewController1 *vc1 = [[ContentViewController1 alloc] initWithNibName:@"ContentViewController1" bundle:nil];
    vc1.view.frame = self.contentView.frame;

    self.contentView = vc1.view;
    [self addChildViewController:vc1];
    [self.view addSubview:vc1.view];
    [vc1 didMoveToParentViewController:self];
    self.currentContentViewController = vc1;
    [_contentViewControllers addObject:vc1];
    
    ContentViewController2 *vc2 = [[ContentViewController2 alloc] initWithNibName:@"ContentViewController2" bundle:nil];
    vc2.view.frame = self.contentView.frame;
    
    self.contentView = vc2.view;
    [self addChildViewController:vc2];
    [_contentViewControllers addObject:vc2];
    
    ContentViewController3 *vc3 = [[ContentViewController3 alloc] initWithNibName:@"ContentViewController3" bundle:nil];
    vc3.view.frame = self.contentView.frame;
    
    self.contentView = vc3.view;
    [self addChildViewController:vc3];
    [_contentViewControllers addObject:vc3];
    


}
- (IBAction)recognizedRotationGesture:(id)sender {
    
    UIRotationGestureRecognizer *recognizer = sender;
//    NSLog(@"%s, %f", __PRETTY_FUNCTION__, recognizer.rotation);
    
    CGFloat originX; // use for animation
    CGRect frame = _currentContentViewController.view.frame;

    NSInteger idx = [self.childViewControllers indexOfObject:_currentContentViewController]; //use for deciding next ViewController

    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (recognizer.rotation > 0) { // clockwise
            originX = frame.origin.x - frame.size.width;
            idx++;
            if (idx == [self.childViewControllers count]) {
                idx = 0;
            }
        } else { // counter clockwise
            originX = frame.origin.x + frame.size.width;
            idx--;
            if (idx < 0) {
                idx = [self.childViewControllers count] - 1;
            }
        }
        
        UIViewController *toViewController = [self.childViewControllers objectAtIndex:idx];
        toViewController.view.frame = CGRectMake(originX,
                                                 frame.origin.y,
                                                 frame.size.width,
                                                 frame.size.height);
        [self transitionFromViewController:_currentContentViewController
                          toViewController:toViewController
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionNone
                                animations:^{
                                    toViewController.view.frame = CGRectMake(frame.origin.x,
                                                                             frame.origin.y,
                                                                             frame.size.width,
                                                                             frame.size.height);
                                    
                                    _currentContentViewController.view.frame = CGRectMake(frame.origin.x - originX,
                                                                                          frame.origin.y,
                                                                                          frame.size.width,
                                                                                          frame.size.height);
                                }
                                completion:^(BOOL finished) {
                                    _currentContentViewController = toViewController;
                                    [toViewController didMoveToParentViewController:self];
                                }];
    }
}

@end
