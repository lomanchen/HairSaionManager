//
//  SyncOperationManager.h
//  HairSaionManager
//
//  Created by chen loman on 13-1-10.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KuaiPanOpenAPI/KuaiPanOpenAPI.h>
#import "KPOperation+LCAddition.h"

@class SyncOperationManager;

@protocol SyncOperationDeleage <NSObject>
- (void)cancelAuth:(SyncOperationManager*)manager;
- (void)syncBegin:(SyncOperationManager*)manager;
- (void)syncSuccess:(SyncOperationManager*)manager;
- (void)syncFail:(SyncOperationManager*)manager;
- (void)syncProgressUpdate:(SyncOperationManager*)manager andProgress:(CGFloat)progress;

@end
@interface SyncOperationManager : NSObject<KPOperationDelegate>
@property (nonatomic, assign)id<SyncOperationDeleage> deleage;

@property (nonatomic, strong)NSString* lastErrorString;
@property (nonatomic, strong)NSMutableArray* retryArray;
@property (nonatomic, strong)NSString* currentSyncSerailNo;
@property (nonatomic, assign)CGFloat operationCounter;
@property (nonatomic, assign)CGFloat totalOperation;
@property (nonatomic, strong)NSMutableArray* operationQueue;
@property (nonatomic, assign)BOOL isFinish;


- (void)push:(id)operation;
- (void)append:(id)operation;
- (id)pop;
- (void)popAndPerform;


- (void)syncSuccess;
- (void)syncFail;

- (BOOL)isAuthoried;
- (void)doAuthorizeInViewController:(UIViewController*)vc;

- (void)createFolder:(NSString*)path;
- (void)uploadLocalFile:(NSString*)localPath toRemoteFilePath:(NSString*)remotePath overWrite:(BOOL)ow;
- (void)moveFileFromPath:(NSString*)fromPath toPath:(NSString*)toPath failToIgnore:(BOOL)ignore;



- (void)doSync:(id)sender;
- (void)doUpdate:(id)sender;
@end
