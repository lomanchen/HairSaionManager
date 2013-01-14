//
//  ViewController.h
//  KuaiPanOpenAPIDemo
//
//  Created by Jinbo He on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KuaiPanOpenAPI/KuaiPanOpenAPI.h>
#import "BaseLeftSideViewController.h"
#import "DataAdapter.h"
#import "KPOperation+LCAddition.h"
#import "SyncProcessViewController.h"
#import "SyncOperationManager.h"




@interface SyncMainViewController : BaseLeftSideViewController <SyncOperationDeleage>{
    
    IBOutlet UIButton                   *_btnSync;
}

@property (nonatomic, strong)SyncProcessViewController* processViewController;
@property (nonatomic, strong)SyncOperationManager* syncManager;

- (IBAction)doSync:(id)sender;


@end


//@interface SyncMainViewController (Action)
//
//- (IBAction)doAuthorize:(id)sender;
//- (IBAction)doGetUserInfo:(id)sender;
//- (IBAction)doCreateFolder:(id)sender;
//- (IBAction)doGetDirectoryInfo:(id)sender;
//- (IBAction)doUploadFile:(id)sender;
//- (IBAction)doDownloadFile:(id)sender;
//- (IBAction)doDeleteFile:(id)sender;
//- (IBAction)doDeleteFolder:(id)sender;
//- (IBAction)doMoveFile:(id)sender;
//- (IBAction)doMoveFolder:(id)sender;
//- (IBAction)doCopyFile:(id)sender;
//- (IBAction)doCopyFolder:(id)sender;
//- (IBAction)doShareFile:(id)sender;
//- (IBAction)doCopyRefFile:(id)sender;
//- (IBAction)doCopyRefFolder:(id)sender;
//- (IBAction)doThumbnail:(id)sender;
//- (IBAction)doDocumentView:(id)sender;
//- (IBAction)doFileHistory:(id)sender;
//
//- (IBAction)doExit:(id)sender;
//- (void)push:(KPOperation*)operation;
//- (void)append:(KPOperation*)operation;
//
//- (KPOperation*)pop;
//- (void)syncSuccess;
//- (void)syncFail;
//@end
//
//
//@interface SyncMainViewController (Operations)<KPOperationDelegate>
//- (BOOL)waitForOperating:(KPOperation*)op;
//@end
