//
//  ProductTypePickerViewController.m
//  HairSaionManager
//
//  Created by chen loman on 12-12-12.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import "ProductTypePickerViewController.h"
#import "LifeBarDataProvider.h"
@interface ProductTypePickerViewController ()
@property (nonatomic, strong)NSArray* productTypesL1;
@property (nonatomic, strong)NSMutableArray* productTypes;
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
    productTypesL1 = [[LifeBarDataProvider shareInstance]productTypesWithParentId:LB_PRODUCT_TYPE_ROOT];
	// Do any additional setup after loading the view.
}
- (void)setData:(PsDataItem *)item
{
    [super setData:item];
    ProductShowingDetail* psd = item;
    if (psd.Id == 0)
    {
        psd.types = [NSMutableArray array];
    }
    else
    {
        psd.types = [[LifeBarDataProvider shareInstance]getProductTypesWithProductId:((ProductShowingDetail*)self.item).Id];
    }
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
    return [[[LifeBarDataProvider shareInstance]productTypesWithParentId:((ProductTypeItem*)productTypesL1[section]).typeId] count] + 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (UITableViewCellAccessoryCheckmark == cell.accessoryType)
    {
        NSInteger typeId = [self productTypeAtIndexPath:indexPath andLevel:nil];
        //if ([[LifeBarDataProvider shareInstance]dropType:typeId fromProduct:((ProductShowingDetail*)self.item).Id])
        {
            [self productDropType:typeId];
        }
    }
    else
    {
        NSInteger typeId = [self productTypeAtIndexPath:indexPath andLevel:nil];
       // if ([[LifeBarDataProvider shareInstance]addProduct:((ProductShowingDetail*)self.item).Id toType:typeId])
        {
            [self productAddType:typeId];
        }
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
    
    if ([self productIsType:[self productTypeAtIndexPath:indexPath andLevel:nil]])
    {
        cell.accessoryType =  UITableViewCellAccessoryCheckmark;
    }
    else
        
    {
        cell.accessoryType =  UITableViewCellAccessoryNone;
    }
    if (indexPath.row == 0)
    {
        cell.textLabel.text = ((ProductTypeItem*)productTypesL1[indexPath.section]).name;
        cell.indentationLevel = 0;
        cell.indentationWidth = 0;

    }
    else{
        int level = 0;
        cell.textLabel.text = [[LifeBarDataProvider shareInstance]getProductTypeById:[self productTypeAtIndexPath:indexPath andLevel:&level]].name;
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



- (NSInteger)productTypeAtIndexPath:(NSIndexPath*)path andLevel:(int*)level
{
    if (path.row == 0)
    {
        if (level)
        {
            *level = 0;
        }
        return ((ProductTypeItem*)self.productTypesL1[path.section]).typeId;
    }
    else
    {
        if (level)
        {
            *level = 1;
        }
        return ((ProductTypeItem*)[[LifeBarDataProvider shareInstance]productTypesWithParentId:((ProductTypeItem*)self.productTypesL1[path.section]).typeId][path.row - 1]).typeId;
        
    }
}

- (BOOL)productIsType:(NSInteger)typeId
{
    ProductShowingDetail* psd = self.item;
    if (psd.types && [psd.types count] > 0)
    {
        for (NSNumber* type in psd.types)
        {
            if ([type integerValue] == typeId)
            {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)productAddType:(NSInteger)typeId
{
    ProductShowingDetail* psd = self.item;
    if (psd.types)
    {
        ProductTypeItem* type = [[LifeBarDataProvider shareInstance]getProductTypeById:typeId];
        if (type.parent != LB_PRODUCT_TYPE_ROOT)
        {
           [self productAddType:type.parent];
        }
        [psd.types addObject:[NSNumber numberWithInteger:typeId]];
        return YES;
    }
    return NO;
}

- (BOOL)productDropType:(NSInteger)typeId
{
    ProductShowingDetail* psd = self.item;
    if (psd.types && [psd.types count] > 0)
    {
        for (NSNumber* type in psd.types)
        {
            if ([type integerValue] == typeId)
            {
                NSArray* array = [[LifeBarDataProvider shareInstance]productTypesWithParentId:typeId];
                for (ProductTypeItem* item in array)
                {
                    [self productDropType:item.typeId];
                }
                [psd.types removeObject:type];
                return YES;
            }
        }
    }
    return NO;
}



@end
