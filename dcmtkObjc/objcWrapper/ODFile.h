#import <Foundation/Foundation.h>
#import "NSString+opendicom.h"

#import "ODMetaInfo.h"
#import "ODDataset.h"

#include "osconfig.h"
//#include "dcvr.h"
#include "dcfilefo.h"

@class ODDataset;
@class ODMetaInfo;

@interface ODFile : NSObject {
    DcmFileFormat *file;
    ODMetaInfo *metaInfo;
    ODDataset *dataset;
}

-(id)initWithFilePath:(NSString*)filePath;
-(DcmFileFormat*)file;
-(ODMetaInfo*)metaInfo;
-(ODDataset*)dataset;

@end
