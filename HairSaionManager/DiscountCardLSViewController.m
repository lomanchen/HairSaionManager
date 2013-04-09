//
//  DiscountCardLSViewController.m
//  HairSaionManager
//
//  Created by chen loman on 13-3-8.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import "DiscountCardLSViewController.h"
#import "ProductRSViewController.h"
#import "ProductCell.h"
#import "DiscountCardItem.h"
#import "DiscountCardRSViewController.h"
#import "EmpMainSplitViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LifeBarDataProvider.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DiscountCardLSViewController ()

@end

@implementation DiscountCardLSViewController


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
    DiscountCardItem* item = [self.items objectAtIndex:indexPath.row];
    NSString* imageFileName = [item.imgLinkDic objectForKey:[NSNumber numberWithInteger:LB_DISCOUNTCARD_PIC_TYPE_DEFAULT]];
    if (imageFileName && ![imageFileName isEqualToString:@""])
    {
        NSString* tmpFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:imageFileName];
        if ([[LCFileManager shareInstance]checkSourPath:tmpFilePath error:nil])
        {
            cell.imageView.image = [UIImage imageWithContentsOfFile:tmpFilePath];
        }
        else
        {
            NSString* url = [[[LifeBarDataProvider shareInstance]imgPathForOrg] stringByAppendingString:imageFileName];
            [cell.imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        }
    }    //cell.imageView.frame = CGRectMake(0, 0, 100, 100);
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.detail;
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
    
    [MBProgressHUD showAnimated:YES whileExecutingBlock:^(void)
     {
         LifeBarDataProvider* lbp = [LifeBarDataProvider shareInstance];
         @synchronized(lbp)
         {
             LifeBarDataProvider* lbp = [LifeBarDataProvider shareInstance];
             self.items = [lbp getDiscountCardByOrgId:[lbp getCurrentOrgInfo].Id];
             for (DiscountCardItem* item in self.items)
             {
                 [lbp loadPicLinksForItem:item withRefType:LB_PIC_TYPE_DISCOUNTCARD];
             }
         }
     } completionBlock:^(void)
     {
         [self.tableView reloadData];
     } withTitle:@"Loading" inView:self.view];
}



- (void)removeObjectAtIndex:(NSInteger)index
{
    DiscountCardItem* item = [self.items objectAtIndex:index];
    if ([[LifeBarDataProvider shareInstance]deleteDiscountCardById:item.Id])
    {
        [super removeObjectAtIndex:index];
    }
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

- (void)onBarMain:(id)sender
{
    UINavigationController* nav = self.mainVc.navigationController;
    [nav popViewControllerAnimated:YES];
    
}


- (void)addObject
{
    [super addObject];
    DiscountCardItem* item = [[DiscountCardItem alloc]init];
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
//    BaseRightSideViewController* rvc = ((UINavigationController*)self.currentRvc).viewControllers[0];
//    DiscountCardItem* item = rvc.item;
//    [[DataAdapter shareInstance]deleteDiscountCardByCardId:item.key];
}

@end
