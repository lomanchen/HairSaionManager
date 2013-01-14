//
//  KPFolderOperationItem.h
//  KuaiPanOpenAPI
//
//  Created by Jinbo He on 12-7-17.
//  Copyright (c) 2012年 KuaiPan. All rights reserved.
//

#import "KPFolderOperationItem.h"

@interface KPUploadFileOperationItem : KPFolderOperationItem {
    BOOL        isOverwrite;    // 是否覆盖原文件标志
    NSString    *fileName;      // 上传到服务端的文件名
    NSData      *fileData;      // 文件数据
}

@property(nonatomic, assign) BOOL        isOverwrite;
@property(nonatomic, retain) NSString    *fileName;
@property(nonatomic, retain) NSData      *fileData;

@end
