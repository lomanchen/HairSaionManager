//
//  TypeAddViewController.h
//  HairSaionManager
//
//  Created by chen loman on 13-1-24.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductTypeItem;
@class TypeAddViewController;
@protocol TypeAddViewControllerDelege <NSObject>

- (void)saveSuccess:(TypeAddViewController*)vc andItem:(ProductTypeItem*)item;

@end
@interface TypeAddViewController : UITableViewController
@property (nonatomic, assign)id<TypeAddViewControllerDelege> delege;
- (id)initWithItem:(ProductTypeItem*)item;
- (id)initWithRootType:(NSString*)rootType;
@end
