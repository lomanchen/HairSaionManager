//
//  SyncProcessViewController.m
//  HairSaionManager
//
//  Created by chen loman on 13-1-10.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import "SyncProcessViewController.h"

@interface SyncProcessViewController ()

@end

@implementation SyncProcessViewController

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
    [self start];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)start
{
    [_activity startAnimating];
    _progress.progress = 0.0f;
    _state.text = @"正在发布数据，请耐心等待...";
    _state.textColor = [UIColor blackColor];

}

- (void)finish
{
    [_activity stopAnimating];
    _progress.progress = 1.0f;
    _state.text = @"发布数据成功！";
    _state.textColor = [UIColor greenColor];
}

- (void)fail
{
    [_activity stopAnimating];
    _progress.progress = 1.0f;
    _state.text = @"发布数据失败！";
    _state.textColor = [UIColor redColor];
}


- (void)setProgress:(CGFloat)progress
{
    _progress.progress = progress;
}

- (CGFloat)progress
{
    return _progress.progress;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
