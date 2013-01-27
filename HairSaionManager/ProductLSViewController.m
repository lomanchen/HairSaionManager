//
//  BaseLeftSideViewController.m
//  HairSaionManager
//
//  Created by chen loman on 12-12-11.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import "ProductLSViewController.h"
#import "ProductShowingDetail.h"
#import "ProductPolicy.h"
#import "ProductRSViewController.h"
#import "ProductCell.h"
#import "MainSplitViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ProductLSViewController ()
@end

@implementation ProductLSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
    ProductShowingDetail* item = [self.items objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageWithContentsOfFile:item.defaultImgLink];
    //cell.imageView.frame = CGRectMake(0, 0, 100, 100);
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.productDetail;
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
    int count = [da count];
    self.items = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i ++)
    {
        ProductShowingDetail* item = [ProductShowingDetail  initByIndex:i];
        [self.items addObject:item];
    }
    
}



- (void)removeObjectAtIndex:(NSInteger)index
{
    ProductShowingDetail* psd = [self.items objectAtIndex:index];
    [[DataAdapter shareInstance]deletebyProductId:psd.productId];
    [super removeObjectAtIndex:index];
}

- (void)loadNavItem
{
    [super loadNavItem];
    if (self.navigationItem)
    {
        NSArray* array = [[DataAdapter shareInstance]productTypeForParent:self.policy.subType];
        int count = -1;
        NSMutableArray* leftItems = [NSMutableArray arrayWithCapacity:[array count]];
        UIBarButtonItem* itemMain = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStylePlain target:self action:@selector(onBarMain:)];
        itemMain.tag = -2;
        [leftItems addObject:itemMain];
        UIBarButtonItem* itemAll = [[UIBarButtonItem alloc] initWithTitle:@"全部" style:UIBarButtonItemStylePlain target:self action:@selector(onBarItem:)];
        itemAll.tag = count++;
        [leftItems addObject:itemAll];
        for (ProductType* type in array)
        {
            UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:type.typeName style:UIBarButtonItemStylePlain target:self action:@selector(onBarItem:)];
            item.tag = count++;
            [leftItems addObject:item];
        }
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithArray:leftItems];
    }
}

- (void)onBarItem:(id)sender
{
    NSArray* array = [[DataAdapter shareInstance]productTypeForParent:self.policy.subType];
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
    NSString* productId = [[DataAdapter shareInstance]createNewProduct];
    ProductShowingDetail* item = [ProductShowingDetail initByProductBase:[[DataAdapter shareInstance]productBaseByProduceId:productId]];
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
    ProductShowingDetail* item = rvc.item;
    [[DataAdapter shareInstance]deletebyProductId:item.productId];
}

@end
