#import <Foundation/Foundation.h>

#import "ODItem.h"
#include "dcmtk/config/osconfig.h"
#include "dcmtk/dcmdata/dcvr.h"
#include "dcmtk/dcmdata/dcelem.h"

@interface ODElement : NSObject
{
    NSString        *tagPath;
    DcmElement      *dcmElement;
    id              parentNode;
}

+(id)ODObjectWithDcm:(DcmElement*)dcm parentNode:(id)pn tagPath:(NSString*)tp;
-(id)initWithDcm:(DcmElement*)dcm parentNode:(id)pn tagPath:(NSString*)tp;
-(DcmElement*)dcmElement;
-(NSString*)tagPath;
-(DcmEVR)dcmEVR;
-(NSString*)vrString;
-(UInt16)vrUInt16;
-(BOOL)clearValues;
-(BOOL)overwriteWithJSONValues:(NSString*)s;
-(BOOL)overwriteWithDictionaryValues:(NSDictionary*)d;
-(void)remove;
-(NSUInteger)count;
-(NSArray*)childrenArray;
-(NSData*)data;
-(NSString*)stringValue;
-(NSString*)stringValueWithEncodings:(NSStringEncoding)encoding;

@end
