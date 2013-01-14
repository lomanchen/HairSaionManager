//
//  KPOperation.h
//  KuaiPanOpenAPI
//
//  Created by Jinbo He on 12-7-12.
//  Copyright (c) 2012年 KuaiPan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KPOperationDelegate;
@class KPOperationItem;

@interface KPOperation : NSObject {
    id<KPOperationDelegate>     _delegate;
    KPOperationItem             *_oprationItem;
}

- (id)initWithDelegate:(id<KPOperationDelegate>)delegate 
         operationItem:(KPOperationItem *)opItem;
- (void)executeOperation;
- (void)cancelOperation;

@end


@protocol KPOperationDelegate <NSObject>

@optional
- (void)operation:(KPOperation *)operation success:(id)data;
- (void)operation:(KPOperation *)operation fail:(NSString *)errorMessage;

/*
 * 上传、下载进度回调函数
 * totalBytesWritten：已经上传或下载的字节数
 * totalBytesExpectedToWrite：要上传或下载的总字节数
 */
- (void)operation:(KPOperation *)operation 
    totalBytesWritten:(NSInteger)totalBytesWritten 
    totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite; 

@end