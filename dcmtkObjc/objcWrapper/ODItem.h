#import <Foundation/Foundation.h>
#import "ODObject.h"
#import "ODSequence.h"
#import "ODElement.h"

#include "dcmtk/config/osconfig.h"
#include "dcmtk/dcmdata/dcitem.h"
#include "dcmtk/dcmdata/dcsequen.h"
#include "dcmtk/dcmdata/dcelem.h"

@protocol ODItem
-(id)initWithReceiverNode:(id)rn dcmtk:(id)dcmtk parentNode:(id)pn tagPath:(NSString*)tp;
-(DcmElement*)elementForTagKey:(DcmTagKey)tk;
-(DcmSequenceOfItems*)sequenceOfItemsForTagKey:(DcmTagKey)tk;
-(BOOL)insertElement:(DcmElement*)e;
-(BOOL)insertSequenceOfIems:(DcmSequenceOfItems*)sq;
-(void)removeChildSequence:(NSString*)tagPath;
-(void)removeChildElement:(NSString*)tagPath;
@end

@interface ODItem : ODObject <ODObject,ODItem> {
    NSMutableDictionary* _sequences;
    NSMutableDictionary* _elements;    
}

-(DcmItem*)dcmItem;

-(NSData*)data;
-(NSString*)stringValue;

@end
