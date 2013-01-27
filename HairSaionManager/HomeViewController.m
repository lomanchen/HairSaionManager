//
//  HomeViewController.m
//  HairSaionManager
//
//  Created by chen loman on 13-1-17.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import "HomeViewController.h"
#import "SyncOperationManager.h"
#import "TypeEditViewController.h"

@interface HomeViewController ()
@property (nonatomic, strong)IBOutlet UIButton* btnLogin;
@property (nonatomic, strong)IBOutlet UIButton* btnTypeMgr;


- (IBAction)onLogin:(id)sender;
- (IBAction)onTypeMgr:(id)sender;

@end

@implementation HomeViewController

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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    SyncOperationManager* sync = [SyncOperationManager shareInstance];
    if ([sync isAuthoried])
    {
        [self.btnLogin setTitle:@"已登陆" forState:UIControlStateNormal];
        [self.btnLogin setEnabled:NO];
    }
    else
    {
        [self.btnLogin setTitle:@"登陆" forState:UIControlStateNormal];
        [self.btnLogin setEnabled:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];

}

- (void)onLogin:(id)sender
{
    SyncOperationManager* sync = [SyncOperationManager shareInstance];
    if ([sync isAuthoried])
    {
        //do nothing
    }
    else
    {
        [sync doAuthorizeInViewController:self];
    }
}

- (void)onTypeMgr:(id)sender
{
    TypeEditViewController* vc = [[TypeEditViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
