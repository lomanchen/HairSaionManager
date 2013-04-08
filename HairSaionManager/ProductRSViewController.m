//
//  ProductRSViewController.m
//  HairSaionManager
//
//  Created by chen loman on 12-12-11.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import "ProductRSViewController.h"
#import "ProductShowingDetail.h"
#import "TextEditTableViewController.h"
#import "TextViewTableViewController.h"
#import "PopUpViewController.h"
#import "MGSplitViewController.h"
#import "ImagePickerViewController.h"
#import "ProductLSViewController.h"
#import "UIImage+fixOrientation.h"
#import "LifeBarDataProvider.h"
#import "MBProgressHUD.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageDownloader.h>

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
    kPrice,
    kType,
    kOrg,
    SIZE_OF_INTRODUCT,
}enumTableSctionIntroduct;
@interface ProductRSViewController ()
{
    BOOL beSubmited;
}
@property (nonatomic, strong)PopUpViewController* popImagePicker;
@property (nonatomic, strong)ImagePickerViewController* imagePickerViewController;

- (IBAction)onSave:(id)sender;
@end

@implementation ProductRSViewController
@synthesize popImagePicker, imagePickerViewController;
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
    beSubmited = NO;
    
    //    ProductShowingDetail* psd = (ProductShowingDetail*)self.item;
    //    NSLog(@"path=%@",[psd.imgDic objectForKey:PRODUCT_PIC_TYPE_FULL] );
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.section) {
        case kIntroduct:
            switch (indexPath.row) {
                case kName:
                    cell.detailTextLabel.text = self.item.name;
                    break;
                case kDetail:
                    cell.detailTextLabel.text = @"";//((ProductShowingDetail*)self.item).detail;
                    //                    cell.detailTextLabel.frame = CGRectMake(0, 0, 100, cell.detailTextLabel.bounds.size.height);
                    break;
                case kPrice:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",((ProductShowingDetail*)self.item).price];
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
    if (indexPath.section != kImage)
    {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    else
    {
        NSInteger key = nil;
        switch (indexPath.row)
        {
            case 0:
                key = LB_PRODUCT_PIC_TYPE_THUMB;
                break;
            case 1:
                key = LB_PRODUCT_PIC_TYPE_LEFT;
                break;
            case 2:
                key = LB_PRODUCT_PIC_TYPE_BACK;
                break;
            default:
                key = LB_PRODUCT_PIC_TYPE_THUMB;
                break;
        }
        imagePickerViewController = [[ImagePickerViewController alloc]initWithNibName:@"ImagePickerViewController" bundle:nil];
        imagePickerViewController.deleage = self;
        popImagePicker = [[PopUpViewController alloc]initWithContentViewController:imagePickerViewController];
        popImagePicker.popUpDeleage = self;
        //[self.imagePickerViewController setupViewWithImg:[self.item imageAtIndex:indexPath.row]withType:key];
        NSString* imageFileName = [self.item.imgLinkDic objectForKey:[NSNumber numberWithInteger:key]];
        if (imageFileName && ![imageFileName isEqualToString:@""])
        {
            NSString* tmpFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:imageFileName];
            if ([[LCFileManager shareInstance]checkSourPath:tmpFilePath error:nil])
            {
                [self.imagePickerViewController setupViewWithImg:[UIImage imageWithContentsOfFile:tmpFilePath] withType:[NSNumber numberWithInteger:key]];
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
                         [self.imagePickerViewController setupViewWithImg:image withType:[NSNumber numberWithInteger:key]];
                     }
                 }];
            }
        }
        
        [popImagePicker show:self.rootSplitViewController.view andAnimated:YES];
    }
    
    
}



- (void)setData:(PsDataItem *)item
{
    [super setData:item];
    [[LifeBarDataProvider shareInstance]loadPicLinksForProduct:item];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString* identifier = segue.identifier;
    UITableViewCell *cell = sender;
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        BaseRightSideViewController* vc = segue.destinationViewController;
        [vc setData:self.item];
        vc.identifier = cell.reuseIdentifier;
        vc.navigationItem.title = cell.textLabel.text;
    }
    //    if ([@"productName" isEqualToString:identifier])
    //    {
    //        TextEditTableViewController* vc = segue.destinationViewController;
    //        [vc setData:self.item];
    //        vc.text = self.item.name;
    //        vc.navigationItem.title = cell.textLabel.text;
    //    }
    //    else if ([@"productDetail" isEqualToString:identifier])
    //    {
    //        TextViewTableViewController* vc = segue.destinationViewController;
    //        [vc setData:self.item];
    //        vc.navigationItem.title = cell.textLabel.text;
    //
    //    }
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
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:self.leftViewController.mainVc.navigationController.view];
    [self.leftViewController.mainVc.navigationController.view addSubview:hub];
    
    hub.labelText = @"处理中...";
    
    // myProgressTask uses the HUD instance to update progress
    [hub showAnimated:YES whileExecutingBlock:^(void){
        if (self.isAddMode)
        {
            
            if ([[LifeBarDataProvider shareInstance]addProduct:self.item])
            {
                [((ProductLSViewController*)self.leftViewController) addRowWithData:self.item];
                self.isAddMode = NO;
                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                hub.mode = MBProgressHUDModeCustomView;
                hub.labelText = @"完成！";
                beSubmited = YES;
            }
            else
            {
                hub.labelText = @"添加产品失败，请重试！";
            }
            
            
        }
        else
        {
            if ([[LifeBarDataProvider shareInstance]updateProduct:self.item])
            {
                [((ProductLSViewController*)self.leftViewController) reloadRowWithData:self.item];
                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                hub.mode = MBProgressHUDModeCustomView;
                hub.labelText = @"完成！";
                beSubmited = YES;
            }
            else
            {
                hub.labelText = @"更新产品失败，请重试！";
            }
        }
    }];
    [((ProductLSViewController*)self.leftViewController) onSave:self.item];
    
    [self.leftViewController hideRSViewController:YES];
    
}

- (void)imageFinishEdit:(ImagePickerViewController *)imagePicker andImage:(UIImage *)image andType:(NSNumber *)type
{
    if (type)
    {
        MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:self.leftViewController.mainVc.navigationController.view];
        [self.leftViewController.mainVc.navigationController.view addSubview:hub];
        hub.labelText = @"图片上传中...";
        // myProgressTask uses the HUD instance to update progress
        [hub showAnimated:YES whileExecutingBlock:^(void){
            
            UIImage* fixOrientationImg = [image fixOrientation];
            //[self.item.imgDic setObject:vc.imageSource forKey:PRODUCT_PIC_TYPE_FULL];
            if (imagePicker.imagePickerControllerSourceType == UIImagePickerControllerSourceTypeCamera)
            {
                UIImageWriteToSavedPhotosAlbum(fixOrientationImg, nil, nil, nil);
            }
            NSString *tempPath = NSTemporaryDirectory();
            NSString  *pngPath = [tempPath stringByAppendingPathComponent:@"tmpproductimg.jpg"];
            NSLog(@"file path=%@", pngPath);
            [UIImageJPEGRepresentation(fixOrientationImg, 0.5) writeToFile:pngPath atomically:YES];
            NSString* tmpFileName = [[LifeBarDataProvider shareInstance]uploadImg:pngPath];
            if (tmpFileName && ![tmpFileName isEqualToString:@""])
            {
                [[LCFileManager shareInstance]moveFile:pngPath toDestPath:[tempPath stringByAppendingPathComponent:tmpFileName] overWrite:YES error:nil];
                [self.item setImgLink:tmpFileName withType:[type integerValue]];
            }
            
        }];
    }
    //[self.item.imgLinkDic setObject:imgFileName forKey:type];
    
}


@end
