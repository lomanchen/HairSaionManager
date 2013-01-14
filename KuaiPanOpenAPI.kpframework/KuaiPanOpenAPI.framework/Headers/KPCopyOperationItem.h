//
//  KPCopyOperationItem.h
//  KuaiPanOpenAPI
//
//  Created by tabu on 12-7-19.
//  Copyright (c) 2012年 KuaiPan. All rights reserved.
//

#import "KPMoveOperationItem.h"

@interface KPCopyOperationItem : KPMoveOperationItem
{
    NSString        *fromCopyRef;
}

@property(nonatomic, retain) NSString       *fromCopyRef;

@end
