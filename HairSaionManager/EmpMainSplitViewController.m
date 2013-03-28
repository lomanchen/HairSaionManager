//
//  EmpMainSplitViewController.m
//  HairSaionManager
//
//  Created by chen loman on 13-3-7.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import "EmpMainSplitViewController.h"
#import "DefalueRSViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DataAdapter.h"
#import "BranchLSViewController.h"
#import "BranchPolicy.h"
#import "DiscountCardLSViewController.h"
#import "DiscountCardPolicy.h"
@interface EmpMainSplitViewController ()

@end

@implementation EmpMainSplitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self loadTabBar];
        
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self loadTabBar];
        
    }
    return self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    //指向文件目录
    NSString *documentsDirectory= [[DataAdapter shareInstance]path];
    
    //创建一个目录
    [fileMgr createDirectoryAtPath: [NSString stringWithFormat:@"%@/IMG", documentsDirectory] attributes:nil];
    [fileMgr createDirectoryAtPath: [NSString stringWithFormat:@"%@/IMG/Product", documentsDirectory] attributes:nil];
    //self.splitWidth = 1;
    [self setSplitPosition:SPLIT_POSITION_MID];
    [self setMasterBeforeDetail:YES];}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    CALayer* layer = self.detailViewController.view.layer;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, 0);
    layer.shadowOpacity = 1;
    layer.shadowRadius = 10;
    layer.shadowPath = [UIBezierPath bezierPathWithRect:self.detailViewController.view.bounds].CGPath;
    
    layer = self.masterViewController.view.layer;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, 0);
    layer.shadowOpacity = 1;
    layer.shadowRadius = 10;
    layer.shadowPath = [UIBezierPath bezierPathWithRect:self.masterViewController.view.bounds].CGPath;
}

- (void)loadTabBar
{
    
    //right side
    DefalueRSViewController* rvc = [[DefalueRSViewController alloc]initWithNibName:@"DefalueRSViewController" bundle:nil];
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:rvc];
    self.detailViewController = nav;
    NGTabBarController* tabbarController = [[NGTabBarController alloc]initWithDelegate:self];
    tabbarController.tabBarPosition = NGTabBarPositionLeft;
    //    tabbarController.tabBar.backgroundColor = [UIColor yellowColor];
    self.masterViewController = tabbarController;
    NSMutableArray* tabbarVCs = [NSMutableArray array];
    DataAdapter* da = [DataAdapter shareInstance];

    BranchLSViewController* vc1 = [[BranchLSViewController alloc]init];
    UINavigationController* nav1 = [[UINavigationController alloc]initWithRootViewController:vc1];
    nav1.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"分店介绍" image:nil];
    vc1.detailNav = nav1;
    vc1.mainVc = self;
    vc1.policy = [[BranchPolicy alloc]initWithSubType:nil];

    [tabbarVCs addObject:nav1];
    
    DiscountCardLSViewController* vc2 = [[DiscountCardLSViewController alloc]init];
    UINavigationController* nav2 = [[UINavigationController alloc]initWithRootViewController:vc2];
    nav2.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"优惠政策" image:nil];
    vc2.detailNav = nav2;
    vc2.mainVc = self;
    vc2.policy = [[DiscountCardPolicy alloc]initWithSubType:nil];
    
    [tabbarVCs addObject:nav2];

    
    
    
    //    //类型编辑
    //    ProductLSViewController* typeVc = [[ProductLSViewController alloc]init];
    //    UINavigationController* navType = [[UINavigationController alloc]initWithRootViewController:typeVc];
    //    navType.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"类型管理" image:nil];
    //    typeVc.detailNav = nav;
    //    typeVc.mainVc = self;
    //    typeVc.policy = [[TypePolicy alloc]initWithSubType:nil];
    //    [tabbarVCs addObject:typeVc];
    
    /*
     //发布
     SyncMainViewController* syncVc = [[SyncMainViewController alloc]initWithNibName:@"SyncMainViewController" bundle:nil];
     UINavigationController* syncNav = [[UINavigationController alloc]initWithRootViewController:syncVc];
     syncNav.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"发布" image:nil];
     syncVc.detailNav = nav;
     syncVc.mainVc = self;
     
     [tabbarVCs addObject:syncNav];
     */
    tabbarController.viewControllers = [NSArray arrayWithArray:tabbarVCs];
    
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}


- (float)splitViewController:(MGSplitViewController *)svc constrainSplitPosition:(float)proposedPosition splitViewSize:(CGSize)viewSize
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
	return proposedPosition;
}

- (void)splitViewController:(MGSplitViewController*)svc
		  popoverController:(UIPopoverController*)pc
  willPresentViewController:(UIViewController *)aViewController
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)splitViewController:(MGSplitViewController*)svc willChangeSplitOrientationToVertical:(BOOL)isVertical
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)splitViewController:(MGSplitViewController*)svc willMoveSplitToPosition:(float)position
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
}

/** Asks the delegate for the size of the given item */
- (CGSize)tabBarController:(NGTabBarController *)tabBarController
sizeOfItemForViewController:(UIViewController *)viewController
                   atIndex:(NSUInteger)index
                  position:(NGTabBarPosition)position
{
    return CGSizeMake(50, 100);
}

/** Asks the delegate whether the specified view controller should be made active. */
- (BOOL)tabBarController:(NGTabBarController *)tabBarController
shouldSelectViewController:(UIViewController *)viewController
                 atIndex:(NSUInteger)index
{
    return YES;
}

/** Tells the delegate that the user selected an item in the tab bar. */
- (void)tabBarController:(NGTabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
                 atIndex:(NSUInteger)index
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
}



@end
