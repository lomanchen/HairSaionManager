//
//  KPGetDirectoryOperationItem.h
//  KuaiPanOpenAPI
//
//  Created by Jinbo He on 12-7-19.
//  Copyright (c) 2012年 KuaiPan. All rights reserved.
//

#import "KPFolderOperationItem.h"

typedef enum {
    kSortByNone = 0,// 不排序
    kSortByTime,    // 按修改时间
    kSortByName,    // 按文件名
    kSortBySize,    // 按大小
}SortType;

@interface KPGetDirectoryOperationItem : KPFolderOperationItem {
    BOOL        isList; 
    NSInteger   fileLimit;
    NSInteger   pageIndex;
    NSInteger   pageSize;
    NSString    *filterExt;
    SortType    sortType;   // 在pageIndex!=0时才有效
    BOOL        isDescSort; // 是否倒序排列
}

@property(nonatomic, assign) BOOL        isList; 
@property(nonatomic, assign) NSInteger   fileLimit;
@property(nonatomic, assign) NSInteger   pageIndex;
@property(nonatomic, assign) NSInteger   pageSize;
@property(nonatomic, retain) NSString    *filterExt;
@property(nonatomic, assign) SortType    sortType;
@property(nonatomic, assign) BOOL        isDescSort; 

@end
