//
//  TypeEditViewController.m
//  HairSaionManager
//
//  Created by chen loman on 13-1-23.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import "TypeEditViewController.h"
#import "DataAdapter.h"
#import "TextFieldEditViewController.h"
#import "ProductTypeItem.h"
#import "ProductTypeSelectorViewController.h"
#import "ConfAdapter.h"
typedef enum
{
    kType = 0,
    kConf,
    SIZE_OF_SECTION
}kSection;

@interface TypeEditViewController ()
@property (nonatomic, strong)NSString* rootType;
@property (nonatomic, strong)NSString* typeName;
@property (nonatomic, strong)ProductTypeItem* editingItem;
- (void)onEdit:(id)sender;
- (void)onAdd:(id)sender;
@end

@implementation TypeEditViewController
@synthesize typeName, editingItem;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _rootType = PRODUCT_TYPE_ROOT;

    }
    return self;
}

- (id)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([_rootType isEqualToString:PRODUCT_TYPE_ROOT])
    {
        self.title = @"产品一级分类及显示选项配置";
    }
    else
    {
        self.title = @"二级分类";
    }
    [self setupNavForEdit];
    
    self.tableView.allowsSelectionDuringEditing = YES;
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
    if ([_rootType isEqualToString:PRODUCT_TYPE_ROOT])
        return SIZE_OF_SECTION;
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    switch (section)
    {
        case kType:
            if (_rootType)
            {
                return [[[DataAdapter shareInstance]productTypeForParent:_rootType] count];
            }
            else
            {
                return [[[DataAdapter shareInstance]productTypeForParent:PRODUCT_TYPE_ROOT] count];
            }
            break;
        case kConf:
            return 2;
        default:
            return 0;
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ConfAdapter* ca = [ConfAdapter shareInstance];
    switch (indexPath.section) {
        case kType:
                cell.textLabel.text = ((ProductType*)[[DataAdapter shareInstance]productTypeForParent:_rootType][indexPath.row]).typeName;
            break;
        case kConf:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"分店介绍";
                    if ([ca isShowSubbranch])
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    break;
                    case 1:
                    cell.textLabel.text = @"优惠政策";
                    if ([ca isShowDiscountCard])
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    break;
                default:
                    break;
            }
        default:
            break;
    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    // Configure the cell...
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    switch (indexPath.section) {
        case kType:
            return YES;
            break;
        case kConf:
            return NO;
        default:
            break;
    }
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[DataAdapter shareInstance]deleteProductType:[[DataAdapter shareInstance]productTypeForParent:_rootType][indexPath.row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //重置"+按钮"
        if ([self.navigationItem.rightBarButtonItems count] < 2)
        {
            if ([[[DataAdapter shareInstance]productTypeForParent:_rootType] count] < 4)
            {
                NSMutableArray* itemArray = [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
                UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAdd:)];
                [itemArray addObject:item];
                self.navigationItem.rightBarButtonItems = [NSArray arrayWithArray:itemArray];
            }
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kType)
    {
    if ([tableView isEditing])
    {
        editingItem = [[ProductTypeItem alloc]initWithObject:[[DataAdapter shareInstance]productTypeForParent:_rootType][indexPath.row] ];
//        TextFieldEditViewController* vc = [[TextFieldEditViewController alloc]initWithNibName:@"TextFieldEditViewController" bundle:nil];
//        //[vc setData:&currentTypeName];
//        [vc fillDataWithTarget:editingItem action:@selector(setName:) data:editingItem.name];
        TypeAddViewController* vc = [[TypeAddViewController alloc]initWithItem:editingItem];
        vc.delege = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else
    {
        if ([((ProductType*)[[DataAdapter shareInstance]productTypeForParent:_rootType][indexPath.row]).typeParent isEqualToString:PRODUCT_TYPE_ROOT])
        {
            
            TypeEditViewController* vc = [[TypeEditViewController alloc]init];
            [vc setRootType:((ProductType*)[[DataAdapter shareInstance]productTypeForParent:_rootType][indexPath.row]).productType];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    }
    else
    {
        ConfAdapter* ca = [ConfAdapter shareInstance];
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        switch (indexPath.row)
        {
            case 0:
                if ([ca isShowSubbranch])
                {
                    [ca setShowSubBranch:NO];
                }
                else
                {
                    [ca setShowSubBranch:YES];
                }
                break;
            case 1:
                if ([ca isShowDiscountCard])
                {
                    [ca setShowDiscountCard:NO];
                }
                else
                {
                    [ca setShowDiscountCard:YES];
                }
                break;
            default:
                break;
        }
    }
}

- (void)setRootType:(NSString *)rootType
{
    _rootType = rootType;
    [self.tableView reloadData];
}


- (void)onEdit:(id)sender
{
    [self.tableView setEditing:YES animated:YES];
    [self setupNavForDone];
}

- (void)onAdd:(id)sender
{
    TypeAddViewController* vc  = [[TypeAddViewController alloc]initWithRootType:_rootType];
    vc.delege = self;
    [self.navigationController pushViewController:vc animated:YES];

    
}

- (void)onFinish:(id)sender
{
    [self.tableView setEditing:NO animated:YES];

    [self setupNavForEdit];
}



- (void)setupNavForEdit
{
    NSMutableArray* itemArray = [NSMutableArray array];
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEdit:)];
    [itemArray addObject:item];
    if ([[[DataAdapter shareInstance]productTypeForParent:_rootType] count] < 4)
    {
        item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAdd:)];
        [itemArray addObject:item];
    }
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithArray:itemArray];
}

- (void)setupNavForDone
{
    NSMutableArray* itemArray = [NSMutableArray array];
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onFinish:)];
    [itemArray addObject:item];
    if ([[[DataAdapter shareInstance]productTypeForParent:_rootType] count] < 4)
    {
        item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAdd:)];
        [itemArray addObject:item];
    }
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithArray:itemArray];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)saveSuccess:(TypeAddViewController *)vc andItem:(ProductTypeItem *)item
{
    [self.tableView reloadData];
}


- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"分类列表";
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"提醒：当前系统只支持二级分类，每级分类暂只支持4种分类，多出部分将无法在终端显示。";
}

@end
