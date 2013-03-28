//
//  ImagePickerViewController.h
//  HairSaionManager
//
//  Created by chen loman on 12-12-20.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSImagePickerEditorDelegate.h"
#import "PopUpSubViewController.h"

@class ImagePickerViewController;

@protocol ImagePickerViewControllerDeleage <NSObject>

- (void)imageFinishEdit:(ImagePickerViewController*)imagePicker andImage:(UIImage*)image andType:(NSNumber*)type;

@end

@interface ImagePickerViewController : PopUpSubViewController<YSImagePickerEditorDelegate,UIScrollViewDelegate>
@property (nonatomic, assign) id<ImagePickerViewControllerDeleage> deleage;
@property (nonatomic, strong) IBOutlet UIImageView* imageView;
@property (nonatomic, assign)    CGSize size;
@property (nonatomic, strong) UIImage* imageSource;
@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;



@property (nonatomic, strong)IBOutlet UIImageView* ivFull;
@property (nonatomic, strong)IBOutlet UIImageView* ivMid;
@property (nonatomic, strong)IBOutlet UIImageView* ivThumb;
@property (nonatomic, strong)IBOutlet UIToolbar* toolBar;

- (IBAction)onCancel:(id)sender;
- (IBAction)onFinish:(id)sender;
- (IBAction)onCamera:(id)sender;
- (IBAction)onMedia:(id)sender;

- (void)setupViewWithImg:(UIImage*)image withType:(NSNumber*)type;

- (UIImagePickerControllerSourceType)imagePickerControllerSourceType;


- (void)setContentSize:(CGSize)size;
@end
