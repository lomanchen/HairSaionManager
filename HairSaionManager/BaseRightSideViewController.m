//
//  BaseRightSideViewController.m
//  HairSaionManager
//
//  Created by chen loman on 12-12-11.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import "BaseRightSideViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "BaseLeftSideViewController.h"
#import "MainSplitViewController.h"
#import "UIImage+fixOrientation.h"
#import "OrganizationItem.h"
#import "LifeBarDataProvider.h"
#import <SDWebImage/SDWebImageManager.h>


@interface BaseRightSideViewController ()

@end

@implementation BaseRightSideViewController
@synthesize lastSelectIndex, identifier, rootSplitViewController, leftViewController, isAddMode;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isAddMode = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lastSelectIndex = nil;
    CALayer* layer = self.view.layer;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, 0);
    layer.shadowOpacity = 1;
    layer.shadowRadius = 10;

    //self.navigationController.navigationBarHidden = YES;

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setData:(PsDataItem *)item
{
    _item = item;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[super tableView:tableView didSelectRowAtIndexPath:indexPath];
    self.lastSelectIndex = indexPath;
    //[self.detailNav pushViewController:vc animated:NO];
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //[MBProgressHUD hideAllHUDsForView:self.leftViewController.mainVc.navigationController.view animated:NO];
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
}

@end
