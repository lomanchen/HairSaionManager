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
#import "SyncProgressViewController.h"
#import "SyncPopUpViewController.h"
#import "DataAdapter.h"

@interface HomeViewController ()
@property (nonatomic, strong)IBOutlet UIButton* btnLogin;
@property (nonatomic, strong)IBOutlet UIButton* btnTypeMgr;

@property (nonatomic, assign) BOOL isAuthing;
@property (nonatomic, assign) BOOL isSynced;

- (IBAction)onSync:(id)sender;
- (IBAction)onPub:(id)sender;

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
    self.isSynced = NO;
    self.isAuthing = NO;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if (self.isAuthing)
    {
        SyncOperationManager* syncManager = [SyncOperationManager shareInstance];
        
        //    SyncMainViewController* vc = [[SyncMainViewController alloc]initWithNibName:@"SyncMainViewController" bundle:nil];
        
        //    [self.psViewController.rootViewController.view addSubview:vc.view];
        //    vc.view.frame =  CGRectMake(0, 0, 800, 600);
        if ([syncManager isAuthoried])
        {
            SyncProgressViewController* vc = [[SyncProgressViewController alloc]initWithNibName:@"SyncProgressViewController" bundle:nil];
            syncManager.processerDelege = vc;
            syncManager.resultDelege = self;
            //UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:vc];
            //nav.view.frame = CGRectMake(0, 0, 800, 600);
            //nav.navigationBarHidden = YES;
            //PopUpViewController* pop = [[PopUpViewController alloc]initWithNavContentViewController:nav];
            SyncPopUpViewController* pop = [[SyncPopUpViewController alloc]initWithContentViewController:vc];
            pop.popUpDeleage = self;
            [pop show:self.view andAnimated:YES];
            if (self.isSynced)
            {
                [syncManager doSync:nil];
            }
            else
            {
                [syncManager doUpdate:nil];
            }
            [pop show:self.view andAnimated:YES];
        }
    }
}

- (void)syncSuccess:(SyncOperationManager *)manager
{
    self.isAuthing = NO;
    if (!self.isSynced)
    {
        [[DataAdapter shareInstance]resetDatabaseWithFile:[[[DataAdapter shareInstance]dbPath] stringByAppendingPathComponent:LOCAL_DB_FILE_NAME]];
        self.isSynced = NO;
    }
}



- (void)onPub:(id)sender
{
    SyncOperationManager* syncManager = [SyncOperationManager shareInstance];
    self.isSynced = YES;
    //    SyncMainViewController* vc = [[SyncMainViewController alloc]initWithNibName:@"SyncMainViewController" bundle:nil];
    
    //    [self.psViewController.rootViewController.view addSubview:vc.view];
    //    vc.view.frame =  CGRectMake(0, 0, 800, 600);
    if ([syncManager isAuthoried])
    {
        SyncProgressViewController* vc = [[SyncProgressViewController alloc]initWithNibName:@"SyncProgressViewController" bundle:nil];
        syncManager.processerDelege = vc;
        syncManager.resultDelege = self;
        //UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:vc];
        //nav.view.frame = CGRectMake(0, 0, 800, 600);
        //nav.navigationBarHidden = YES;
        //PopUpViewController* pop = [[PopUpViewController alloc]initWithNavContentViewController:nav];
        SyncPopUpViewController* pop = [[SyncPopUpViewController alloc]initWithContentViewController:vc];
        pop.popUpDeleage = self;
        [pop show:self.view andAnimated:YES];
        [syncManager doSync:sender];
        [pop show:self.view andAnimated:YES];
    }
    else
    {
        self.isAuthing = YES;
        [syncManager doAuthorizeInViewController:self];
        
    }
    //[self viewDidHide:nil];
    //[self syncSuccess:nil];
    
}

- (void)onSync:(id)sender
{
    SyncOperationManager* syncManager = [SyncOperationManager shareInstance];
    self.isSynced = NO;
    //    SyncMainViewController* vc = [[SyncMainViewController alloc]initWithNibName:@"SyncMainViewController" bundle:nil];
    
    //    [self.psViewController.rootViewController.view addSubview:vc.view];
    //    vc.view.frame =  CGRectMake(0, 0, 800, 600);
    if ([syncManager isAuthoried])
    {
        SyncProgressViewController* vc = [[SyncProgressViewController alloc]initWithNibName:@"SyncProgressViewController" bundle:nil];
        syncManager.processerDelege = vc;
        syncManager.resultDelege = self;
        //UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:vc];
        //nav.view.frame = CGRectMake(0, 0, 800, 600);
        //nav.navigationBarHidden = YES;
        //PopUpViewController* pop = [[PopUpViewController alloc]initWithNavContentViewController:nav];
        SyncPopUpViewController* pop = [[SyncPopUpViewController alloc]initWithContentViewController:vc];
        pop.popUpDeleage = self;
        [pop show:self.view andAnimated:YES];
        [syncManager doUpdate:sender];
        [pop show:self.view andAnimated:YES];
    }
    else
    {
        self.isAuthing = YES;
        [syncManager doAuthorizeInViewController:self];
        
    }
    //[self viewDidHide:nil];
    //[self syncSuccess:nil];
    
}
@end
