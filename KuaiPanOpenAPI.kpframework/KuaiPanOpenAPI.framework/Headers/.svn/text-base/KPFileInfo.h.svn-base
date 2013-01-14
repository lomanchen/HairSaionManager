//
//  KPFileInfo.h
//  KuaiPanOpenAPI
//
//  Created by Jinbo He on 12-7-20.
//  Copyright (c) 2012年 KuaiPan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kTypeFile = 0,
    kTypeFolder,
}FileType;

@interface KPFileInfo : NSObject {
    NSString    *fileID;
    NSString    *name;
    NSString    *version;
    NSString    *createTime;
    NSString    *modifyTime;
    FileType    type;
    NSUInteger  size;
    BOOL        isDeleted;
}

@property(nonatomic, retain) NSString    *fileID;
@property(nonatomic, retain) NSString    *name;
@property(nonatomic, retain) NSString    *version;
@property(nonatomic, retain) NSString    *createTime;
@property(nonatomic, retain) NSString    *modifyTime;
@property(nonatomic, assign) FileType    type;
@property(nonatomic, assign) NSUInteger  size;
@property(nonatomic, assign) BOOL        isDeleted;

@end
