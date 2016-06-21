#import <Foundation/Foundation.h>
#import "ODItem.h"

#include "dcmtk/config/osconfig.h"
//#include "dcvr.h"
#include "dcmtk/dcmdata/dcsequen.h"
#include "dcmtk/dcmdata/dcitem.h"


@interface ODSequence : NSObject
{
    NSString            *_tagPath;
    NSMutableDictionary *_items;
    DcmSequenceOfItems  *_dcsequen;
    id                  _parentNode;
}

+(id)ODObjectWithDcm:(DcmSequenceOfItems*)dcm parentNode:(id)pn tagPath:(NSString*)tp;
-(id)initWithDcm:(DcmSequenceOfItems*)dcm parentNode:(id)pn tagPath:(NSString*)tp;
-(DcmSequenceOfItems*)dcmSequenceOfItems;
-(NSString*)tagPath;
-(DcmEVR)dcmEVR;
-(NSString*)vrString;
-(UInt16)vrUInt16;

-(id)find:(NSString*)nodePath;
//node is one of ODItem, ODElement, ODSequence
//in case node doesn´t exist, returns deepest existing node
//in case node exists, returns node
//in case tagPath is badly formed returns nil

//the following methods eventually create the node with empty value
-(id)vr:(NSString*)vrString at:(NSString*)nodePath;
-(id)AEAt:(NSString*)nodePath;
-(id)ASAt:(NSString*)nodePath;
-(id)ATAt:(NSString*)nodePath;
-(id)CSAt:(NSString*)nodePath;
-(id)DAAt:(NSString*)nodePath;
-(id)DSAt:(NSString*)nodePath;
-(id)DTAt:(NSString*)nodePath;
-(id)FLAt:(NSString*)nodePath;
-(id)FDAt:(NSString*)nodePath;
-(id)ISAt:(NSString*)nodePath;
-(id)LOAt:(NSString*)nodePath;
-(id)LTAt:(NSString*)nodePath;
-(id)OBAt:(NSString*)nodePath;
-(id)ODAt:(NSString*)nodePath;
-(id)OFAt:(NSString*)nodePath;
-(id)OWAt:(NSString*)nodePath;
-(id)PNAt:(NSString*)nodePath;
-(id)SHAt:(NSString*)nodePath;
-(id)SLAt:(NSString*)nodePath;
-(id)SQAt:(NSString*)nodePath;
-(id)SSAt:(NSString*)nodePath;
-(id)STAt:(NSString*)nodePath;
-(id)TMAt:(NSString*)nodePath;
-(id)UCAt:(NSString*)nodePath;
-(id)UIAt:(NSString*)nodePath;
-(id)ULAt:(NSString*)nodePath;
-(id)UNAt:(NSString*)nodePath;
-(id)URAt:(NSString*)nodePath;
-(id)USAt:(NSString*)nodePath;
-(id)UTAt:(NSString*)nodePath;
-(id)itemAt:(NSString*)nodePath;

-(id)find:(NSString*)nodePath mayCreate:(BOOL)mayCreate vr:(uint16)vr;
-(NSArray*)childrenArray;

-(void)removeItem:(NSString*)removeTagPath;
-(void)remove;

-(NSData*)data;
-(NSString*)stringValue;

@end
