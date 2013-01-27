//
//  TypeAddViewController.m
//  HairSaionManager
//
//  Created by chen loman on 13-1-24.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import "TypeAddViewController.h"
#import "ProductTypeItem.h"
#import "DataAdapter.h"
#import "TextFieldEditViewController.h"
#import "ProductTypeSelectorViewController.h"

#define _DEFAULT_NAME @"类型名称"
typedef enum
{
    kName = 0,
    kParent,
    NUMBER_OF_SECTION
}enumRow;

@interface TypeAddViewController ()
@property (nonatomic, strong)ProductTypeItem* item;
@property (nonatomic, assign)BOOL rootSelected;
@property (nonatomic, assign)BOOL addMode;

@end

@implementation TypeAddViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithItem:(ProductTypeItem*)item
{
    self = [super initWithNibName:@"TypeAddViewController" bundle:nil];
    if (self)
    {
        _item = item;
        _rootSelected = NO;
    }
    return self;
}
- (id)initWithRootType:(NSString*)rootType
{
    self = [super initWithNibName:@"TypeAddViewController" bundle:nil];
    if (self)
    {
        _item = [[ProductTypeItem alloc]init];
        _item.name = _DEFAULT_NAME;
        _item.typeParent = rootType;
        _rootSelected = YES;
        _addMode = YES;
    }
    return self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!_item)
    {
        _item = [[ProductTypeItem alloc]init];
        _item.name = _DEFAULT_NAME;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSave:)];

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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return NUMBER_OF_SECTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (_item)
    {
        switch (indexPath.section)
        {
            case kName:
                cell.textLabel.text = _item.name;
                break;
            case kParent:
                if ([_item.typeParent isEqualToString:PRODUCT_TYPE_ROOT])
                {
                    cell.textLabel.text = @"根类型";
                }
                else
                {
                    cell.textLabel.text = [[DataAdapter shareInstance]productTypeById:_item.typeParent].typeName;
                }
                break;
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.section)
        {
            case kName:
                cell.textLabel.text = @"类型名称";
                break;
            case kParent:
                cell.textLabel.text = @"父分类";
                break;
            default:
                break;
        }
    }
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */    
    if (indexPath.section == kName)
    {
        TextFieldEditViewController* vc = [[TextFieldEditViewController alloc]initWithNibName:@"TextFieldEditViewController" bundle:nil];
        [vc fillDataWithTarget:_item action:@selector(setName:) data:_item.name];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == kParent)
    {
        ProductTypeSelectorViewController* vc = [[ProductTypeSelectorViewController alloc]initWithProductTypeId:_item.typeParent target:_item action:@selector(setTypeParent:)];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case kName:
            return @"分类名称";
        case kParent:
            return @"父类型";
        default:
            return @"";
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


- (void)onSave:(id)sender
{
    if ([_item.name isEqualToString:@""] || [_item.name isEqualToString:_DEFAULT_NAME])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"分类名称未指定，请重新输入！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        if (_addMode)
        {
            [[DataAdapter shareInstance]insertProductType:_item];
        }
        else
        {
            [[DataAdapter shareInstance]updateProductType:_item];
        }
        [self.navigationController popViewControllerAnimated:YES];
        if (_delege)
        {
            [_delege saveSuccess:self andItem:_item];
        }
    }
}

@end
