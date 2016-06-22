#import <Foundation/Foundation.h>
#import "NSString+opendicom.h"
#include "dcmtk/config/osconfig.h"
#include "dcmtk/dcmdata/dcvr.h"

@protocol ODObject

//=============
//instanciation
//=============
//dataset and metaInfo have ODFile es parent node and an empty string as tagPath
+(id)ODObjectWithDcmtk:(id)dcmtk parentNode:(id)pn tagPath:(NSString*)tp;
-(id)initWithDcmtk:(id)dcmtk parentNode:(id)pn tagPath:(NSString*)tp;
-(void)dealloc;

//=====================
//introspective methods
//=====================
-(NSString*)tagPath;
-(id)parentNode;
-(DcmEVR)dcmEVR;//returns dcmtk extended VRs (where items and other are also vrs)
-(NSString*)vrString;
-(UInt16)vrUInt16;

-(NSUInteger)count;//children or multivalue
-(NSArray*)childrenArray;
-(id)find:(NSString*)nodePath;
//node is one of ODItem, ODElement, ODSequence
//in case node doesn´t exist, returns deepest existing node
//in case node exists, returns node
//in case tagPath is badly formed returns nil

//=================
//insertion methods
//=================
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

//-(void)deleteDcm;
-(void)remove;

@end

@interface ODObject : NSObject {
    NSString* _tagPath;
    id        _parentNode;//parent of receiver subclass of ODObject
    id        _receiverNode;//receiver subclass instance of ODObject
    id        _dcmtk;//corresponding class in dcmtk
}

-(id)initWithReceiverNode:(id)rn dcmtk:(id)dcmtk parentNode:(id)pn tagPath:(NSString*)tp;

@end
