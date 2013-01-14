//
//  KPDownloadFileOperation.h
//  KuaiPanOpenAPI
//
//  Created by Jinbo He on 12-7-18.
//  Copyright (c) 2012年 KuaiPan. All rights reserved.
//

#import "KPNetworkOperation.h"

@interface KPDownloadFileOperation : KPNetworkOperation {
    NSInteger       _totalBytes;        // 从服务器下载的文件总字节数
    NSInteger       _downloadBytes;     // 已经下载到本地的字节数
    NSString        *_tempFilePath;     // 下载的文件临时保存路径
    
    NSOutputStream  *_outputStream;     // 写文件流
}

@end
