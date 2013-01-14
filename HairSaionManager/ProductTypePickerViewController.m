//
//  ProductTypePickerViewController.m
//  HairSaionManager
//
//  Created by chen loman on 12-12-12.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import "ProductTypePickerViewController.h"
#import "DataAdapter.h"
#import "ProductShowingDetail.h"
#import "ProductBase.h"
@interface ProductTypePickerViewController ()
@property (nonatomic, strong)NSArray* productTypesL1;
@end

@implementation ProductTypePickerViewController
@synthesize productTypesL1;
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
    productTypesL1 = [[DataAdapter shareInstance]productTypeForParent:PRODUCT_TYPE_ROOT];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [productTypesL1 count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[DataAdapter shareInstance]productTypeForParent:((ProductType*)productTypesL1[section]).productType] count] + 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (UITableViewCellAccessoryCheckmark == cell.accessoryType)
    {
        ProductType* type = [self productTypeAtIndexPath:indexPath andLevel:nil];
        [[[DataAdapter shareInstance]productBaseByProduceId:((ProductShowingDetail*)self.item).productId] dropProductType:type];
    }
    else
    {
        ProductType* type = [self productTypeAtIndexPath:indexPath andLevel:nil];
        [[[DataAdapter shareInstance]productBaseByProduceId:((ProductShowingDetail*)self.item).productId] appendProductType:type];
    }
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellReuseIdentifier = @"productTypeCell";
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (nil == cell)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
        if (nil == cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
        }
    }
    
    if ([[[DataAdapter shareInstance]productBaseByProduceId:((ProductShowingDetail*)self.item).productId] isType:[self productTypeAtIndexPath:indexPath andLevel:nil]])
    {
        cell.accessoryType =  UITableViewCellAccessoryCheckmark;
    }
    else
        
    {
        cell.accessoryType =  UITableViewCellAccessoryNone;
    }
    if (indexPath.row == 0)
    {
        cell.textLabel.text = ((ProductType*)productTypesL1[indexPath.section]).typeName;
        cell.indentationLevel = 0;
        cell.indentationWidth = 0;

    }
    else{
        int level = 0;
        cell.textLabel.text = [self productTypeAtIndexPath:indexPath andLevel:&level].typeName;
        cell.indentationLevel = level;
        cell.indentationWidth = level*20;
    }
    return cell;
}

//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//
//    int lever = 0;
//    if ([[[DataAdapter shareInstance]productBaseByProduceId:((ProductShowingDetail*)self.item).productId] isType:[self productTypeAtIndexPath:indexPath andLevel:&lever]])
//    {
//        return UITableViewCellAccessoryCheckmark;
//    }
//    else
//        
//    {
//        return UITableViewCellAccessoryNone;
//    }
////    }
////    else{
////        return UITableViewCellAccessoryNone;
////    }
//}


- (ProductType*)productTypeAtIndexPath:(NSIndexPath*)path andLevel:(int*)level
{
    
    ProductType* rootType = self.productTypesL1[path.section];
    if (path.row == 0)
    {
        if (level)
        {
            *level = 0;
        }
        return rootType;
    }
    
    DataAdapter* da = [DataAdapter shareInstance];
    NSArray* types = [da productTypeForParent:rootType.productType];
    if (level)
    {
        *level = 1;
    }
    return types[path.row - 1];
}



@end
