//
//  BranchLSViewController.m
//  HairSaionManager
//
//  Created by chen loman on 13-3-7.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import "BranchLSViewController.h"
#import "ProductRSViewController.h"
#import "ProductCell.h"
#import "OrganizationItem.h"
#import "BranchLSViewController.h"
#import "EmpMainSplitViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LifeBarDataProvider.h"


@interface BranchLSViewController ()

@end

@implementation BranchLSViewController

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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProductCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    OrganizationItem* item = [self.items objectAtIndex:indexPath.row];
    cell.imageView.image = [item defaultImgLink];
    //cell.imageView.frame = CGRectMake(0, 0, 100, 100);
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = [item address];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}






/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


- (void)loadData
{
    DataAdapter * da = [DataAdapter shareInstance];
    int count = [da.organizations count];
    self.items = [NSMutableArray array];
    for (int i = 0; i < count; i ++)
    {
        OrganizationItem* item = [[OrganizationItem alloc]initWithObject:(da.organizations)[i]];
        [self.items addObject:item];
    }
    
}



- (void)removeObjectAtIndex:(NSInteger)index
{
    OrganizationItem* item = [self.items objectAtIndex:index];
    [[DataAdapter shareInstance]deleteOrgByOrgId:item.key];
    [super removeObjectAtIndex:index];
}

- (void)loadNavItem
{
    [super loadNavItem];
    if (self.navigationItem)
    {
        NSMutableArray* leftItems = [NSMutableArray array];
        UIBarButtonItem* itemMain = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStylePlain target:self action:@selector(onBarMain:)];
        itemMain.tag = -2;
        [leftItems addObject:itemMain];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithArray:leftItems];
    }
}

- (void)onBarItem:(id)sender
{
    NSArray* array = [[LifeBarDataProvider shareInstance]productTypesWithParentId:self.policy.subType];
    int tag = ((UIBarButtonItem*)sender).tag;
    if (tag == -1)
    {
        [self reloadData];
    }
    else
    {
        ProductType* type = [array objectAtIndex:tag];
        [[DataAdapter shareInstance]setFilter:type];
        [self loadData];
        [self.tableView reloadData];
    }
}

- (void)onBarMain:(id)sender
{
    UINavigationController* nav = self.mainVc.navigationController;
    [nav popViewControllerAnimated:YES];
    
}


- (void)addObject
{
    [super addObject];
    NSString* orgId = [[DataAdapter shareInstance]createNewOrg];
    OrganizationItem* item = [[OrganizationItem alloc]initWithObject:[[DataAdapter shareInstance]orgByOrgId:orgId]];
    UINavigationController* vc = (UINavigationController*)[self.policy createRightVC];
    BaseRightSideViewController* rvc = vc.viewControllers[0];
    rvc.rootSplitViewController = self.mainVc;
    rvc.leftViewController = self;
    [rvc setData:item];
    rvc.isAddMode = YES;
    [self pushRSViewController:vc];
}

- (void)addObjectCancel
{
    BaseRightSideViewController* rvc = ((UINavigationController*)self.currentRvc).viewControllers[0];
    OrganizationItem* item = rvc.item;
    [[DataAdapter shareInstance]deleteOrgByOrgId:item.key];
}

@end
