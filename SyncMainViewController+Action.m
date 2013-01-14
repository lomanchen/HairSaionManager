//
//  ViewController+Action.m
//  KuaiPanOpenAPIDemo
//
//  Created by Jinbo He on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SyncMainViewController.h"
#import "SyncPopUpViewController.h"

@implementation SyncMainViewController (Action)


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.syncManager isAuthoried]) {
        NSLog(@"已经登录。。。。");
        //[self performSelectorInBackground:@selector(doSync) withObject:nil];
        
        //[self doSync:self];
    }
    else {
        NSLog(@"还没有登录。。。。");
        [self.syncManager doAuthorizeInViewController:self];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Handle events

- (IBAction)doAuthorize:(id)sender
{    
    KPConsumer *consumer = [[KPConsumer alloc] initWithKey:@"xcInFxiv9tnMmS5a" secret:@"D7JvQn0wTR5rP9D9"];
    authController = [[KPAuthController alloc] initWithConsumer:consumer];
    
    [self.navigationController pushViewController:authController animated:YES];
}



- (IBAction)doExit:(id)sender
{
    if (authController) {
        [authController clearAuthInfo];
    }
}

- (IBAction)doGetUserInfo:(id)sender
{
    _getUserInfoOp = [[KPGetUserInfoOperation alloc] initWithDelegate:self operationItem:nil];
    
    [_getUserInfoOp executeOperation];
}

- (IBAction)doCreateFolder:(id)sender
{    
    BOOL ret = [self createFolder:REMOTE_PATH_DB_FILE];
    ret = [self createFolder:REMOTE_PATH_IMG_FILE];
    NSLog(@"create folder:%@", self.lastErrorString);

}

- (BOOL)createFolder:(NSString*)path
{
    KPFolderOperationItem *item = [[KPFolderOperationItem alloc] init];
    
    item.root = @"app_folder";
    item.path = path;
    
    _createFolderOp = [[KPCreateFolderOperation alloc] initWithDelegate:self operationItem:item];
    //[_createFolderOp executeOperation];
    [self append:_createFolderOp];
//    BOOL ret = [self waitForOperating:_createFolderOp];
//    return ret;
}

- (NSString *)urlEncodeCovertString:(NSString *)source
{
    if (source==nil) {
        return @"";
    }
    
    NSMutableString *result = [NSMutableString string];
	const char *p = [source UTF8String];
	
	for(unsigned char c; (c = *p); p++) {
        
		switch(c) {
			case '0' ... '9':
			case 'A' ... 'Z':
			case 'a' ... 'z':
			case '.':
			case '-':
			case '~':
			case '_':
				[result appendFormat:@"%c", c];
				break;
			default:
				[result appendFormat:@"%%%02X", c];
		}
	}

	return result;
}

- (IBAction)doGetDirectoryInfo:(id)sender
{
    KPGetDirectoryOperationItem *item = [[KPGetDirectoryOperationItem alloc] init];
    
    item.root = @"我的照片";
    item.path = @"a相册";//@"我的音乐";
    
    item.filterExt = @"jpg,png";
    item.sortType = kSortByTime;
//    item.sortType = kSortBySize;
    
    _getDirectoryOp = [[KPGetDirectoryOperation alloc] initWithDelegate:self operationItem:item];
    [_getDirectoryOp executeOperation];
    
}


- (IBAction)doUploadFile:(id)sender
{
    
    KPUploadFileOperationItem *item = [[KPUploadFileOperationItem alloc] init];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"KPTestFile" ofType:@"jpg"];
    
    item.root = @"app_folder";
    
    //要上传到的文件夹必须已经创建，即hejinbo123文件夹必须已经存在,并且必须携带文件名
    item.path = @"KPTest/KPTestFolder/KPTestFile.jpg";
    item.fileName = @"KPTestFile.jpg";
    item.fileData = [NSData dataWithContentsOfFile:filepath];
    item.isOverwrite = YES;
    
    _uploadFileOp = [[KPUploadFileOperation alloc] initWithDelegate:self operationItem:item];
    [_uploadFileOp executeOperation];
    
}

- (void)uploadLocalFile:(NSString*)localPath toRemoteFilePath:(NSString*)remotePath overWrite:(BOOL)ow
{
    KPUploadFileOperationItem *item = [[KPUploadFileOperationItem alloc] init];
    item.root = @"app_folder";
    
    NSString* fileName = [remotePath lastPathComponent];
    
    item.path = remotePath;
    item.fileName = fileName;
    item.fileData = [NSData dataWithContentsOfFile:localPath];
    item.isOverwrite = ow;
    
    _uploadFileOp = [[KPUploadFileOperation alloc] initWithDelegate:self operationItem:item];
    //[_uploadFileOp executeOperation];
    [self append:_uploadFileOp];
    
}

- (IBAction)doDownloadFile:(id)sender
{

    
    KPFolderOperationItem *item = [[KPFolderOperationItem alloc] init];
    
    item.root = @"app_folder";
    //要下载的文件相对路径,并且必须携带文件名
    item.path = @"KPTest/KPTestFolder/KPTestFile.jpg";
    
    _downloadFileOp = [[KPDownloadFileOperation alloc] initWithDelegate:self operationItem:item];
    [_downloadFileOp executeOperation];
    
}

-(IBAction)doDeleteFile:(id)sender
{
    KPFolderOperationItem *item = [[KPFolderOperationItem alloc] init];
    
    item.root = @"app_folder";
    item.path = @"KPTest/KPDeleteFolder/KPDeleteFile.jpg";
    
    _deleteOp = [[KPDeleteOperation alloc] initWithDelegate:self operationItem:item];
    
    [_deleteOp executeOperation];
    
}

-(IBAction)doDeleteFolder:(id)sender
{
    KPFolderOperationItem *item = [[KPFolderOperationItem alloc] init];
    
    item.root = @"app_folder";
    item.path = @"KPTest/KPDeleteFolder";
    
    _deleteOp = [[KPDeleteOperation alloc] initWithDelegate:self operationItem:item];
    
    [_deleteOp executeOperation];
    
}

-(IBAction)doMoveFile:(id)sender
{
    
    KPMoveOperationItem *item = [[KPMoveOperationItem alloc] init];
    
    item.root = @"app_folder";
    item.fromPath = @"KPTest/KPMoveSourceFile.jpg";
    item.toPath = @"KPTest/KPMoveTargetFile.jpg";
    
    _moveOp = [[KPMoveOperation alloc] initWithDelegate:self operationItem:item];
    
    [_moveOp executeOperation];
    
}

- (void)moveFileFromPath:(NSString*)fromPath toPath:(NSString*)toPath failToIgnore:(BOOL)ignore
{
    KPMoveOperationItem *item = [[KPMoveOperationItem alloc] init];
    
    item.root = @"app_folder";
    item.fromPath = fromPath;
    item.toPath = toPath;
    
    _moveOp = [[KPMoveOperation alloc] initWithDelegate:self operationItem:item];
    _moveOp.failToIgnore = ignore;
    //[_moveOp executeOperation];
    [self append:_moveOp];


}

-(IBAction)doMoveFolder:(id)sender
{
    KPMoveOperationItem *item = [[KPMoveOperationItem alloc] init];
    
    item.root = @"app_folder";
    item.fromPath = @"KPTest/KPMoveSourceFolder";
    item.toPath = @"KPTest/KPMoveTargetFolder";
    
    _moveOp = [[KPMoveOperation alloc] initWithDelegate:self operationItem:item];
    
    [_moveOp executeOperation];
    
}

- (IBAction)doCopyFile:(id)sender
{
    KPCopyOperationItem *item = [[KPCopyOperationItem alloc] init];
    
    item.root = @"app_folder";
    item.fromPath = @"KPTest/KPCopySourceFile.jpg";
    item.toPath = @"KPTest/KPCopyTargetFile.jpg";
    
    _copyOp = [[KPCopyOperation alloc] initWithDelegate:self operationItem:item];
    
    [_copyOp executeOperation];
    
}

- (IBAction)doCopyFolder:(id)sender
{
    KPCopyOperationItem *item = [[KPCopyOperationItem alloc] init];
    
    item.root = @"app_folder";
    item.fromPath = @"KPTest/KPCopySourceFolder";
    item.toPath = @"KPTest/KPCopyTargetFolder";
    
    _copyOp = [[KPCopyOperation alloc] initWithDelegate:self operationItem:item];
    [_copyOp executeOperation];
    
}

- (IBAction)doShareFile:(id)sender
{
    KPGetShareLinkOperationItem *item = [[KPGetShareLinkOperationItem alloc] init];
    
    item.root = @"app_folder";
    item.name = @"123";
    item.accessCode = @"123";
    item.path = @"我的照片/2012-04-20 11.11.56_568.jpg";
    
    _shareFileOp = [[KPGetShareLinkOperation alloc] initWithDelegate:self operationItem:item];
    [_shareFileOp executeOperation];
    
}

- (IBAction)doCopyRefFile:(id)sender
{
    KPCopyOperationItem *item = [[KPCopyOperationItem alloc] init];
    
    item.root = @"app_folder";
    item.Path = @"KPTest/KPCopyRefFile.jpg";
    
    _copyRefFileOp = [[KPCopyRefOperation alloc] initWithDelegate:self operationItem:item];
    
    [_copyRefFileOp executeOperation];
    
}

- (IBAction)doCopyRefFolder:(id)sender
{
    KPCopyOperationItem *item = [[KPCopyOperationItem alloc] init];
    
    item.root = @"app_folder";
    item.Path = @"KPTest/KPCopyRefFolder";
    
    _copyRefFileOp = [[KPCopyRefOperation alloc] initWithDelegate:self operationItem:item];
    
    [_copyRefFileOp executeOperation];
    
}

- (IBAction)doThumbnail:(id)sender
{
    KPThumbnailOperationItem *item = [[KPThumbnailOperationItem alloc] init];
    
    item.root = @"app_folder";
    item.path = @"KPTest/KPTestFolder/KPTestFile.jpg";
    item.height = 123;
    item.width = 123;
    
    _thumbnailOp = [[KPThumbnailOperation alloc] initWithDelegate:self operationItem:item];
    [_thumbnailOp executeOperation];
    
}

- (IBAction)doDocumentView:(id)sender
{
    
    KPDocumentConvertOperationItem *item = [[KPDocumentConvertOperationItem alloc] init];
    
    item.root = @"app_folder";
    item.path = @"KPTest/KPDocumentConvert.pdf";
    item.documentType = kDocumentPDF;
    item.viewFormat = kViewiPad;
    item.compressType = kCompressNone;
    
    _documentConvertOp = [[KPDocumentConvertOperation alloc] initWithDelegate:self operationItem:item];
    [_documentConvertOp executeOperation];
    
}

- (IBAction)doFileHistory:(id)sender
{
    KPFolderOperationItem *item = [[KPFolderOperationItem alloc] init];
    
    item.root = @"app_folder";
    item.path = @"KPTest/KPHistory.doc";
    
    _historyOP = [[KPGetFileHistoryOperation alloc] initWithDelegate:self operationItem:item];
    [_historyOP executeOperation];
    
}


- (void)doSync:(id)sender
{
    [self.syncManager doSync:self];
//    self.operationCounter = 0;
//    //产生同步序列号
//    self.processViewController = [[SyncProcessViewController alloc]initWithNibName:@"SyncProcessViewController" bundle:nil];
//
//    SyncPopUpViewController* pvc = [[SyncPopUpViewController alloc]initWithContentViewController:self.processViewController];
//    [pvc show:self.view andAnimated:YES];
//    //[self presentModalViewController:pvc animated:YES];
//    [self.processViewController start];
//
//
//    
//    //create floder
//    //check floder
//    //if no, create floder
//    [self doCreateFolder:self];
//    
//    //upload db
//    //upload local db with temp name
//    [self uploadLocalFile:[[DataAdapter shareInstance]dbFilePath] toRemoteFilePath:[REMOTE_PATH_DB_FILE stringByAppendingPathComponent:REMOTE_PATH_DB_TEMP_FILENAME] overWrite:YES];
//    //[NSThread sleepForTimeInterval:3];
//    //upload image
//    //upload image file
//    int count = 0;
//    NSString* resourcePath;
//    for (ProductPic* pic in [DataAdapter shareInstance].productPics)
//    {
//        //[NSThread sleepForTimeInterval:2];
//        
//        resourcePath = [[DataAdapter shareInstance]getLocalPath:pic.picLink];
//        //本地自带图片不进行上传
//        if (nil != resourcePath && [resourcePath rangeOfString:@"Documents"].location == NSNotFound)
//        {
//            continue;
//        }
//        else
//        {
//            NSLog(@"sendPath:%@", resourcePath);
//            [self uploadLocalFile:resourcePath toRemoteFilePath:[REMOTE_PATH_IMG_FILE stringByAppendingPathComponent:pic.picLink] overWrite:NO];
//            NSLog(@"upload img count %d", ++count);
//        }
//    }
//    
//    //rename original db name to backup
//    NSString* dbBackUpName = [LOCAL_DB_FILE_NAME stringByAppendingPathExtension:self.currentSyncSerailNo];
//    [self moveFileFromPath:[REMOTE_PATH_DB_FILE stringByAppendingPathComponent:LOCAL_DB_FILE_NAME] toPath:[REMOTE_PATH_DB_FILE stringByAppendingPathComponent:dbBackUpName] failToIgnore:YES];
//    //rename temp db name to the right
//    [self moveFileFromPath:[REMOTE_PATH_DB_FILE stringByAppendingPathComponent:REMOTE_PATH_DB_TEMP_FILENAME] toPath:[REMOTE_PATH_DB_FILE stringByAppendingPathComponent:LOCAL_DB_FILE_NAME] failToIgnore:NO];
//    self.totalOperation = self.operationCounter;
//    
//    [((KPOperation*)self.operationQueue[0]) executeOperation];
}

- (void)push:(KPOperation*)operation
{
    [self.operationQueue insertObject:operation atIndex:0];
    self.operationCounter ++;
}

- (void)append:(KPOperation *)operation
{
    [self.operationQueue addObject:operation];
    self.operationCounter ++;
}

- (KPOperation*)pop
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

- (void)syncSuccess
{
    self.currentSyncSerailNo = [[DataAdapter shareInstance]serialNo];
    self.operationCounter = 0;
    self.totalOperation = 0;
}

- (void)syncFail
{
    [self.processViewController fail];
}


@end
