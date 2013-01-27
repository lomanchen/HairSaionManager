//
//  ProductTypeSelectorViewController.m
//  HairSaionManager
//
//  Created by chen loman on 13-1-25.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import "ProductTypeSelectorViewController.h"
#import "DataAdapter.h"
#import "ProductShowingDetail.h"
#import "ProductTypeItem.h"

@interface ProductTypeSelectorViewController ()
{
    id _target;
    SEL _action;
}
@property (nonatomic, strong)NSArray* productTypesL1;
@property (nonatomic, strong)NSString* productTypeId;

@end

@implementation ProductTypeSelectorViewController
@synthesize productTypesL1;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (id)initWithItem:(ProductTypeItem *)item
//{
//    self = [super initWithNibName:@"ProductTypeSelectorViewController" bundle:nil];
//    if (self)
//    {
//        _item = item;
//    }
//    return self;
//}

- (id)initWithProductTypeId:(NSString *)productTypeId target:(id)target action:(SEL)action
{
    //    _item = [[ProductTypeItem alloc]initWithObject:[[DataAdapter shareInstance]productTypeById:productTypeId]];
    self = [super initWithNibName:@"ProductTypeSelectorViewController" bundle:nil];
    if (self)
    {
        
        _productTypeId = productTypeId;
        _target = target;
        _action = action;
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    productTypesL1 = [[DataAdapter shareInstance]productTypeForParent:PRODUCT_TYPE_ROOT];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [productTypesL1 count]+1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    self.productTypeId = [self productTypeAtIndexPath:indexPath andLevel:nil];
//    if (UITableViewCellAccessoryCheckmark == cell.accessoryType)
//    {
//    }
//    else
//    {
//        ProductType* type = [self productTypeAtIndexPath:indexPath andLevel:nil];
//        [[[DataAdapter shareInstance]productBaseByProduceId:((ProductShowingDetail*)self.item).productId] appendProductType:type];
//    }
//    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView reloadData];
    
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
    
    if ([_productTypeId isEqualToString:[self productTypeAtIndexPath:indexPath andLevel:nil]])
    {
        cell.accessoryType =  UITableViewCellAccessoryCheckmark;
    }
    else
        
    {
        cell.accessoryType =  UITableViewCellAccessoryNone;
    }
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"根类型";
        cell.indentationLevel = 0;
        cell.indentationWidth = 0;
        
    }
    else{
        int level = 0;
        cell.textLabel.text = [[DataAdapter shareInstance]productTypeById:[self productTypeAtIndexPath:indexPath andLevel:&level]].typeName;
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


- (NSString*)productTypeAtIndexPath:(NSIndexPath*)path andLevel:(int*)level
{
    
//    ProductType* rootType = self.productTypesL1[path.section];
//    if (path.row == 0)
//    {
//        if (level)
//        {
//            *level = 0;
//        }
//        return rootType;
//    }
//    
//    DataAdapter* da = [DataAdapter shareInstance];
//    NSArray* types = [da productTypeForParent:rootType.productType];
//    if (level)
//    {
//        *level = 1;
//    }
//    return types[path.row - 1];
    if (path.row == 0)
    {
        if (level)
        {
            *level = 0;
        }
        return PRODUCT_TYPE_ROOT;
    }
    else
    {
        if (level)
        {
            *level = 1;
        }
        return ((ProductType*)self.productTypesL1[path.row -1]).productType;

    }
}

- (void)setProductTypeId:(NSString *)productTypeId
{
    _productTypeId = productTypeId;
    if (_target)
    {
        if ([_target respondsToSelector:_action])
        {
            [_target performSelector:_action withObject:_productTypeId];
        }
    }
}


@end
