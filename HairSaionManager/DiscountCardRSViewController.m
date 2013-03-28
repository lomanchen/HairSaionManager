//
//  DiscountCardRSViewController.m
//  HairSaionManager
//
//  Created by chen loman on 13-3-8.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import "DiscountCardRSViewController.h"
#import "TextEditTableViewController.h"
#import "TextViewTableViewController.h"
#import "PopUpViewController.h"
#import "MGSplitViewController.h"
#import "ImagePickerViewController.h"
#import "DiscountCardLSViewController.h"
#import "UIImage+fixOrientation.h"
#import "DiscountCardItem.h"
#import "TextFieldEditViewController.h"
typedef enum
{
    kIntroduct,
    kImage,
    SIZE_OF_SECTION
}enumTableSection;

typedef enum
{
    kName,
    kDetail,
    kType,
    kValue,
    kOverlay,
    SIZE_OF_INTRODUCT,
}enumTableSctionIntroduct;




@interface DiscountCardRSViewController ()
@property (nonatomic, strong)PopUpViewController* popImagePicker;
@property (nonatomic, strong)ImagePickerViewController* imagePickerViewController;
- (IBAction)onSave:(id)sender;
@end

@implementation DiscountCardRSViewController

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    DiscountCardItem* orgItem = self.item;
    switch (indexPath.section) {
        case kIntroduct:
            switch (indexPath.row) {
                case kName:
                    cell.detailTextLabel.text = orgItem.name;
                    break;
                case kDetail:
                    cell.detailTextLabel.text = orgItem.detail;//((ProductShowingDetail*)self.item).detail;
                    //                    cell.detailTextLabel.frame = CGRectMake(0, 0, 100, cell.detailTextLabel.bounds.size.height);
                    break;
                case kType:
                    if ([orgItem.discountType isEqualToNumber:PRODUCT_DISCOUNT_TYPE_CUT])
                    cell.detailTextLabel.text = @"立减";
                    else
                        cell.detailTextLabel.text = @"折扣";
                    break;
                case kValue:
                    cell.detailTextLabel.text = orgItem.calcValue;
                    break;
                case kOverlay:
                    if ([orgItem.overlay isEqualToNumber:DISCOUNT_CARD_NO_OVERLAY])
                    {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    else
                    {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    if (indexPath.section != kImage)
    {
        TextFieldEditViewController* vc = [[TextFieldEditViewController alloc]initWithNibName:@"TextFieldEditViewController" bundle:nil];
        DiscountCardItem* orgItem = self.item;
        switch (indexPath.section) {
            case kIntroduct:
                switch (indexPath.row) {
                    case kName:
                        [vc fillDataWithTarget:orgItem action:@selector(setName:) data:orgItem.name];
                        [self.navigationController pushViewController:vc animated:YES];
                        break;
                    case kDetail:
                        [vc fillDataWithTarget:orgItem action:@selector(setDetail:) data:orgItem.detail];
                        [self.navigationController pushViewController:vc animated:YES];

                        break;
                    case kValue:
                        [vc fillDataWithTarget:orgItem action:@selector(setCalcValue:) data:orgItem.calcValue];
                        [self.navigationController pushViewController:vc animated:YES];

                        break;
                    case kOverlay:
                        if ([orgItem.overlay isEqualToNumber:DISCOUNT_CARD_NO_OVERLAY])
                        {
                            cell.accessoryType = UITableViewCellAccessoryCheckmark;
                            orgItem.overlay = DISCOUNT_CARD_CAN_OVERLAY;
                        }
                        else
                        {
                            cell.accessoryType = UITableViewCellAccessoryNone;
                            orgItem.overlay = DISCOUNT_CARD_NO_OVERLAY;
                        }
                        break;
                    case kType:
                        if ([orgItem.discountType isEqualToNumber:PRODUCT_DISCOUNT_TYPE_CUT])
                        {
                            cell.detailTextLabel.text = @"折扣";
                            orgItem.discountType = PRODUCT_DISCOUNT_TYPE_PERCENT;
                        }
                        else
                        {
                            cell.detailTextLabel.text = @"立减";
                            orgItem.discountType = PRODUCT_DISCOUNT_TYPE_CUT;
                        }

                        break;
                    default:
                        break;
                }
                break;
            default:
                break;
        }
        
    }
    
    else
    {
        self.imagePickerViewController = [[ImagePickerViewController alloc]initWithNibName:@"ImagePickerViewControllerForDiscountCard" bundle:nil];
        self.imagePickerViewController.deleage = self;
        self.popImagePicker = [[PopUpViewController alloc]initWithContentViewController:self.imagePickerViewController];
        self.popImagePicker.popUpDeleage = self;
        [self.imagePickerViewController setupViewWithImg:[self.item imageAtIndex:indexPath.row]withType:PRODUCT_PIC_TYPE_DEFAULT];
        [self.popImagePicker show:self.rootSplitViewController.view andAnimated:YES];
    }
    
    
}



- (void)setData:(PsDataItem *)item
{
    [super setData:item];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (nil != self.lastSelectIndex)
    {
        [self.tableView reloadRowsAtIndexPaths:@[self.lastSelectIndex] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

- (BOOL)viewWillPopUpWithSubViewController:(PopUpSubViewController *)subVc animated:(BOOL)animated //return NO to not show
{
    
    return YES;
}
- (BOOL)viewWillHideWithSubViewController:(PopUpSubViewController *)subVc animated:(BOOL)animated
{
    return YES;
}

- (void)onSave:(id)sender
{
    [[DataAdapter shareInstance]updateDiscountCard:self.item];
    if (self.isAddMode)
    {
        [((DiscountCardLSViewController*)self.leftViewController) addRowWithData:self.item];
        self.isAddMode = NO;
    }
    else
    {
        [((DiscountCardLSViewController*)self.leftViewController) reloadRowWithData:self.item];
    }
    
    [((DiscountCardLSViewController*)self.leftViewController) onSave:self.item];
    
    [self.leftViewController hideRSViewController:YES];
    
}

- (void)imageFinishEdit:(ImagePickerViewController *)imagePicker andImage:(UIImage *)image andType:(NSNumber *)type
{
    DataAdapter* da = [DataAdapter shareInstance];
    UIImage* fixOrientationImg = [image fixOrientation];
    //[self.item.imgDic setObject:vc.imageSource forKey:PRODUCT_PIC_TYPE_FULL];
    if (imagePicker.imagePickerControllerSourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(fixOrientationImg, nil, nil, nil);
    }
    NSString* imgFileName = [[da imgFileNameGenerator] stringByAppendingString:@".jpg"];
    NSString  *pngPath = [[da imgPath] stringByAppendingPathComponent:imgFileName];
    NSLog(@"file path=%@", pngPath);
    [UIImageJPEGRepresentation(fixOrientationImg, 0.5) writeToFile:pngPath atomically:YES];
    [self.item.imgLinkDic setObject:imgFileName forKey:type];
    
    
}

@end
