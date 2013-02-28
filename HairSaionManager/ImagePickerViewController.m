//
//  ImagePickerViewController.m
//  HairSaionManager
//
//  Created by chen loman on 12-12-20.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import "ImagePickerViewController.h"
#import "YSImagePickerEditor.h"
#import "UIImage+fixOrientation.h"
#import "DataAdapter.h"

UIImage* imageFromView(UIImage* srcImage, CGRect* rect);


@interface ImagePickerViewController ()
@property (nonatomic, strong)YSImagePickerEditor* imagePicker;
@property (nonatomic, strong)NSNumber* imgType;

-(void)resetViewWithImage:(UIImage*)image;

@end

@implementation ImagePickerViewController
@synthesize size, imageView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)onCamera:(id)sender
{
    if([self.imagePicker isPopoverVisible])
    {
        [self.imagePicker dismissPopoverAnimated:YES];
        self.imagePicker =nil;
    }
        self.imagePicker = [[YSImagePickerEditor alloc] init];
        self.imagePicker.delegate = self;
    [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];

        [self.imagePicker presentImagePickerPopoverOverButton:sender withSize:CGSizeMake(200, 200)];
}

- (void)onMedia:(id)sender
{
    if([self.imagePicker isPopoverVisible])
    {
        [self.imagePicker dismissPopoverAnimated:YES];
        self.imagePicker = nil;
        self.imageSource = nil;
    }
        self.imagePicker = [[YSImagePickerEditor alloc] init];
        self.imagePicker.delegate = self;
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self.imagePicker presentImagePickerPopoverOverButton:sender withSize:CGSizeMake(200, 200)];
}

- (void)onFinish:(id)sender
{
    [self doneEditing];
    [self onCancel:sender];
}

-(void)YSImagePickerDoneEditWithImage:(UIImage*)image
{
    [self.imagePicker dismissPopoverAnimated:YES];
    [self resetViewWithImage:[image fixOrientation]];

}
-(void)YSImagePickerFailedWithError:(NSError *)error
{
    [self.imagePicker dismissPopoverAnimated:YES];
    self.imagePicker =nil;
}

//Called when the popover is dimissed by the user when touching outside the popover area
-(void)YSImagePickerDismissed
{
    
}

-(void)resetViewWithImage:(UIImage*)image
{
    //setup scrollview
    //self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, size.width, size.height);

    
//    UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"Ok" style:UIBarButtonItemStyleBordered target:self action:@selector(doneEditing)];
//    
//    self.navigationItem.title = @"Crop Image";
//    
//    [self.navigationItem setRightBarButtonItem:okButton animated:NO];
    
    
    //The following piece of code makes images fit inside the scrollview
    //by either their width or height, depending on which is smaller.
    //I.e, portrait images will fit horizontally in the scrollview,
    //allowing user to scroll vertically, while landscape images will fit vertically,
    //allowing user to scroll horizontally.
    CGFloat imageWidth = CGImageGetWidth(image.CGImage);
    CGFloat imageHeight = CGImageGetHeight(image.CGImage);
    
    int scrollWidth = _scrollView.frame.size.width;
    int scrollHeight = _scrollView.frame.size.height;
    
    //Limit by width or height, depending on which is smaller in relation to
    //the scrollview dimension.
    float scaleX = scrollWidth / imageWidth;
    float scaleY = scrollHeight / imageHeight;
    float scaleScroll =  (scaleX < scaleY ? scaleY : scaleX);
    
    _scrollView.bounds = CGRectMake(0, 0, imageWidth , imageHeight );
    _scrollView.frame = CGRectMake(0, _toolBar.bounds.size.height, scrollWidth, scrollHeight);
    if (imageView)
    {
        [imageView removeFromSuperview];
        imageView = nil;
    }
    imageView = [[UIImageView alloc] initWithImage: image ];
   // imageView.frame
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = TRUE;
    _scrollView.contentSize = image.size;
    _scrollView.pagingEnabled = NO;
    _scrollView.maximumZoomScale = scaleScroll*3;
    _scrollView.minimumZoomScale = scaleScroll;
    _scrollView.zoomScale = scaleScroll;
    
    [_scrollView addSubview:imageView];
}


-(void)doneEditing
{
    //Calculate the required area from the scrollview
    CGRect visibleRect;
    float scale = 1.0f/_scrollView.zoomScale;
    visibleRect.origin.x = _scrollView.contentOffset.x * scale;
    visibleRect.origin.y = _scrollView.contentOffset.y * scale;
    visibleRect.size.width = _scrollView.bounds.size.width * scale;
    visibleRect.size.height = _scrollView.bounds.size.height * scale;
    self.imageSource = imageFromView(imageView.image, &visibleRect);
//    [self.delegate YSImageCropDidFinishEditingWithImage: imageFromView(imageView.image, &visibleRect)];
    [self.deleage imageFinishEdit:self andImage:self.imageSource andType:self.imgType];
}

//------------------------------------------------------------------------------
#pragma mark - ScrollView Delegate
//------------------------------------------------------------------------------

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}


//------------------------------------------------------------------------------
#pragma mark - Super Methods
//------------------------------------------------------------------------------



#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self setupView];
    
    //imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setupViewWithImg:(UIImage*)image withType:(NSNumber *)type
{
    self.imgType = type;
    if (self.scrollView)
    {
        [self.scrollView removeFromSuperview];
        self.scrollView = nil;
    }
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _toolBar.bounds.size.height, self.view.frame.size.width, self.view.frame.size.height-_toolBar.bounds.size.height)];
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = CGRectMake(0, _toolBar.bounds.size.height, self.view.frame.size.width, self.view.frame.size.height-_toolBar.bounds.size.height);
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:imageView];
}


- (UIImagePickerControllerSourceType)imagePickerControllerSourceType
{
    return self.imagePicker.sourceType;
}
@end
