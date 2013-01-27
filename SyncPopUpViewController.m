//
//  SyncPopUpViewController.m
//  HairSaionManager
//
//  Created by chen loman on 13-1-10.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import "SyncPopUpViewController.h"
#import "PopUpSubViewController.h"
#import "SyncProcessViewController.h"

@interface SyncPopUpViewController ()

@end

@implementation SyncPopUpViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)setVisiable:(BOOL)flag inView:(UIView *)inView
//{
//    if (flag)
//    {
//        [self.view setAlpha:1];
//        CGRect rect = inView.bounds;
//        self.view.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
//        self.view.bounds = inView.bounds;
//        //        CGFloat subX = rect.size.width/2-self.subViewController.view.bounds.size.width/2;
//        //        CGFloat subY = rect.size.height/2-self.subViewController.view.bounds.size.height/2;
//        //        self.subViewController.view.frame = CGRectMake(subX, subY, self.subViewController.view.bounds.size.width, self.subViewController.view.bounds.size.height);
//    }
//    else
//    {
//        self.view.frame = CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
//        [self.view setAlpha:0];
//    }
//    
//        CGRect rect = self.subViewController.view.frame;
//        rect = self.subViewController.view.frame;
//    
//        rect.origin.x = 70;
//       self.subViewController.view.frame = rect;
//    
//    
//}

- (void)hide:(BOOL)animated
{
    SyncProcessViewController* subVc = self.subViewController;
    if ([subVc progress] >= 1.0f)
    {
        [super hide:animated];
    }
    else
    {
        //do nothing
    }
}


@end
