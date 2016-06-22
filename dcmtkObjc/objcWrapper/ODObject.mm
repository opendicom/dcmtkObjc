#import "ODObject.h"

@implementation ODObject

-(id)initWithReceiverNode:(id)rn dcmtk:(id)dcmtk parentNode:(id)pn tagPath:(NSString*)tp
{
    if (self = [super init]) {
        _tagPath=tp;
        _parentNode=pn;
        _receiverNode=rn;
        _dcmtk=dcmtk;
        NSLog(@"%lu%@ \"%@\" ",(unsigned long)[self retainCount],[self debugDescription],_tagPath);
        return self;
    }
    return nil;
}

-(void)dealloc {
    [_tagPath release];
    [_parentNode release];
    [super dealloc];
}

@end
