//
//  ProductTypeSelectorViewController.h
//  HairSaionManager
//
//  Created by chen loman on 13-1-25.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductTypeItem;
@interface ProductTypeSelectorViewController : UITableViewController
- (id)initWithItem:(ProductTypeItem*)item;
- (id)initWithProductTypeId:(NSString*)productTypeId target:(id)target action:(SEL)action;
@end
