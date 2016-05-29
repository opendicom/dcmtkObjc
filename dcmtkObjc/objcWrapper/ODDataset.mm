#import "ODDataset.h"

@implementation ODDataset

+(id)ODObjectWithDcm:(id)dcm parentNode:(id)pn tagPath:(NSString*)tp {
    return [[[[self class] alloc] initWithDcm:dcm parentNode:pn tagPath:tp]autorelease];
}
-(id)initWithDcm:(id)dcm parentNode:(id)pn tagPath:(NSString*)tp{
    [self initWithReceiverNode:self parentNode:pn tagPath:tp];
    if (self != nil)
    {
        _dcdatset=dcm;
        return self;
    }
    return nil;
}
-(DcmEVR)dcmEVR{
    NSLog(@"%@[%d] dcmEVR",[self debugDescription],[self retainCount]);
    return ((DcmDataset*)_dcdatset)->ident();
}
-(DcmSequenceOfItems*)sequenceOfItemsForTagKey:(DcmTagKey)tk{
    DcmSequenceOfItems *sq=NULL;
    if ((((DcmDataset*)_dcdatset)->findAndGetSequence(tk,sq,OFFalse)).good()) return sq;
    return NULL;
}
-(DcmElement*)elementForTagKey:(DcmTagKey)tk{
    DcmElement *e=NULL;
    if ((((DcmDataset*)_dcdatset)->findAndGetElement(tk,e,OFFalse)).good()) return e;
    return NULL;
}
-(BOOL)insertElement:(DcmElement*)e{
    return (((DcmDataset*)_dcdatset)->insert(e)).good();
}
-(BOOL)insertSequenceOfIems:(DcmSequenceOfItems*)sq{
    return (((DcmDataset*)_dcdatset)->insert(sq)).good();
}
-(void)deleteDcm{
    delete (DcmDataset*)_dcdatset;
}
/*
-(void)dealloc {
    NSLog(@"%d%@ \"%@\" -> dealloc",[self retainCount],[self debugDescription],_tagPath);
    [super dealloc];
}
 */
-(NSArray*)childrenArray
{
    NSMutableArray *mutableArray=[NSMutableArray array];
    
    DcmObject* current = ((DcmDataset*)_dcdatset)->nextInContainer(NULL);
    for( ; current; current = ((DcmDataset*)_dcdatset)->nextInContainer( current))
    {
        int evr=current->getVR();
        DcmTag dcmTag=current->getTag();
        NSString *tagString=[NSString stringWithFormat:@"%04x%04x",(unsigned int)(dcmTag.getGTag()),(unsigned int)(dcmTag.getETag())];
        if (evr==18)//sequence
        {
            if (![_sequences objectForKey:tagString]) {
                ODSequence *sequence;
                if ([_tagPath isEqualToString:@""]) sequence=[ODSequence ODObjectWithDcm:(dynamic_cast<DcmSequenceOfItems*>(current)) parentNode:_receiverNode tagPath:tagString];
                else sequence=[ODSequence ODObjectWithDcm:(dynamic_cast<DcmSequenceOfItems*>(current)) parentNode:_receiverNode tagPath:[NSString stringWithFormat:@"%@-%@",_tagPath,tagString]];
                [_sequences setObject:sequence forKey:tagString];
            }
        }
        else //element
        {
            if (![_elements objectForKey:tagString]){
                DcmElement *nodeElement=[_receiverNode elementForTagKey:dcmTag.getXTag()];
                ODElement *element;
                if ([_tagPath isEqualToString:@""]) element=[ODElement ODObjectWithDcm:nodeElement parentNode:_receiverNode tagPath:tagString];
                else element=[ODElement ODObjectWithDcm:nodeElement parentNode:_receiverNode tagPath:[NSString stringWithFormat:@"%@-%@",_tagPath,tagString]];
                [_elements setObject:element forKey:tagString];
            }
        }
        [mutableArray addObject:tagString];
    }
    return [NSArray arrayWithArray:mutableArray];
}

@end



