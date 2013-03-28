//
//  BranchRSViewController.m
//  HairSaionManager
//
//  Created by chen loman on 13-3-7.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import "BranchRSViewController.h"
#import "TextEditTableViewController.h"
#import "TextViewTableViewController.h"
#import "PopUpViewController.h"
#import "MGSplitViewController.h"
#import "ImagePickerViewController.h"
#import "BranchLSViewController.h"
#import "UIImage+fixOrientation.h"
#import "OrganizationItem.h"
#import "TextFieldEditViewController.h"
#import "LCMapKits.h"


typedef enum
{
    kIntroduct,
    kLocation,
    kImage,
    SIZE_OF_SECTION
}enumTableSection;

typedef enum
{
    kName,
    kDetail,
    kPhone,
    kEmail,
    kWebSite,
    SIZE_OF_INTRODUCT,
}enumTableSctionIntroduct;

typedef enum
{
    kState,
    kCity,
    kStreet,
    kZip,
    kGetLocation,
    kLatitude,
    kLongitude,
    SIZE_OF_LOCATION,
}enumTableSctionLocation;

@interface BranchRSViewController ()
@property (nonatomic, strong)PopUpViewController* popImagePicker;
@property (nonatomic, strong)ImagePickerViewController* imagePickerViewController;
- (IBAction)onSave:(id)sender;

@end

@implementation BranchRSViewController

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
    OrganizationItem* orgItem = self.item;
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
                case kPhone:
                    cell.detailTextLabel.text = orgItem.phone;
                    break;
                case kEmail:
                    cell.detailTextLabel.text = orgItem.email;
                    break;
                case kWebSite:
                    cell.detailTextLabel.text = orgItem.url;
                    break;
                default:
                    break;
            }
            break;
        case kLocation:
            switch (indexPath.row){
                case kState:
                    cell.detailTextLabel.text = orgItem.state;
                    break;
                case kCity:
                    cell.detailTextLabel.text = orgItem.city;
                    break;
                case kStreet:
                    cell.detailTextLabel.text = orgItem.street;
                    break;
                case kZip:
                    cell.detailTextLabel.text = orgItem.zip;
                    break;
                case kLatitude:
                    cell.detailTextLabel.text =[NSString stringWithFormat:@"%f", orgItem.latitude];
                    break;
                case kLongitude:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%f", orgItem.longitude];
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
        OrganizationItem* orgItem = self.item;
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
                    case kPhone:
                        [vc fillDataWithTarget:orgItem action:@selector(setPhone:) data:orgItem.phone];
                        [self.navigationController pushViewController:vc animated:YES];
                        
                        break;
                    case kEmail:
                        [vc fillDataWithTarget:orgItem action:@selector(setEmail:) data:orgItem.email];
                        [self.navigationController pushViewController:vc animated:YES];
                        break;
                    case kWebSite:
                        [vc fillDataWithTarget:orgItem action:@selector(setUrl:) data:orgItem.url];
                        [self.navigationController pushViewController:vc animated:YES];
                        break;
                    default:
                        break;
                }
                break;
            case kLocation:
                switch (indexPath.row){
                    case kState:
                        [vc fillDataWithTarget:orgItem action:@selector(setState:) data:orgItem.state];
                        [self.navigationController pushViewController:vc animated:YES];
                        break;
                    case kCity:
                        [vc fillDataWithTarget:orgItem action:@selector(setCity:) data:orgItem.city];
                        [self.navigationController pushViewController:vc animated:YES];
                        break;
                    case kStreet:
                        [vc fillDataWithTarget:orgItem action:@selector(setStreet:) data:orgItem.street];
                        [self.navigationController pushViewController:vc animated:YES];
                        break;
                    case kZip:
                        [vc fillDataWithTarget:orgItem action:@selector(setZip:) data:orgItem.zip];
                        [self.navigationController pushViewController:vc animated:YES];
                        break;
                    case kGetLocation:
                        [self getLocation];
                        break;
                    case kLatitude:
                        [vc fillDataWithTarget:self action:@selector(setLatitude:) data:[NSString stringWithFormat:@"%f", orgItem.latitude]];
                        [self.navigationController pushViewController:vc animated:YES];
                        break;
                    case kLongitude:
                        [vc fillDataWithTarget:self action:@selector(setLongitude:) data:[NSString stringWithFormat:@"%f", orgItem.longitude]];
                        [self.navigationController pushViewController:vc animated:YES];
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
        self.imagePickerViewController = [[ImagePickerViewController alloc]initWithNibName:@"ImagePickerViewController" bundle:nil];
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
    [[DataAdapter shareInstance]updateOrg:self.item];
    if (self.isAddMode)
    {
        [((BranchLSViewController*)self.leftViewController) addRowWithData:self.item];
        self.isAddMode = NO;
    }
    else
    {
        [((BranchLSViewController*)self.leftViewController) reloadRowWithData:self.item];
    }
    
    [((BranchLSViewController*)self.leftViewController) onSave:self.item];
    
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

- (void)setLatitude:(NSString*)value
{
    OrganizationItem* orgItem = self.item;
    
    orgItem.latitude = [value doubleValue];
    
}

- (void)setLongitude:(NSString*)value
{
    OrganizationItem* orgItem = self.item;
    
    orgItem.longitude = [value doubleValue];
    
}

- (void)getLocation
{
    OrganizationItem* orgItem = self.item;
    CLLocationCoordinate2D location = [LCMapKits geoCodeUsingAddress:[orgItem address] andCity:orgItem.city];
    orgItem.latitude = location.latitude;
    orgItem.longitude = location.longitude;
    NSIndexPath* path1 = [NSIndexPath indexPathForRow:kLatitude inSection:kLocation];
    NSIndexPath* path2 = [NSIndexPath indexPathForRow:kLongitude inSection:kLocation];

    [self.tableView reloadRowsAtIndexPaths:@[path1, path2] withRowAnimation:UITableViewRowAnimationNone];
    
}

@end
