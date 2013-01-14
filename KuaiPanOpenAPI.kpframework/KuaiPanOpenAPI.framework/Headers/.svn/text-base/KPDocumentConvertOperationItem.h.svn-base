//
//  KPDocumentViewOperationItem.h
//  KuaiPanOpenAPI
//
//  Created by tabu on 12-7-19.
//  Copyright (c) 2012年 KuaiPan. All rights reserved.
//

#import "KPFolderOperationItem.h"

typedef enum {
    kDocumentPDF,       // pdf格式
    kDocumentDOC,       // doc格式
    kDocumentWPS,       // wps格式
    kDocumentCSV,       // csv格式
    kDocumentPRN,       // prn格式
    kDocumentXLS,       // xls格式
    kDocumentET,        // et格式
    kDocumentPPT,       // ppt格式
    kDocumentDPS,       // dps格式
    kDocumentTXT,       // txt格式
    kDocumentRTF,       // rtf格式
} DocumentType;

typedef enum {
    kViewiPhone,        // iphone客户端视图
    kViewiPad,          // ipad客户端视图
} ViewFormat;

typedef enum {
    kCompressNone,      // 不压缩
    kCompressZip,       // 压缩为zip包
} CompressType;


@interface KPDocumentConvertOperationItem : KPFolderOperationItem
{
    DocumentType        documentType;
    ViewFormat          viewFormat;
    CompressType        compressType;
}

@property(nonatomic, assign) DocumentType       documentType;
@property(nonatomic, assign) ViewFormat         viewFormat;
@property(nonatomic, assign) CompressType       compressType;

@end
