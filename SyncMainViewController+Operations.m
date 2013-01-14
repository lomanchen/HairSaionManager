//
//  ViewController+Operations.m
//  KuaiPanOpenAPIDemo
//
//  Created by Jinbo He on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SyncMainViewController.h"
#import <KuaiPanOpenAPI/KuaiPanOpenAPI.h>


@implementation SyncMainViewController (Operations)
#pragma mark - KPOperationDelegate methods

- (void)operation:(KPOperation *)operation success:(id)data
{
    if (_getUserInfoOp == operation) {
        
        KPUserInfo *info = data;
        
        NSString *msg = [NSString stringWithFormat:@"UserInfo:%d,%@,%lld,%lld,%lld",info.userID,info.userName,info.maxFileSize,info.quotaTotal,info.quotaUsed];
        self.lastErrorString = msg;
        
        
        _getUserInfoOp = nil;
    }
    else if ([operation isKindOfClass:[KPCreateFolderOperation class]]) {
        KPFolderInfo *info = data;
        
        self.lastErrorString = [NSString stringWithFormat:@"CreateFolderInfo:%@,%@,%@,%u",info.root,info.path,info.fileID];
        
        _createFolderOp = nil;
    }
    else if (_getDirectoryOp == operation) {
        
        KPDirectoryInfo *directoryInfo = data;
        
        self.lastErrorString = [NSString stringWithFormat:@"GetDirecotryInfo:%@",directoryInfo];
        
        
        _getDirectoryOp = nil;
    }
    else if ([operation isKindOfClass:[KPUploadFileOperation class]]) {
        NSString *serverReturn = data;
        self.lastErrorString = [NSString stringWithFormat:@"UploadFileInfo:%@",serverReturn];
        
        _uploadFileOp = nil;
        
    }
    else if (_downloadFileOp == operation) {
        
        //下载的文件临时存储路径，最后使用Move方法将该文件移走即操作快速又避免临时文件占用硬盘空间。
        NSString *localFilePath = data;
        self.lastErrorString = [NSString stringWithFormat:@"download file success,local path:%@",localFilePath]; 
        
        _downloadFileOp = nil;
    }
    else if (_deleteOp == operation) {
        NSString *serverReturn = data;
        self.lastErrorString = [NSString stringWithFormat:@"delete success:%@",serverReturn];
        
        _deleteOp = nil;
    }
    else if ([operation isKindOfClass:[KPUploadFileOperation class]]) {
        NSString *serverReturn = data;
        self.lastErrorString = [NSString stringWithFormat:@"move success:%@",serverReturn];
        
        _moveOp = nil;
    }
    else if (_copyOp == operation) {
        NSDictionary *serverReturn = data;
        self.lastErrorString = [NSString stringWithFormat:@"copy success:文件的id为 :%@",[serverReturn objectForKey:@"file_id"]];
        
        _copyOp = nil;
    }
    else if (_shareFileOp == operation) {
        NSDictionary *serverReturn = data;
        self.lastErrorString = [NSString stringWithFormat:@"分享链接为 :%@",[serverReturn objectForKey:@"url"]];
        
        _shareFileOp = nil;
    }
    else if (_copyRefFileOp == operation) {
        NSDictionary *serverReturn = data;
        self.lastErrorString = [NSString stringWithFormat:@"复制引用 :%@",[serverReturn objectForKey:@"copy_ref"]];
        
        _copyRefFileOp = nil;
    }
    else if (_thumbnailOp == operation) {
                
        UIImage *image = [[UIImage alloc] initWithData:data];
        
        //_imageView.image = image;
        
        _thumbnailOp = nil;
    }
    else if (_documentConvertOp == operation) {
        
        //下载的文件临时存储路径，使用完后，为了不占用空间，请将临时文件删除
        NSString *localFilePath = data;
        self.lastErrorString = [NSString stringWithFormat:@"document convert success,local path:%@",localFilePath]; 
        
        _documentConvertOp = nil;
        
    }
    else if (_historyOP == operation) {
        
        NSMutableArray *fileHistorys = data;
        
        NSMutableString *historyString = [[NSMutableString alloc] init];
        for (KPFileHistoryInfo *fileHistory in fileHistorys) {
            [historyString appendFormat:@"文件ID为：%@，文件的版本为：%@，文件的创建时间为：%@\n",fileHistory.fileId,fileHistory.version,fileHistory.createTime];
        }
        
        self.lastErrorString = [@"文件的历史版本信息---" stringByAppendingFormat:@"%@",historyString];
        
        _historyOP = nil;
    }
    //若存在，则从重试队列里删除
    [self.retryArray removeObject:operation];
    
    self.result = PROCESS_SUCCESS;
    NSLog(@"%@ success:%@", [[operation class] description], self.lastErrorString);
    [[self pop] executeOperation];
    [self.processViewController setProgress:(self.totalOperation-self.operationCounter) / self.totalOperation ];
    if (self.operationCounter == 0)
    {
        [self.processViewController finish];
        [self syncSuccess];
    }

}

- (void)operation:(KPOperation *)operation fail:(NSString *)errorMessage
{
    NSLog(@"%@ fail Message:%@",[[operation class] description], errorMessage);
    
    self.lastErrorString = errorMessage;
        
    self.result = PROCESS_FAIL;

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
        [[self pop] executeOperation];
    }
    
    [self.processViewController setProgress:(self.totalOperation-self.operationCounter) / self.totalOperation ];
    if (self.operationCounter == 0)
    {
        [self.processViewController finish];
    }

}

//- (void)operation:(KPOperation *)operation
//    totalBytesWritten:(NSInteger)totalBytesWritten 
//    totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
//{
//    CGFloat progress = (totalBytesWritten*1.0) / totalBytesExpectedToWrite;
//    _progress.progress += progress;
//    self.result = PROCESS_ON_GOING;
//}


- (BOOL)waitForOperating:(KPOperation *)op
{
    int count = 0;
    while (self.result == PROCESS_ON_GOING)
    {
        [NSThread sleepForTimeInterval:1];
        NSLog(@"%d", count++);
    }
BOOL ret = self.result == PROCESS_SUCCESS ? YES : NO;
self.result = PROCESS_ON_GOING;
NSLog(@"%@", self.lastErrorString);
return ret;
}

- (void)retry:(KPOperation*)operation
{
    NSLog(@"重试...%@", [[operation class] description]);
    [operation executeOperation];
    
}

@end
