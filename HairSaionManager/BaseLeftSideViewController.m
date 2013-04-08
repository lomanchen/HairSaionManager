//
//  BaseLeftSideViewController.m
//  HairSaionManager
//
//  Created by chen loman on 12-12-11.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import "BaseRightSideViewController.h"
#import "BaseLeftSideViewController.h"
#import "MainSplitViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BaseLeftSideViewController ()
- (void)onAdd;
- (void)onCancel;


- (void)AnimationDidStop:(NSString *)paraAnimationId finished:(NSString *)paraFinished context:(void *)paraContext;

@end

@implementation BaseLeftSideViewController
@synthesize mainVc, currentRvc, rightSideShowed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadNavItem];
    [self reloadData];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData
{
    [self.policy setFilter];
    [self loadData];
}

- (void)dataDidLoad
{
    
}

- (void)pushRSViewController:(UIViewController*)rvc
{
    [self hideRSViewController:NO];
    self.rightSideShowed = YES;
    self.currentRvc = rvc;
    rvc.view.frame = CGRectMake(1024, 0, 1024-self.mainVc.splitPosition, 768);
    rvc.view.alpha = 0;
    CALayer* layer = rvc.view.layer;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, 0);
    layer.shadowOpacity = 1;
    layer.shadowRadius = 10;
    layer.shadowPath = [UIBezierPath bezierPathWithRect:rvc.view.bounds].CGPath;
    
    
    [self.mainVc.view addSubview:rvc.view];
    
    [UIView beginAnimations:@"pushRSViewController" context:nil];
    [UIView setAnimationDuration:0.5];
    rvc.view.frame = CGRectMake(self.mainVc.splitPosition, 0, SCREEN_W-self.mainVc.splitPosition, SCREEN_H);
    rvc.view.alpha = 1;
    [UIView commitAnimations];
    
//    [self.detailNav popViewControllerAnimated:NO];
//    [self performSelector:@selector(delayPush:) withObject:rvc afterDelay:0.1];
}

- (void)hideRSViewController:(BOOL)animated
{
    self.rightSideShowed = NO;
    if (nil != self.currentRvc)
    {
        if (animated)
        {
            [UIView beginAnimations:@"hideRSViewController" context:(__bridge void *)(self.currentRvc)];
            [UIView setAnimationDuration:0.5];
            self.currentRvc.view.frame = CGRectMake(1024, 0, 1024-self.mainVc.splitPosition, 768);
            self.currentRvc.view.alpha = 0;
            [UIView setAnimationDidStopSelector:@selector(AnimationDidStop:finished:context:)];
            [UIView setAnimationDelegate:self];
            [UIView commitAnimations];
        }
        else
        {
            [self.currentRvc.view removeFromSuperview];
            currentRvc = nil;
        }
    }
}

- (void)delayPush:(UIViewController*)rvc
{
    [self.detailNav pushViewController:rvc animated:YES];
}

- (void)AnimationDidStop:(NSString *)paraAnimationId finished:(NSString *)paraFinished context:(void *)paraContext
{
    UINavigationController* nav = ((__bridge UINavigationController*)paraContext);
    BaseRightSideViewController* rvc = nav.viewControllers[0];
    if (rvc.isAddMode)
    {
        //rvc.leftViewController
        [self addObjectCancel];
    }
    [rvc.view removeFromSuperview];
    paraContext = nil;
}

- (void)loadNavItem
{
    if (self.navigationItem)
    {
        UIBarButtonItem* itemAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAdd)];
        self.navigationItem.rightBarButtonItem = itemAdd;
    }
}

- (void)onAdd
{
    UIBarButtonItem* itemCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel)];
    self.navigationItem.rightBarButtonItem = itemCancel;
    [self addObject];
}


- (void)onCancel
{
    [self hideRSViewController:YES];
    UIBarButtonItem* itemAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAdd)];
    self.navigationItem.rightBarButtonItem = itemAdd;
    [self addObjectCancel];
}

- (void)addObject
{
    
}

- (void)addObjectCancel
{
    
}


- (void)onSave:(PsDataItem *)dataItem
{
    UIBarButtonItem* itemAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAdd)];
    self.navigationItem.rightBarButtonItem = itemAdd;
}


@end
