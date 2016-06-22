#import "NSString+opendicom.h"
#import "ODvr.h"
#import "ODItem.h"
//subclasses
#import "ODMetaInfo.h"
#import "ODDataset.h"

@implementation ODItem

#pragma mark preferred initialer
-(id)initWithReceiverNode:(id)rn dcmtk:(id)dcmtk parentNode:(id)pn tagPath:(NSString*)tp
{
    if (self = [super initWithReceiverNode:rn dcmtk:dcmtk parentNode:pn tagPath:tp]) {
        _sequences=[NSMutableDictionary dictionary];
        _elements=[NSMutableDictionary dictionary];
        return self;
    }
    return nil;
}

#pragma mark --
#pragma mark protocol ODObject

//=============
//instanciation
//=============

+(id)ODObjectWithDcmtk:(id)dcmtk parentNode:(id)pn tagPath:(NSString*)tp {
    return [[[[self class] alloc] initWithDcmtk:dcmtk parentNode:pn tagPath:tp]autorelease];
}
-(id)initWithDcmtk:(id)dcmtk parentNode:(id)pn tagPath:(NSString*)tp{
    [self initWithReceiverNode:self dcmtk:dcmtk parentNode:pn tagPath:tp];
    if (self != nil) return self;
    return nil;
}

-(void)dealloc {
    NSLog(@"%lu%@ \"%@\" -> dealloc",(unsigned long)[self retainCount],[self debugDescription],_tagPath);
    if (_receiverNode)[_receiverNode deleteDcm];
    [_sequences release];
    [_elements release];
    [super dealloc];
}


//=====================
//introspective methods
//=====================


-(id)parentNode{
    return _parentNode;
}

-(NSString*)tagPath{
    return _tagPath;
}

-(DcmEVR)dcmEVR{
    NSLog(@"%@[%lu] dcmEVR",[self debugDescription],(unsigned long)[self retainCount]);
    return ((DcmItem*)_dcmtk)->ident();
}

-(NSString*)vrString
{
    return [NSString stringForDcmEVR:[self dcmEVR]];
}
-(UInt16)vrUInt16
{
    return [[self vrString]dicomVrShortValue];
}

-(NSUInteger)count
{
    return ((DcmItem*)_dcmtk)->card();
}

-(NSArray*)childrenArray
{
    NSMutableArray *mutableArray=[NSMutableArray array];
    
    DcmObject* current = ((DcmItem*)_dcmtk)->nextInContainer(NULL);
    for( ; current; current = ((DcmItem*)_dcmtk)->nextInContainer( current))
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

-(id)find:(NSString*)nodePath{
    NSLog(@"find");
    return [self find:nodePath mayCreate:false  vr:unknownVr];
}
-(id)vr:(NSString*)vrString at:(NSString*)nodePath{
    if ([vrString length]!=2) return nil;
    return [self find:nodePath mayCreate:true  vr:[vrString dicomVrShortValue]];
}
-(id)AEAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:AE];
}
-(id)ASAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:AS];
}
-(id)ATAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:AT];
}
-(id)CSAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:CS];
}
-(id)DAAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:DA];
}
-(id)DSAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:DS];
}
-(id)DTAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:DT];
}
-(id)FLAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:FL];
}
-(id)FDAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:FD];
}
-(id)ISAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:IS];
}
-(id)LOAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:LO];
}
-(id)LTAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:LT];
}
-(id)OBAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:OB];
}
-(id)ODAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:OD];
}
-(id)OFAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:OF];
}
-(id)OWAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:OW];
}
-(id)PNAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:PN];
}
-(id)SHAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:SH];
}
-(id)SLAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:SL];
}
-(id)SQAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:SQ];
}
-(id)SSAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:SS];
}
-(id)STAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:ST];
}
-(id)TMAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:TM];
}
-(id)UCAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:UC];
}
-(id)UIAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:UI];
}
-(id)ULAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:UL];
}
-(id)UNAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:UN];
}
-(id)URAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:UR];
}
-(id)USAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:US];
}
-(id)UTAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:UT];
}
-(id)itemAt:(NSString*)nodePath{
    return [self find:nodePath mayCreate:true  vr:unknownVr];
}


-(id)find:(NSString*)nodePath mayCreate:(BOOL)mayCreate  vr:(uint16)vr
{
    NSString *firstNodeString = [nodePath firstNodeString];
    //already registered?
    id nextNode=nil;
    nextNode=[_elements objectForKey:firstNodeString];
    if (nextNode) return nextNode;

    nextNode=[_sequences objectForKey:firstNodeString];
    if (nextNode && ([nodePath length]>8)) return [nextNode find:[nodePath substringFromIndex:9] mayCreate:mayCreate  vr:vr];
    if (nextNode) return nextNode;
    

    //valid tag?
    UInt32 card=[firstNodeString dicomTagLongValue];
    //in case tagPath is badly formed returns nil and original tagPath
    if (card==0) return nil;
    //cannot contain item child
    if (card<0x10000) return self;
    
    //next node accesible?
    DcmElement *nodeElement=[_receiverNode elementForTagKey:DcmTagKey(card/0x10000,card%0x10000)];
    if (nodeElement==NULL)
    {
       if (!mayCreate) return self;
        
        switch (vr) {
                //string
            case AE:
            case AS:
            case CS:
            case DA:
            case DT:
            case LO:
            case LT:
            case PN:
            case SH:
            case ST:
            case TM:
            case UC:
            case UI:
            case UR:
            case UT:
                //JF nodeElement = new DcmByteString(DcmTagKey(card/0x10000,card%0x10000));
                //JF if (![_receiverNode insertElement:nodeElement])return self;
                break;
                //number strings
            case DS:
            case IS:
                //JF nodeElement = new DcmByteString(DcmTagKey(card/0x10000,card%0x10000));
                //JF if (![_receiverNode insertElement:nodeElement])return self;
                break;
                
                //number
            case FL:
                nodeElement = new DcmFloatingPointSingle(DcmTagKey(card/0x10000,card%0x10000));
                if (![_receiverNode insertElement:nodeElement])return self;
                break;
            case FD:
                nodeElement = new DcmFloatingPointDouble(DcmTagKey(card/0x10000,card%0x10000));
                if (![_receiverNode insertElement:nodeElement])return self;
                break;
            case SL:
                nodeElement = new DcmSignedLong(DcmTagKey(card/0x10000,card%0x10000));
                if (![_receiverNode insertElement:nodeElement])return self;
                break;
            case SS:
                nodeElement = new DcmSignedShort(DcmTagKey(card/0x10000,card%0x10000));
                if (![_receiverNode insertElement:nodeElement])return self;
                break;
            case UL:
                nodeElement = new DcmUnsignedLong(DcmTagKey(card/0x10000,card%0x10000));
                if (![_receiverNode insertElement:nodeElement])return self;
                break;
            case US:
                nodeElement = new DcmUnsignedShort(DcmTagKey(card/0x10000,card%0x10000));
                if (![_receiverNode insertElement:nodeElement])return self;
                break;
                
                //putUint8Array (const Uint8 *vals, const unsigned long num)
                //Reimplemented in DcmPixelData, DcmOtherByteOtherWord, and DcmPolymorphOBOW
                
                //base64
            case OB:
            case OD:
            case OF:
            case OW:
            case UN:
                NSLog(@"vr not implemented");
                return nil;
                
                //Attribute Tag
            case AT:
                //AT putTagVal (const DcmTagKey &attrTag, const unsigned long pos=0)
                NSLog(@"vr not implemented");
                return nil;
                
            case SQ:
                DcmSequenceOfItems *newDcmSequenceOfItems = new DcmSequenceOfItems(DcmTagKey(card/0x10000,card%0x10000));
                if (![_receiverNode insertSequenceOfIems:newDcmSequenceOfItems])return self;
                nodeElement=newDcmSequenceOfItems;
                break;
        }
    }
    
    if (nodeElement->ident()==18)//is sequence
    {
        ODSequence *sequence;
        if ([_tagPath isEqualToString:@""]) sequence=[ODSequence ODObjectWithDcm:(dynamic_cast<DcmSequenceOfItems*>(nodeElement)) parentNode:_receiverNode tagPath:firstNodeString];
        else sequence=[ODSequence ODObjectWithDcm:(dynamic_cast<DcmSequenceOfItems*>(nodeElement)) parentNode:_receiverNode tagPath:[NSString stringWithFormat:@"%@-%@",_tagPath,firstNodeString]];
        [_sequences setObject:sequence forKey:firstNodeString];
        if ([nodePath length]==8) return sequence;
        return [sequence find:[nodePath substringFromIndex:9] mayCreate:mayCreate vr:vr];
    }
    //isElement NSLog(@"element %d",nodeElement->ident());
    ODElement *element=nil;
    if ([_tagPath isEqualToString:@""]) element=[ODElement ODObjectWithDcm:nodeElement parentNode:_receiverNode tagPath:firstNodeString];
    else element=[ODElement ODObjectWithDcm:nodeElement parentNode:_receiverNode tagPath:[NSString stringWithFormat:@"%@-%@",_tagPath,firstNodeString]];
    [_elements setObject:element forKey:firstNodeString];
    return element;
}

//=================================================

#pragma mark protocol ODitem

-(void)removeChildElement:(NSString*)tagPath
{
    ODElement *removeODElement = (ODElement*)[_elements objectForKey:tagPath];
    [_receiverNode deleteDcm];
    [_elements removeObjectForKey:tagPath];
    NSLog(@"%d%@ \"%@\" removeElement  %d%@ \"%@\"",[self retainCount],[self debugDescription],_tagPath,[removeODElement retainCount],[removeODElement debugDescription],tagPath);
    [removeODElement release];
}

-(void)removeChildSequence:(NSString*)tagPath
{
    ODSequence *removeODSequence = (ODSequence*)[_sequences objectForKey:tagPath];
    [_receiverNode deleteDcm];
    [_sequences removeObjectForKey:tagPath];
    NSLog(@"%d%@ \"%@\" removeSequence  %d%@ \"%@\"",[self retainCount],[self debugDescription],_tagPath,[removeODSequence retainCount],[removeODSequence debugDescription],tagPath);
    [removeODSequence release];
}

-(void)remove
{
    NSLog(@"%lu%@ \"%@\" remove",(unsigned long)[self retainCount],[self debugDescription],_tagPath);
    
    NSArray *elementKeys=[_elements allKeys];
    for (NSString* key in elementKeys)
    {
        [self removeElement:key];
    }
 
    
    NSArray *sequenceKeys=[_elements allKeys];
    for (NSString* key in sequenceKeys)
    {
        [self removeElement:key];
    }
    
    [_parentNode removeItem:[_tagPath substringFromIndex:[_tagPath length]-4]];

}


-(DcmSequenceOfItems*)sequenceOfItemsForTagKey:(DcmTagKey)tk{
    DcmSequenceOfItems *sq=NULL;
    if ((((DcmItem*)_dcmtk)->findAndGetSequence(tk,sq,OFFalse)).good()) return sq;
    return NULL;
}
-(DcmElement*)elementForTagKey:(DcmTagKey)tk{
    DcmElement *e=NULL;
    if ((((DcmItem*)_dcmtk)->findAndGetElement(tk,e,OFFalse)).good()) return e;
    return NULL;
}
-(BOOL)insertElement:(DcmElement*)e{
    return (((DcmItem*)_dcmtk)->insert(e)).good();
}
-(BOOL)insertSequenceOfIems:(DcmSequenceOfItems*)sq{
    return (((DcmItem*)_dcmtk)->insert(sq)).good();
}
-(void)deleteDcm{
    delete (DcmItem*)_dcmtk;
}




-(DcmItem*)dcmItem{
    if ([_receiverNode class]==[ODItem class]) return (DcmItem*)_dcmtk;
    return nil;
}


-(NSData*)data
{
    return nil;
}
-(NSString*)stringValue
{
    return nil;
}

@end



