#import "NSString+opendicom.h"
#import "ODvr.h"
#import "ODSequence.h"

@implementation ODSequence

+(id)ODObjectWithDcm:(DcmSequenceOfItems*)dcm parentNode:(id)pn tagPath:(NSString*)tp
{
    return [[[[self class] alloc] initWithDcm:dcm parentNode:pn tagPath:(NSString*)tp] autorelease];
}

-(id)initWithDcm:(DcmSequenceOfItems*)dcm parentNode:(id)pn tagPath:(NSString*)tp
{
	if ((self = [super init]))
    {
        _dcsequen=dcm;
        _tagPath=tp;
        _parentNode=pn;
        _items=[NSMutableDictionary dictionary];
        NSLog(@"%d%@ \"%@\" ",[self retainCount],[self debugDescription],_tagPath);
        return self;
    }
	return nil;
}

-(void)dealloc {
    NSLog(@"%d%@ \"%@\" -> dealloc",[self retainCount],[self debugDescription],_tagPath);
	[super dealloc];
}

-(DcmSequenceOfItems*)dcmSequenceOfItems {
	return _dcsequen;
}

-(NSString*)tagPath
{
    return _tagPath;
}

-(DcmEVR)dcmEVR
{
    return _dcsequen->ident();
}
-(NSString*)vrString
{
    return nil;
}
-(UInt16)vrUInt16
{
    return 0;
}


-(id)find:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:false  vr:unknownVr];
}

-(id)vr:(NSString*)vrString at:(NSString*)nodePath
{
    if ([vrString length]!=2) return nil;
    return [self find:nodePath mayCreate:true  vr:[vrString dicomVrShortValue]];
}

-(id)AEAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:AE];
}

-(id)ASAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:AS];
}

-(id)ATAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:AT];
}

-(id)CSAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:CS];
}

-(id)DAAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:DA];
}

-(id)DSAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:DS];
}

-(id)DTAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:DT];
}

-(id)FLAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:FL];
}

-(id)FDAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:FD];
}

-(id)ISAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:IS];
}

-(id)LOAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:LO];
}

-(id)LTAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:LT];
}

-(id)OBAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:OB];
}

-(id)ODAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:OD];
}

-(id)OFAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:OF];
}

-(id)OWAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:OW];
}

-(id)PNAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:PN];
}

-(id)SHAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:SH];
}

-(id)SLAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:SL];
}

-(id)SQAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:SQ];
}

-(id)SSAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:SS];
}

-(id)STAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:ST];
}

-(id)TMAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:TM];
}

-(id)UCAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:UC];
}

-(id)UIAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:UI];
}

-(id)ULAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:UL];
}

-(id)UNAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:UN];
}

-(id)URAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:UR];
}

-(id)USAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:US];
}

-(id)UTAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:UT];
}

-(id)itemAt:(NSString*)nodePath
{
    return [self find:nodePath mayCreate:true  vr:unknownVr];
}


-(id)find:(NSString*)nodePath mayCreate:(BOOL)mayCreate  vr:(uint16)vr
{
    NSString *firstNodeString=[nodePath firstNodeString];
    UInt32 card=[firstNodeString dicomTagLongValue];
    if (card==0) return nil;
    if (card>0xFFFF) return self;

    //item already registered?
    id nextNode=nil;
    nextNode=[_items objectForKey:firstNodeString];
    if (nextNode && ([nodePath length]>4)) return [nextNode find:[nodePath substringFromIndex:5] mayCreate:mayCreate vr:vr];
    if (nextNode) return nextNode;
    
    //find item
    DcmItem *nodeItem=_dcsequen->getItem(card-1);
    if (nodeItem==NULL)
    {
        if (mayCreate)
        {
            //create item(s)
        }
        return self;
    }

    //register item
    ODItem *item=[ODItem ODObjectWithDcm:(id)nodeItem parentNode:self tagPath:[NSString stringWithFormat:@"%@.%@",_tagPath,firstNodeString]];
    [_items setObject:item forKey:firstNodeString];
    
    if ([nodePath length]==4)return item;
    return [item find:[nodePath substringFromIndex:5] mayCreate:mayCreate  vr:vr];
}

-(void)removeItem:(NSString*)removeTagPath
{
    ODItem *removeODItem = (ODItem*)[_items objectForKey:removeTagPath];
    delete (_dcsequen->remove((DcmItem*)[removeODItem dcmItem]));
    [_items removeObjectForKey:removeTagPath];
    NSLog(@"%d%@ \"%@\" -> remove item %d %@ \"%@\"",[self retainCount],[self debugDescription],_tagPath,[removeODItem retainCount],[removeODItem debugDescription],removeTagPath);
}

-(void)remove
{
    NSLog(@"%d%@ \"%@\" -> remove items",[self retainCount],[self debugDescription],_tagPath);
    
    NSArray *itemKeys=[_items allKeys];
    for (NSString* key in itemKeys)
    {
        [self removeItem:key];
    }
    [_parentNode removeSequence:[_tagPath substringFromIndex:[_tagPath length]-8]];
    
}
-(NSUInteger)count
{
    return 0;
}
-(NSArray*)childrenArray
{
    NSMutableArray *mutableArray=[NSMutableArray array];
    unsigned int itemCounter=1;
    
    DcmObject* current = _dcsequen->nextInContainer(NULL);
    for( ; current; current = _dcsequen->nextInContainer( current))
    {
        NSString *tagString=[NSString stringWithFormat:@"%04x",itemCounter];
        if (![_items objectForKey:tagString]) {
            ODItem *item;
            item=[ODItem ODObjectWithDcm:(id)current parentNode:self tagPath:[NSString stringWithFormat:@"%@.%@",_tagPath,tagString]];
            [_items setObject:item forKey:tagString];
        }
        [mutableArray addObject:tagString];
    }
    return [NSArray arrayWithArray:mutableArray];
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



