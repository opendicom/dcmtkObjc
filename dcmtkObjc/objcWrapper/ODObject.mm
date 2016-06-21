#import "ODObject.h"

@implementation ODObject

-(id)initWithReceiverNode:(id)rn dcmtk:(id)dcmtk parentNode:(id)pn tagPath:(NSString*)tp
{
    if (self = [super init]) {
        _tagPath=tp;
        _parentNode=pn;
        _receiverNode=rn;
        _dcmtk=dcmtk;
        NSLog(@"%d%@ \"%@\" ",[self retainCount],[self debugDescription],_tagPath);
        return self;
    }
    return nil;
}


@end
