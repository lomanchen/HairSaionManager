//
//  PopUpSubViewController.m
//  HairSaionManager
//
//  Created by chen loman on 12-12-20.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import "PopUpSubViewController.h"
#import "PopUpViewController.h"

@interface PopUpSubViewController ()

@end

@implementation PopUpSubViewController

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


- (void)onCancel:(id)sender
{
    [self.popUpController hide:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.center = self.popUpController.view.center;
}

@end
