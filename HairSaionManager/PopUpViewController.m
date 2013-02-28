//
//  PopUpViewController.m
//  HairSaionManager
//
//  Created by chen loman on 12-12-20.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import "PopUpViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PopUpSubViewController.h"

@interface PopUpViewController ()
- (void)setVisiable:(BOOL)flag inView:(UIView *)inView;
@end

@implementation PopUpViewController
@synthesize popUpDeleage, subViewController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithContentViewController:(PopUpSubViewController*)contentViewController;
{
    self = [self initWithNibName:@"PopUpViewController" bundle:nil];
    if (self)
    {
        [self setContentViewController:contentViewController];
    }
    return self;
}
- (id)initWithNavContentViewController:(UINavigationController*)nav;
{
    self = [self initWithNibName:@"PopUpViewController" bundle:nil];
    if (self)
    {
        [self setContentNavViewController:nav];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setVisiable:(BOOL)flag inView:(UIView *)inView
{
    if (flag)
    {
        [self.view setAlpha:1];
        CGRect rect = inView.bounds;
        self.view.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        self.view.bounds = inView.bounds;
//        CGFloat subX = rect.size.width/2-self.subViewController.view.bounds.size.width/2;
//        CGFloat subY = rect.size.height/2-self.subViewController.view.bounds.size.height/2;
//        self.subViewController.view.frame = CGRectMake(subX, subY, self.subViewController.view.bounds.size.width, self.subViewController.view.bounds.size.height);
    }
    else
    {
        self.view.frame = CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
        [self.view setAlpha:0];
    }
    
    //[self.view bringSubviewToFront:self.subViewController.view];
//    CGRect rect = self.subViewController.view.frame;
//    rect = self.subViewController.view.frame;
//
//    //rect.origin.x = 10;
//    self.subViewController.view.frame = rect;
    
    
}

- (void)show:(UIView *)inView andAnimated:(BOOL)animated
{
    [inView addSubview:self.view];
    [inView bringSubviewToFront:self.view];
    [self setVisiable:NO inView:inView];
    if (nil == self.popUpDeleage || ![self.popUpDeleage respondsToSelector:@selector(viewWillPopUpWithSubViewController:animated:)] || [self.popUpDeleage viewWillPopUpWithSubViewController:self.subViewController animated:animated])
    {
        if (!animated)
        {
            [self setVisiable:YES inView:inView];
        }
        else
        {
//    [self.view bringSubviewToFront:self.statementViewController.view];
            [UIView beginAnimations:@"showPopUp" context:(__bridge void *)(self)];
            [UIView setAnimationDuration:0.3f];
            [UIView setAnimationDelegate:self];
            [self setVisiable:YES inView:inView];
            [UIView setAnimationDidStopSelector:@selector(viewDidShow:finished:context:)];

            [UIView commitAnimations];
        }
    }

}
- (void)viewDidShow:(NSString *)paraAnimationId finished:(NSString *)paraFinished context:(void *)paraContext
{
    if (nil != self.popUpDeleage && [self.popUpDeleage respondsToSelector:@selector(viewDidShow:)])
    {
        [self.popUpDeleage viewDidShow:self];
    }
}
- (void)viewDidHide:(NSString *)paraAnimationId finished:(NSString *)paraFinished context:(void *)paraContext
{
    [self.view removeFromSuperview];
    if (nil != self.popUpDeleage && [self.popUpDeleage respondsToSelector:@selector(viewDidHide:)])
    {
        [self.popUpDeleage viewDidHide:self];
    }
}



- (void)hide:(BOOL)animated
{
    if (nil == self.popUpDeleage || ![self.popUpDeleage respondsToSelector:@selector(viewWillHideWithSubViewController:animated:)] || [self.popUpDeleage viewWillHideWithSubViewController:self.subViewController animated:animated])
    {
        if (!animated)
        {
            [self setVisiable:NO inView:nil];
        }
        else
        {
            [UIView beginAnimations:@"hidePopUp" context:(__bridge void *)(self)];
            [UIView setAnimationDuration:0.3f];
            [UIView setAnimationDelegate:self];
            [self setVisiable:NO inView:nil];
            [UIView setAnimationDidStopSelector:@selector(viewDidHide:finished:context:)];

            [UIView commitAnimations];
        }
    }
}

- (void)setContentViewController:(PopUpSubViewController *)contentViewController
{
    self.subViewController = contentViewController;
    self.subViewController.popUpController = self;
    [self.view addSubview:contentViewController.view];
    self.subViewController.view.center = self.view.center;
}


- (void)setContentNavViewController:(UINavigationController *)nav
{
    self.subViewController = nav.viewControllers[0];
    self.subViewController.popUpController = self;
    [self.view addSubview:nav.view];
    nav.view.center = self.view.center;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end
