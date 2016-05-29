#import "ODFile.h"

@implementation ODFile

- (id) initWithFilePath:(NSString*)filePath
{
	if ((self = [super init])) {
        file = new DcmFileFormat();
        if ((file->loadFile(
                     filePath.UTF8String,
                     EXS_Unknown,
                     EGL_noChange,
                     DCM_MaxReadLength,
                     ERM_autoDetect
                     )).good())
        {
            dataset=[ODDataset ODObjectWithDcm:(id)(file->getDataset()) parentNode:self tagPath:@""];
            //metaInfo=[ODMetaInfo ODObjectWithDcm:(id)(file->getMetaInfo()) parentNode:self tagPath:@""];
            return self;
        }
    }
    return nil;
}

- (void) dealloc
{
    delete file;
    file = nil;
    [dataset release];
    [metaInfo release];
    [super dealloc];
}

-(DcmFileFormat*)file
{
    return file;
}


-(ODMetaInfo*)metaInfo
{
    return metaInfo;
}


-(ODDataset*)dataset
{
    return dataset;
}

@end
