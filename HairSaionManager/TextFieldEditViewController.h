//
//  TextFieldEditViewController.h
//  HairSaionManager
//
//  Created by chen loman on 13-1-23.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldEditViewController : UITableViewController<UITextFieldDelegate>
- (void)fillDataWithTarget:(id)target action:(SEL)action data:(NSString*)string;
@end
