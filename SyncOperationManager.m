//
//  SyncOperationManager.m
//  HairSaionManager
//
//  Created by chen loman on 13-1-10.
//  Copyright (c) 2013年 chen loman. All rights reserved.
//

#import "SyncOperationManager.h"
#import "DataAdapter.h"
#import "LCKPFolderOperationItem.h"

@interface SyncOperationManager()
{
    KPAuthController                    *authController;    // 授权及注册视图
}

@property (nonatomic, strong)NSMutableArray* remoteImageArray;

- (void)onCancelAuth;
@end


@implementation SyncOperationManager
@synthesize  lastErrorString, retryArray, currentSyncSerailNo, operationCounter,operationQueue, totalOperation, remoteImageArray, isFinish;


- (id)init
{
    self = [super init];
    if (self)
    {
        retryArray = [NSMutableArray array];
        operationQueue = [NSMutableArray array];
        currentSyncSerailNo = [[DataAdapter shareInstance]serialNo];
        isFinish = NO;

    }
    return self;
}

- (BOOL)isAuthoried
{
    if (authController)
    {
        return authController.isAlreadAuth;
    }
    else
    {
        return NO;
    }
}

- (void)push:(id)operation
{
    [self.operationQueue insertObject:operation atIndex:1];
    self.operationCounter ++;
    self.totalOperation ++;

}

- (void)append:(id)operation
{
    [self.operationQueue addObject:operation];
    self.operationCounter ++;
    self.totalOperation ++;

}

- (id)pop
{
    if ([self.operationQueue count] > 1)
    {
        self.operationCounter --;
        [self.operationQueue removeObjectAtIndex:0];
        return [self.operationQueue objectAtIndex:0];
    }
    else  if ([self.operationQueue count] == 1)
    {
        self.operationCounter --;
        [self.operationQueue removeObjectAtIndex:0];
        return nil;
    }
    else
    {
        return nil;
    }
}

- (void)popAndPerform
{
    id op = [self pop];
    [self.deleage  syncProgressUpdate:self andProgress:(self.totalOperation-self.operationCounter) / self.totalOperation ];

    if (op == nil)
    {
        //所有任务完成
        if ([self.operationQueue count] <= 0)
        {
            [self syncSuccess];
        }
        return;
    }
    if ([op isKindOfClass:[KPOperation class]])
    {
        [((KPOperation*)op) executeOperation];
    }
    else if ([op isKindOfClass:[NSString class]])
    {
        [self performSelector:((NSSelectorFromString(op)))];
    }
}

- (void)syncSuccess
{
    [self.deleage syncSuccess:self];
    self.currentSyncSerailNo = [[DataAdapter shareInstance]serialNo];
    [self finish];
    

}

- (void)syncFail
{
    [self.deleage syncFail:self];
    [self finish];

}

- (void)doAuthorizeInViewController:(UIViewController*)vc
{
    KPConsumer *consumer = [[KPConsumer alloc] initWithKey:@"xcInFxiv9tnMmS5a" secret:@"D7JvQn0wTR5rP9D9"];
    authController = [[KPAuthController alloc] initWithConsumer:consumer];
    [vc.navigationController pushViewController:authController animated:YES];
//    UIBarButtonItem* item = [UIBarButtonItem alloc]init
//    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"撤退" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelAuth)];
//    vc.navigationItem.leftBarButtonItem = cancelButton;
//    vc.navigationItem.rightBarButtonItem = nil;
    //[vc.navigationController.navigationItem.backBarButtonItem setAction:@selector(onCancelAuth)];
}


- (void)createFolder:(NSString*)path
{
    KPFolderOperationItem *item = [[KPFolderOperationItem alloc] init];
    
    item.root = @"app_folder";
    item.path = path;
    
    KPCreateFolderOperation* createFolderOp = [[KPCreateFolderOperation alloc] initWithDelegate:self operationItem:item];
    [self append:createFolderOp];
}

- (void)uploadLocalFile:(NSString*)localPath toRemoteFilePath:(NSString*)remotePath overWrite:(BOOL)ow popMode:(BOOL)popMode
{
    KPUploadFileOperationItem *item = [[KPUploadFileOperationItem alloc] init];
    item.root = @"app_folder";
    
    NSString* fileName = [remotePath lastPathComponent];
    
    item.path = remotePath;
    item.fileName = fileName;
    item.fileData = [NSData dataWithContentsOfFile:localPath];
    item.isOverwrite = ow;
    
    KPUploadFileOperation* _uploadFileOp = [[KPUploadFileOperation alloc] initWithDelegate:self operationItem:item];
    //[_uploadFileOp executeOperation];
    if (popMode)
    {
        [self push:_uploadFileOp];
    }
    else
    {
        [self append:_uploadFileOp];
    }
    
}

- (void)moveFileFromPath:(NSString*)fromPath toPath:(NSString*)toPath failToIgnore:(BOOL)ignore
{
    KPMoveOperationItem *item = [[KPMoveOperationItem alloc] init];
    
    item.root = @"app_folder";
    item.fromPath = fromPath;
    item.toPath = toPath;
    
    KPMoveOperation* _moveOp = [[KPMoveOperation alloc] initWithDelegate:self operationItem:item];
    _moveOp.failToIgnore = ignore;
    //[_moveOp executeOperation];
    [self append:_moveOp];
}

- (void)downloadFileFromPath:(NSString*)fromPath toPatn:(NSString*)toPath
{
    LCKPFolderOperationItem *item = [[LCKPFolderOperationItem alloc] init];
    
    item.root = @"app_folder";
    //要下载的文件相对路径,并且必须携带文件名
    item.path = fromPath;
    item.destPath = toPath;
    KPDownloadFileOperation* _downloadFileOp = [[KPDownloadFileOperation alloc] initWithDelegate:self operationItem:item];
    [self append:_downloadFileOp];
    
}

- (void)getDirectoryInfo:(NSString*)path
{
    KPGetDirectoryOperationItem *item = [[KPGetDirectoryOperationItem alloc] init];
    
    item.root = @"app_folder";
    item.path = path;//@"我的音乐";
    
    item.filterExt = @"jpg,png";
    item.sortType = kSortByTime;
    //    item.sortType = kSortBySize;
    
    KPGetDirectoryOperation* _getDirectoryOp = [[KPGetDirectoryOperation alloc] initWithDelegate:self operationItem:item];
    [self append:_getDirectoryOp];
}



- (void)doSync:(id)sender
{
    
    self.operationCounter = 0;
    
    [self.deleage syncBegin:self];
    //create floder
    //check floder
    //if no, create floder
    [self createFolder:REMOTE_PATH_DB_FILE];
    [self createFolder:REMOTE_PATH_IMG_FILE];
    //查找服务器上的图片信息
    [self getDirectoryInfo:REMOTE_PATH_IMG_FILE];
    
    
    //upload db
    //upload local db with temp name
    [self uploadLocalFile:[[DataAdapter shareInstance]dbFilePath] toRemoteFilePath:[REMOTE_PATH_DB_FILE stringByAppendingPathComponent:REMOTE_PATH_DB_TEMP_FILENAME] overWrite:YES popMode:NO];
    //[NSThread sleepForTimeInterval:3];
    //计算需要上传的图片,预支工作量10
    self.operationCounter += 10;
    self.totalOperation += 10;
    [self append:@"prepareImageToBeUpload"];
        
    //rename original db name to backup
    NSString* dbBackUpName = [LOCAL_DB_FILE_NAME stringByAppendingPathExtension:self.currentSyncSerailNo];
    [self moveFileFromPath:[REMOTE_PATH_DB_FILE stringByAppendingPathComponent:LOCAL_DB_FILE_NAME] toPath:[REMOTE_PATH_DB_FILE stringByAppendingPathComponent:dbBackUpName] failToIgnore:YES];
    //rename temp db name to the right
    [self moveFileFromPath:[REMOTE_PATH_DB_FILE stringByAppendingPathComponent:REMOTE_PATH_DB_TEMP_FILENAME] toPath:[REMOTE_PATH_DB_FILE stringByAppendingPathComponent:LOCAL_DB_FILE_NAME] failToIgnore:NO];
    self.totalOperation = self.operationCounter;
    
    [((KPOperation*)self.operationQueue[0]) executeOperation];
}

- (void)doUpdate:(id)sender
{
    self.operationCounter = 0;
    [self.deleage syncBegin:self];
    
    //download db store with temp name
    [self downloadFileFromPath:[REMOTE_PATH_DB_FILE stringByAppendingPathComponent:LOCAL_DB_FILE_NAME] toPatn:[[[DataAdapter shareInstance]dbPath] stringByAppendingPathComponent:REMOTE_PATH_DB_TEMP_FILENAME]];
    
    //reload db
    [self append:@"reloadDB"];
    /*
    
    //create floder
    //check floder
    //if no, create floder
    [self createFolder:REMOTE_PATH_DB_FILE];
    [self createFolder:REMOTE_PATH_IMG_FILE];
    
    //upload db
    //upload local db with temp name
    [self uploadLocalFile:[[DataAdapter shareInstance]dbFilePath] toRemoteFilePath:[REMOTE_PATH_DB_FILE stringByAppendingPathComponent:REMOTE_PATH_DB_TEMP_FILENAME] overWrite:YES];
    //[NSThread sleepForTimeInterval:3];
    //upload image
    //upload image file
    int count = 0;
    NSString* resourcePath;
    for (ProductPic* pic in [DataAdapter shareInstance].productPics)
    {
        //[NSThread sleepForTimeInterval:2];
        
        resourcePath = [[DataAdapter shareInstance]getLocalPath:pic.picLink];
        //本地自带图片不进行上传
        if (nil != resourcePath && [resourcePath rangeOfString:@"Documents"].location == NSNotFound)
        {
            continue;
        }
        else
        {
            NSLog(@"sendPath:%@", resourcePath);
            [self uploadLocalFile:resourcePath toRemoteFilePath:[REMOTE_PATH_IMG_FILE stringByAppendingPathComponent:pic.picLink] overWrite:NO];
            NSLog(@"upload img count %d", ++count);
        }
    }
    
    
    [self moveFileFromPath:[REMOTE_PATH_DB_FILE stringByAppendingPathComponent:LOCAL_DB_FILE_NAME] toPath:[REMOTE_PATH_DB_FILE stringByAppendingPathComponent:dbBackUpName] failToIgnore:YES];
    //rename temp db name to the right
    [self moveFileFromPath:[REMOTE_PATH_DB_FILE stringByAppendingPathComponent:REMOTE_PATH_DB_TEMP_FILENAME] toPath:[REMOTE_PATH_DB_FILE stringByAppendingPathComponent:LOCAL_DB_FILE_NAME] failToIgnore:NO];
    self.totalOperation = self.operationCounter;
    */
    
    //预估下载图片任务量为10
    self.totalOperation += 10;
    self.operationCounter += 10;
    [((KPOperation*)self.operationQueue[0]) executeOperation];
}



- (void)operation:(KPOperation *)operation success:(id)data
{
    if ([operation isKindOfClass:[KPGetUserInfoOperation class]]) {
        
        KPUserInfo *info = data;
        
        NSString *msg = [NSString stringWithFormat:@"UserInfo:%d,%@,%lld,%lld,%lld",info.userID,info.userName,info.maxFileSize,info.quotaTotal,info.quotaUsed];
        self.lastErrorString = msg;
    }
    else if ([operation isKindOfClass:[KPCreateFolderOperation class]]) {
        KPFolderInfo *info = data;
        
        self.lastErrorString = [NSString stringWithFormat:@"CreateFolderInfo:%@,%@,%@,%u",info.root,info.path,info.fileID];        
    }
    else if ([operation isKindOfClass:[KPGetDirectoryOperation class]]) {
        
        KPDirectoryInfo *directoryInfo = data;
        
        self.lastErrorString = [NSString stringWithFormat:@"GetDirecotryInfo:%@",directoryInfo];
        remoteImageArray = [NSMutableArray arrayWithCapacity:[directoryInfo.files count]];
        for (KPFileInfo* info in directoryInfo.files)
        {
            [remoteImageArray addObject:info.name];
        }
            
    }
    else if ([operation isKindOfClass:[KPUploadFileOperation class]]) {
        NSString *serverReturn = data;
        self.lastErrorString = [NSString stringWithFormat:@"UploadFileInfo:%@",serverReturn];
        

    }
    else if ([operation isKindOfClass:[KPDownloadFileOperation class]]) {
        
        //下载的文件临时存储路径，最后使用Move方法将该文件移走即操作快速又避免临时文件占用硬盘空间。
        NSString *localFilePath = data;
        LCKPFolderOperationItem* item = [operation valueForKey:@"_oprationItem"];
        [[LCFileManager shareInstance]moveFile:localFilePath toDestPath:item.destPath overWrite:YES error:nil];
        self.lastErrorString = [NSString stringWithFormat:@"download file success,local path:%@",item.destPath];
        
    }
    else if ([operation isKindOfClass:[KPDeleteOperation class]]) {
        NSString *serverReturn = data;
        self.lastErrorString = [NSString stringWithFormat:@"delete success:%@",serverReturn];
        
    }
    else if ([operation isKindOfClass:[KPMoveOperation class]]) {
        NSString *serverReturn = data;
        self.lastErrorString = [NSString stringWithFormat:@"move success:%@",serverReturn];
    }
    else if ([operation isKindOfClass:[KPCopyOperation class]]) {
        NSDictionary *serverReturn = data;
        self.lastErrorString = [NSString stringWithFormat:@"copy success:文件的id为 :%@",[serverReturn objectForKey:@"file_id"]];
        
    }
    else if ([operation isKindOfClass:[KPGetShareLinkOperation class]]) {
        NSDictionary *serverReturn = data;
        self.lastErrorString = [NSString stringWithFormat:@"分享链接为 :%@",[serverReturn objectForKey:@"url"]];        
    }
    else if ([operation isKindOfClass:[KPCopyRefOperation class]]) {
        NSDictionary *serverReturn = data;
        self.lastErrorString = [NSString stringWithFormat:@"复制引用 :%@",[serverReturn objectForKey:@"copy_ref"]];
    }
    else if ([operation isKindOfClass:[KPThumbnailOperation class]]) {
        
        UIImage *image = [[UIImage alloc] initWithData:data];
        
        //_imageView.image = image;
        
    }
    else if ([operation isKindOfClass:[KPDocumentConvertOperation class]]) {

        //下载的文件临时存储路径，使用完后，为了不占用空间，请将临时文件删除
        NSString *localFilePath = data;
        self.lastErrorString = [NSString stringWithFormat:@"document convert success,local path:%@",localFilePath];
        
        
    }
    else if ([operation isKindOfClass:[KPFileHistoryInfo class]]) {
        
        NSMutableArray *fileHistorys = data;
        
        NSMutableString *historyString = [[NSMutableString alloc] init];
        for (KPFileHistoryInfo *fileHistory in fileHistorys) {
            [historyString appendFormat:@"文件ID为：%@，文件的版本为：%@，文件的创建时间为：%@\n",fileHistory.fileId,fileHistory.version,fileHistory.createTime];
        }
        
        self.lastErrorString = [@"文件的历史版本信息---" stringByAppendingFormat:@"%@",historyString];
        
    }
    //若存在，则从重试队列里删除
    [self.retryArray removeObject:operation];
    
    NSLog(@"%@ success:%@", [[operation class] description], self.lastErrorString);
    [self popAndPerform];
    
}

- (void)operation:(KPOperation *)operation fail:(NSString *)errorMessage
{
    NSLog(@"%@ fail Message:%@",[[operation class] description], errorMessage);
    
    self.lastErrorString = errorMessage;
        
    if (operation.failToIgnore == NO && !([operation isKindOfClass:[KPUploadFileOperation class]] && [errorMessage rangeOfString:@"同名文件"].location != NSNotFound))
    {
        //若不存在，则是首次失败
        if (![self.retryArray containsObject:operation])
        {
            [self.retryArray addObject:operation];
            //进行重试
            [self performSelector:@selector(retry:) withObject:operation afterDelay:2];
        }
        //若存在，则是第二次失败
        else
        {
            //终止同步
            [self.retryArray removeObject:operation];
            [self syncFail];
            //[[self pop] executeOperation];
            
        }
    }
    else
    {
        [self popAndPerform];
    }
    
}



- (void)retry:(KPOperation*)operation
{
    NSLog(@"重试...%@", [[operation class] description]);
    [operation executeOperation];
    
}


- (void)onCancelAuth
{
    [self.deleage cancelAuth:self];
}

- (void)reloadDB
{
    [[DataAdapter shareInstance]resetDatabaseWithFile:[[[DataAdapter shareInstance]dbPath] stringByAppendingPathComponent:REMOTE_PATH_DB_TEMP_FILENAME]];
    int count = 0;
    NSString* resourcePath;
    NSString* defaultImg = [[DataAdapter shareInstance]defaultProductImg];
    for (ProductPic* pic in [DataAdapter shareInstance].productPics)
    {
        //[NSThread sleepForTimeInterval:2];
        
        resourcePath = [[DataAdapter shareInstance]getLocalPath:pic.picLink];

        //本地自带图片不进行下载
        
        if (nil == resourcePath || [resourcePath isEqualToString:defaultImg])
        {
            NSLog(@"downPath:%@", resourcePath);
            NSString  *imgPath = [[[DataAdapter shareInstance] imgPath] stringByAppendingPathComponent:pic.picLink];
            [self downloadFileFromPath:[REMOTE_PATH_IMG_FILE stringByAppendingPathComponent:pic.picLink] toPatn:imgPath];
            NSLog(@"download img count %d", ++count);
        }
        else
        {
            continue;
        }
    }
    self.operationCounter -= 10;
    self.totalOperation -= 10;

    [self append:@"backupDb"];
    [self popAndPerform];
}

- (void)backupDb
{
    //rename original db name to backup
    NSString* dbBackUpName = [LOCAL_DB_FILE_NAME stringByAppendingPathExtension:self.currentSyncSerailNo];
    [[LCFileManager shareInstance]moveFile:[[DataAdapter shareInstance]dbFilePath] toDestPath:[[[DataAdapter shareInstance]dbPath] stringByAppendingPathComponent:dbBackUpName ] overWrite:YES error:nil];
    [[LCFileManager shareInstance]moveFile:[[[DataAdapter shareInstance]dbPath] stringByAppendingPathComponent:REMOTE_PATH_DB_TEMP_FILENAME] toDestPath:[[DataAdapter shareInstance]dbFilePath] overWrite:YES error:nil];
    
    [self popAndPerform];

}


- (void)prepareImageToBeUpload
{
    //upload image
    //upload image file
    int count = 0;
    NSString* resourcePath;
    self.operationCounter -= 10;
    self.totalOperation -= 10;
    for (ProductPic* pic in [DataAdapter shareInstance].productPics)
    {
        //[NSThread sleepForTimeInterval:2];
        
        resourcePath = [[DataAdapter shareInstance]getLocalPath:pic.picLink];
        //本地自带图片不进行上传
        if ((nil != resourcePath && [resourcePath rangeOfString:@"Documents"].location == NSNotFound) || [self isImgExistInRemote:pic.picLink])
        {
            continue;
        }
        else
        {
            NSLog(@"sendPath:%@", resourcePath);
            [self uploadLocalFile:resourcePath toRemoteFilePath:[REMOTE_PATH_IMG_FILE stringByAppendingPathComponent:pic.picLink] overWrite:NO popMode:YES];
            NSLog(@"upload img count %d", ++count);
        }
    }
    [self popAndPerform];
}


- (BOOL)isImgExistInRemote:(NSString*)fileName
{
    if (self.remoteImageArray)
    {
        for (NSString* name in remoteImageArray)
        {
            if ([fileName isEqualToString:name])
            {
                return YES;
            }
        }
    }
    return NO;
}


- (void)clearAuth
{
//    if (authController) {
//        [authController clearAuthInfo];
//    }

}

- (void)finish
{
    isFinish = YES;
    [self.operationQueue removeAllObjects];
    self.operationCounter = 0;
    self.totalOperation = 0;
    [self clearAuth];

}
@end