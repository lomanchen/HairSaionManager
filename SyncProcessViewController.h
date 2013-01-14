//
//  SyncProcessViewController.h
//  HairSaionManager
//
//  Created by chen loman on 13-1-10.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import "PopUpSubViewController.h"

@interface SyncProcessViewController : PopUpSubViewController
{
    IBOutlet UIActivityIndicatorView    *_activity;
    IBOutlet UIProgressView             *_progress;
    IBOutlet UILabel                    *_state;

}

- (void)start;
- (void)finish;
- (void)fail;
- (void)setProgress:(CGFloat)progress;
- (CGFloat)progress;
@end
