//
//  ViewController.m
//  KuaiPanOpenAPIDemo
//
//  Created by Jinbo He on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SyncMainViewController.h"
#import "MainSplitViewController.h"
#import "SyncPopUpViewController.h"


@implementation SyncMainViewController
@synthesize  processViewController, syncManager;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.syncManager = [[SyncOperationManager alloc]init];
    syncManager.deleage = self;
    self.title = @"发布数据";
    //设置返回按钮
    //self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    //[self doAuthorize:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.syncManager isAuthoried]) {
        NSLog(@"已经登录。。。。");
        //[self performSelectorInBackground:@selector(doSync) withObject:nil];
        
        //[self doSync:self];
    }
    else {
        NSLog(@"还没有登录。。。。");
        [self.syncManager doAuthorizeInViewController:self];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)loadNavItem
{
    
}

- (void)loadData
{
    
}

- (void)syncBegin:(SyncOperationManager*)manager
{
        self.processViewController = [[SyncProcessViewController alloc]initWithNibName:@"SyncProcessViewController" bundle:nil];
    
        SyncPopUpViewController* pvc = [[SyncPopUpViewController alloc]initWithContentViewController:self.processViewController];
        [pvc show:self.view andAnimated:YES];
        //[self presentModalViewController:pvc animated:YES];
        [self.processViewController start];
 
}
- (void)syncSuccess:(SyncOperationManager*)manager
{
    [self.processViewController finish];
}
- (void)syncFail:(SyncOperationManager*)manager
{
    [self.processViewController fail];
}
- (void)syncProgressUpdate:(SyncOperationManager*)manager andProgress:(CGFloat)progress
{
    [self.processViewController setProgress:progress];
}

- (void)doSync:(id)sender
{
    if ([self.syncManager isAuthoried])
    {
    [self.syncManager doSync:self];
    }
    else
    {
        [self.syncManager doAuthorizeInViewController:self];
    }
}


@end
