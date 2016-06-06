#import <Foundation/Foundation.h>

#import "ODSequence.h"
#import "ODElement.h"

#include "dcmtk/config/osconfig.h"
//#include "dcvr.h"
#include "dcmtk/dcmdata/dcitem.h"
#include "dcmtk/dcmdata/dcsequen.h"
#include "dcmtk/dcmdata/dcelem.h"

@protocol ODItem
+(id)ODObjectWithDcm:(id)dcm parentNode:(id)pn tagPath:(NSString*)tp;
-(id)initWithDcm:(id)dcm parentNode:(id)pn tagPath:(NSString*)tp;
-(DcmEVR)dcmEVR;
-(NSArray*)childrenArray;
-(DcmElement*)elementForTagKey:(DcmTagKey)tk;
-(DcmSequenceOfItems*)sequenceOfItemsForTagKey:(DcmTagKey)tk;
-(BOOL)insertElement:(DcmElement*)e;
-(BOOL)insertSequenceOfIems:(DcmSequenceOfItems*)sq;
//-(void)deleteDcm;
-(void)dealloc;
@end

@interface ODItem : NSObject <ODItem> {
    NSString*            _tagPath;
    id                   _parentNode;
    id                   _receiverNode;
    NSMutableDictionary* _sequences;
    NSMutableDictionary* _elements;
    
    id                   _dcitem;//each subClass has its own _d...
}

-(DcmItem*)dcmItem;

//Designed initializer for subclasses of the node
-(id)initWithReceiverNode:(id)rn parentNode:(id)pn tagPath:(NSString*)tp;
//overridden to return nil
-(id)init;

-(NSString*)tagPath;
-(NSString*)vrString;
-(UInt16)vrUInt16;
-(NSUInteger)count;
-(NSData*)data;
-(NSString*)stringValue;

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

-(void)remove;
-(void)removeSequence:(NSString*)removeTagPath;
-(void)removeElement:(NSString*)removeTagPath;
@end
