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
#import "MBProgressHUD.h"
#import "LifeBarDataProvider.h"
#import <SDWebImage/SDWebImageManager.h>

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
                    if (orgItem.type == LB_PRODUCT_DISCOUNT_TYPE_CUT)
                    cell.detailTextLabel.text = @"立减";
                    else
                        cell.detailTextLabel.text = @"折扣";
                    break;
                case kValue:
                    cell.detailTextLabel.text = orgItem.value;
                    break;
                case kOverlay:
                    if (orgItem.overlay == LB_DISCOUNT_CARD_NO_OVERLAY)
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
                        [vc fillDataWithTarget:orgItem action:@selector(setValue:) data:orgItem.value];
                        [self.navigationController pushViewController:vc animated:YES];

                        break;
                    case kOverlay:
                        if (orgItem.overlay == LB_DISCOUNT_CARD_NO_OVERLAY)
                        {
                            cell.accessoryType = UITableViewCellAccessoryCheckmark;
                            orgItem.overlay = LB_DISCOUNT_CARD_CAN_OVERLAY;
                        }
                        else
                        {
                            cell.accessoryType = UITableViewCellAccessoryNone;
                            orgItem.overlay = LB_DISCOUNT_CARD_NO_OVERLAY;
                        }
                        break;
                    case kType:
                        if (orgItem.type == LB_PRODUCT_DISCOUNT_TYPE_CUT)
                        {
                            cell.detailTextLabel.text = @"折扣";
                            orgItem.type = LB_PRODUCT_DISCOUNT_TYPE_PERCENT;
                        }
                        else
                        {
                            cell.detailTextLabel.text = @"立减";
                            orgItem.type = LB_PRODUCT_DISCOUNT_TYPE_CUT;
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
        NSString* imageFileName = [self.item.imgLinkDic objectForKey:[NSNumber numberWithInteger:LB_DISCOUNTCARD_PIC_TYPE_DEFAULT]];
        if (imageFileName && ![imageFileName isEqualToString:@""])
        {
            NSString* tmpFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:imageFileName];
            if ([[LCFileManager shareInstance]checkSourPath:tmpFilePath error:nil])
            {
                [self.imagePickerViewController setupViewWithImg:[UIImage imageWithContentsOfFile:tmpFilePath] withType:[NSNumber numberWithInteger:LB_DISCOUNTCARD_PIC_TYPE_DEFAULT]];
            }
            else
            {
                NSString* url = [[[LifeBarDataProvider shareInstance]imgPathForProduct] stringByAppendingString:imageFileName];
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadWithURL:url
                                 options:0
                                progress:^(NSUInteger receivedSize, long long expectedSize)
                 {
                     // progression tracking code
                 }
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
                 {
                     if (image)
                     {
                         [self.imagePickerViewController setupViewWithImg:image withType:[NSNumber numberWithInteger:LB_DISCOUNTCARD_PIC_TYPE_DEFAULT]];
                     }
                 }];
            }
        }
        else
        {
            [self.imagePickerViewController setupViewWithImg:nil withType:[NSNumber numberWithInteger:LB_DISCOUNTCARD_PIC_TYPE_DEFAULT]];
        }
        
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
    
    NSString* errMsg;
    if (![self.item checkProperties:&errMsg])
    {
        [MBProgressHUD showMessage:errMsg inView:self.leftViewController.mainVc.navigationController.view];
        return ;
    }
    
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:self.leftViewController.mainVc.navigationController.view];
    [self.leftViewController.mainVc.navigationController.view addSubview:hub];
    hub.labelText = @"处理中...";
    __block BOOL saveResult = NO;
    [hub showAnimated:YES whileExecutingBlock:^(void){
        if (self.isAddMode)
        {
            saveResult = [[LifeBarDataProvider shareInstance]addDiscountCard:self.item];
            
        }
        else
        {
            saveResult = [[LifeBarDataProvider shareInstance]updateDiscountCard:self.item];
        }
    }completionBlock:^(void){
        if (saveResult)
        {
            if (self.isAddMode)
            {
                [((TableLSViewController*)self.leftViewController) addRowWithData:self.item];
                self.isAddMode = NO;
            }
            else
            {
                [((TableLSViewController*)self.leftViewController) reloadRowWithData:self.item];
            }
            [((TableLSViewController*)self.leftViewController) onSave:self.item];
            [self.leftViewController hideRSViewController:YES];
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hub.mode = MBProgressHUDModeCustomView;
            hub.labelText = @"完成！";
            hub.removeFromSuperViewOnHide = YES;
            [hub hide:YES afterDelay:1];
        }
        else
        {
            hub.labelText = @"网络不给力，请重试！";
            hub.mode = MBProgressHUDModeText;
            hub.margin = 10.f;
            hub.yOffset = 150.f;
            hub.removeFromSuperViewOnHide = YES;
            [hub hide:YES afterDelay:3];
            
        }
    }];
    
}


@end
