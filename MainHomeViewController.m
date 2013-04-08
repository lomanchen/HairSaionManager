//
//  MainHomeViewController.m
//  HairSaionManager
//
//  Created by chen loman on 13-3-19.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#define IMG_W  170

#define NUMBER_OF_ITEMS (IS_IPAD? 19: 12)
#define NUMBER_OF_VISIBLE_ITEMS 5
#define ITEM_SPACING (IMG_W+400)
#define INCLUDE_PLACEHOLDERS NO

#import "MainHomeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SyncOperationManager.h"
#import "SyncProgressViewController.h"
#import "SyncPopUpViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DataAdapter.h"
#import "TypeEditViewController.h"
#import "EmpMainSplitViewController.h"
#import "MainSplitViewController.h"
#import "LifeBarDataProvider.h"

@interface MainHomeViewController ()
@property (nonatomic, strong)IBOutlet UILabel* labelName;
@property (nonatomic, assign)NSInteger lastSelected;


@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) NSArray *itemsName;

@property (nonatomic, assign) BOOL isAuthing;
@property (nonatomic, assign) BOOL isSynced;
@property (nonatomic, strong) NSString* imgPath;


- (void)onLogin:(id)sender;
- (void)onTypeMgr:(id)sender;
- (void)onEmpMgr:(id)sender;
- (void)onProductMgr:(id)sender;
- (void)onSync:(id)sender;
- (void)onPub:(id)sender;
- (void)onAbout:(id)sender;

@end

@implementation MainHomeViewController
@synthesize wrap, carousel, items;

- (void)setUp
{
	//set up data
    LifeBarDataProvider* lbp = [LifeBarDataProvider shareInstance];
	wrap = YES;
    self.items = [NSArray arrayWithContentsOfFile:[[NSBundle  mainBundle] pathForResource:@"MainHomeItem.plist"    ofType:nil]];
    self.isSynced = NO;
    self.isAuthing = NO;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setUp];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"主界面";
    carousel.decelerationRate = 0.5;
    carousel.type = iCarouselTypeCoverFlow2;
    self.lastSelected = -1;
    
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imgOnTouch:(id)target
{
    UITapGestureRecognizer* gr = target;
    
    if (self.lastSelected != -1)
    {
        NSDictionary* info = [items objectAtIndex:self.lastSelected];
        NSString* sel = [info objectForKey:@"onClickSel"];
        if (sel && [self respondsToSelector:NSSelectorFromString(sel)])
        {
            [self performSelector:NSSelectorFromString(sel) withObject:gr.view];
        }
    }
//    [self img:iv setState:YES];
//    self.lastSelected = iv.tag;
    
}

- (void)img:(UIImageView*)iv setState:(BOOL)state
{
    if (iv)
    {
        if (state)
        {
            
            iv.layer.borderWidth = 5.0f;
            iv.layer.borderColor = COLOR_BLUE.CGColor;
        }
        else
        {
            iv.layer.borderWidth = 0.0f;
        }
    }
}


- (void)dealloc
{
	//it's a good idea to set these to nil here to avoid
	//sending messages to a deallocated viewcontroller
	carousel.delegate = nil;
	carousel.dataSource = nil;
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.carousel = nil;
}
#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [items count];
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    //this also affects the appearance of circular-type carousels
    return NUMBER_OF_VISIBLE_ITEMS;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
	//UILabel *label = nil;
	
	//create new view if no view is available for recycling
    NSDictionary* info = [self.items objectAtIndex:index];
	if (view == nil)
	{
        
        UIImageView* iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, IMG_W, IMG_W)];
        UITapGestureRecognizer* gr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgOnTouch:)];
        gr.delegate = self;
        [gr setNumberOfTapsRequired:1];
        [iv addGestureRecognizer:gr];
        iv.userInteractionEnabled = YES;
        CGRect frame = iv.frame;
        iv.image = [UIImage imageNamed:[info objectForKey:@"imgName"]];
        iv.contentMode = UIViewContentModeScaleToFill;
        iv.tag = index;
        view = iv;
        
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(0, 5);
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 4;
        //view.layer.shadowPath =  [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
        //        iv.frame = frame;
        //        [self.svContent addSubview:iv];
        
        //		view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page.png"]] autorelease];
        //		label = [[[UILabel alloc] initWithFrame:view.bounds] autorelease];
        //		label.backgroundColor = [UIColor clearColor];
        //		label.textAlignment = UITextAlignmentCenter;
        //		label.font = [label.font fontWithSize:50];
        //		[view addSubview:label];
	}
	else
	{
		//label = [[view subviews] lastObject];
        UIImageView* iv = view;
        iv.image = [UIImage imageNamed:[info objectForKey:@"imgName"]];
        
	}
	
    //set label
	//label.text = [[items objectAtIndex:index] stringValue];
	
	return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	//note: placeholder views are only displayed on some carousels if wrapping is disabled
	return INCLUDE_PLACEHOLDERS? 2: 0;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //usually this should be slightly wider than the item views
    return ITEM_SPACING;
}

- (CGFloat)carousel:(iCarousel *)carousel itemAlphaForOffset:(CGFloat)offset
{
	//set opacity based on distance from camera
    return 1.0f - fminf(fmaxf(offset, 0.0f), 1.0f);
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return wrap;
}


- (CGFloat)carousel:(iCarousel *)carousel valueForTransformOption:(iCarouselTranformOption)option withDefault:(CGFloat)value
{
    return 0.3;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}


- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
}


- (void)carouselCurrentItemIndexUpdated:(iCarousel *)carousel
{
    [self setSelectedwithIndex:carousel.currentItemIndex];
    
}


- (void)setSelectedwithIndex:(NSInteger)index
{
    if (self.lastSelected != -1)
    {
        [self img:[carousel itemViewAtIndex:self.lastSelected] setState:NO];
    }
    self.lastSelected = index;
    [self img:[carousel itemViewAtIndex:index] setState:YES];
    NSDictionary* info = [self.items objectAtIndex:index];
    self.labelName.text = [info objectForKey:@"displayName"];
}


- (void)viewDidHide:(PopUpViewController *)vc
{
    NSLog(@"viewDidHide enter");
    if (self.isSynced)
    {
        UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"PageViewStoryBoard" bundle:nil];
        UIViewController* root = [storyBoard instantiateInitialViewController];
        //UIViewController* root = [[RootViewController alloc]init];
        [self.navigationController presentModalViewController:root animated:YES];
        self.isSynced = NO;
    }
}

- (void)onLogin:(id)sender
{
    OrganizationItem* orgInfo;
    if([[LifeBarDataProvider shareInstance]orgLogin:@"babaiban" andPwd:@"222222"])
    {
        return ;
    SyncOperationManager* sync = [SyncOperationManager shareInstance];
    if ([sync isAuthoried])
    {
        //do nothing
    }
    else
    {
        [sync doAuthorizeInViewController:self];
    }
    }
}

- (void)onTypeMgr:(id)sender
{
    [self.navigationController setNavigationBarHidden:NO];
    TypeEditViewController* vc = [[TypeEditViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if (self.items && [self.items count] > 0)
    {
        [self setSelectedwithIndex:self.carousel.currentItemIndex];
    }
    
    if (self.isAuthing)
    {
        SyncOperationManager* syncManager = [SyncOperationManager shareInstance];
        
        //    SyncMainViewController* vc = [[SyncMainViewController alloc]initWithNibName:@"SyncMainViewController" bundle:nil];
        
        //    [self.psViewController.rootViewController.view addSubview:vc.view];
        //    vc.view.frame =  CGRectMake(0, 0, 800, 600);
        if ([syncManager isAuthoried])
        {
            SyncProgressViewController* vc = [[SyncProgressViewController alloc]initWithNibName:@"SyncProgressViewController" bundle:nil];
            syncManager.processerDelege = vc;
            syncManager.resultDelege = self;
            //UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:vc];
            //nav.view.frame = CGRectMake(0, 0, 800, 600);
            //nav.navigationBarHidden = YES;
            //PopUpViewController* pop = [[PopUpViewController alloc]initWithNavContentViewController:nav];
            SyncPopUpViewController* pop = [[SyncPopUpViewController alloc]initWithContentViewController:vc];
            pop.popUpDeleage = self;
            [pop show:self.view andAnimated:YES];
            if (self.isSynced)
            {
                [syncManager doSync:nil];
            }
            else
            {
                [syncManager doUpdate:nil];
            }
            [pop show:self.view andAnimated:YES];
        }
    }
}

- (void)syncSuccess:(SyncOperationManager *)manager
{
    self.isAuthing = NO;
    if (!self.isSynced)
    {
        [[DataAdapter shareInstance]resetDatabaseWithFile:[[[DataAdapter shareInstance]dbPath] stringByAppendingPathComponent:LOCAL_DB_FILE_NAME]];
        self.isSynced = NO;
    }
}



- (void)onPub:(id)sender
{
    SyncOperationManager* syncManager = [SyncOperationManager shareInstance];
    self.isSynced = YES;
    //    SyncMainViewController* vc = [[SyncMainViewController alloc]initWithNibName:@"SyncMainViewController" bundle:nil];
    
    //    [self.psViewController.rootViewController.view addSubview:vc.view];
    //    vc.view.frame =  CGRectMake(0, 0, 800, 600);
    if ([syncManager isAuthoried])
    {
        SyncProgressViewController* vc = [[SyncProgressViewController alloc]initWithNibName:@"SyncProgressViewController" bundle:nil];
        syncManager.processerDelege = vc;
        syncManager.resultDelege = self;
        //UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:vc];
        //nav.view.frame = CGRectMake(0, 0, 800, 600);
        //nav.navigationBarHidden = YES;
        //PopUpViewController* pop = [[PopUpViewController alloc]initWithNavContentViewController:nav];
        SyncPopUpViewController* pop = [[SyncPopUpViewController alloc]initWithContentViewController:vc];
        pop.popUpDeleage = self;
        [pop show:self.view andAnimated:YES];
        [syncManager doSync:sender];
        [pop show:self.view andAnimated:YES];
    }
    else
    {
        self.isAuthing = YES;
        [syncManager doAuthorizeInViewController:self];
        
    }
    //[self viewDidHide:nil];
    //[self syncSuccess:nil];
    
}

- (void)onSync:(id)sender
{
    SyncOperationManager* syncManager = [SyncOperationManager shareInstance];
    self.isSynced = NO;
    //    SyncMainViewController* vc = [[SyncMainViewController alloc]initWithNibName:@"SyncMainViewController" bundle:nil];
    
    //    [self.psViewController.rootViewController.view addSubview:vc.view];
    //    vc.view.frame =  CGRectMake(0, 0, 800, 600);
    if ([syncManager isAuthoried])
    {
        SyncProgressViewController* vc = [[SyncProgressViewController alloc]initWithNibName:@"SyncProgressViewController" bundle:nil];
        syncManager.processerDelege = vc;
        syncManager.resultDelege = self;
        //UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:vc];
        //nav.view.frame = CGRectMake(0, 0, 800, 600);
        //nav.navigationBarHidden = YES;
        //PopUpViewController* pop = [[PopUpViewController alloc]initWithNavContentViewController:nav];
        SyncPopUpViewController* pop = [[SyncPopUpViewController alloc]initWithContentViewController:vc];
        pop.popUpDeleage = self;
        [pop show:self.view andAnimated:YES];
        [syncManager doUpdate:sender];
        [pop show:self.view andAnimated:YES];
    }
    else
    {
        self.isAuthing = YES;
        [syncManager doAuthorizeInViewController:self];
        
    }
    //[self viewDidHide:nil];
    //[self syncSuccess:nil];
    
}


- (void)onEmpMgr:(id)sender
{
    EmpMainSplitViewController* vc = [[EmpMainSplitViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)onProductMgr:(id)sender
{
    MainSplitViewController* vc = [[MainSplitViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onAbout:(id)sender
{
    UIViewController* vc = [[UIViewController alloc]init];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:vc animated:YES];

}

@end
