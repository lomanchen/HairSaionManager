//
//  KPDirectoryInfo.h
//  KuaiPanOpenAPI
//
//  Created by Jinbo He on 12-7-20.
//  Copyright (c) 2012年 KuaiPan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPFileInfo.h"

@interface KPDirectoryInfo : NSObject {
    NSString    *root;
    NSString    *path;
    NSString    *hash;
    KPFileInfo  *fileInfo;
    NSArray     *files;     // KPFileInfo数组
}

@property(nonatomic, retain) NSString    *root;
@property(nonatomic, retain) NSString    *path;
@property(nonatomic, retain) NSString    *hash;
@property(nonatomic, retain) KPFileInfo  *fileInfo;
@property(nonatomic, retain) NSArray     *files;

@end
