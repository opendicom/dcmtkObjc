#import <Foundation/Foundation.h>
#import "NSString+opendicom.h"

#import "ODMetaInfo.h"
#import "ODDataset.h"

#include "dcmtk/config/osconfig.h"
//#include "dcvr.h"
#include "dcmtk/dcmdata/dcfilefo.h"

@class dcfilefo;
@class ODDataset;
@class ODMetaInfo;

@interface ODFile : NSObject {
    DcmFileFormat *file;
    ODMetaInfo *metaInfo;
    ODDataset *dataset;
}

+(id)atPath:(NSString*)path;
-(id)initWithFilePath:(NSString*)filePath;
-(DcmFileFormat*)file;
-(ODMetaInfo*)metaInfo;
-(ODDataset*)dataset;

@end
