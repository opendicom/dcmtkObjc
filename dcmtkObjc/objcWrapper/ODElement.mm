#import "NSString+opendicom.h"
#import "ODvr.h"
#import "ODElement.h"

@implementation ODElement

+(id)ODObjectWithDcm:(DcmElement*)dcm parentNode:(id)pn tagPath:(NSString*)tp
{
	return [[[[self class] alloc] initWithDcm:dcm parentNode:pn tagPath:tp] autorelease];
}

-(id)initWithDcm:(DcmElement*)dcm parentNode:(id)o tagPath:(NSString*)tp
{
	if ((self = [super init]))
    {
        dcmElement = dcm;
        tagPath=tp;
        parentNode=o;
        NSLog(@"%d%@ \"%@\" ",[self retainCount],[self debugDescription],tagPath);
        return self;
	}	
	return nil;
}

-(void)dealloc {
    NSLog(@"%d%@ \"%@\" -> dealloc",[self retainCount],[self debugDescription],tagPath);
    [super dealloc];
}

-(DcmElement*)dcmElement {
	return dcmElement;
}


-(NSString*)tagPath
{
    return tagPath;
}

/*
-(NSString*)description {
	NSMutableString* str = [NSMutableString stringWithFormat:@"%@ = %@", self.name, self.stringValue];
	unsigned int vm = _element->getVM();
	if (vm > 1)
		for (unsigned int i = 0; i < vm; ++i) {
			OFString ofstr;
			if (_element->getOFString(ofstr,i).good())
				[str appendFormat:@"[%d][%s] ", i, ofstr.c_str()];
		}
	else {
		OFString ofstr;
		if (_element->getOFString(ofstr,0).good())
			[str appendFormat:@"%s", ofstr.c_str()];
	}
	
	return str;
}

-(NSString*)name {
	return @"";// [NSString stringWithCString:DcmTag(_element->getTag()).getTagName() encoding:NSUTF8StringEncoding];
}
 */

-(DcmEVR)dcmEVR
{
    return dcmElement->ident();
}
-(NSString*)vrString
{
    switch ((int)[self dcmEVR]) {
        case  0: return @"AE";//AE title string
        case  1: return @"AS";//age string
        case  2: return @"AT";//attribute tag
        case  3: return @"CS";//code string
        case  4: return @"DA";//date string
        case  5: return @"DS";//decimal string
        case  6: return @"DT";//date time string
        case  7: return @"FL";//float single-precision
        case  8: return @"FD";//float double-precision
        case  9: return @"IS";//integer string
        case 10: return @"LO";//long string
        case 11: return @"LT";//long text
        case 12: return @"OB";//other byte
            //case 13: return @"EVR_OD";//other double
        case 13: return @"OF";//other float
            //case 15: return @"EVR_OL";//other long
        case 14: return @"OW";//other word
        case 15: return @"PN";//person name
        case 16: return @"SH";//short string
        case 17: return @"SL";//signed long
        case 18: return @"SQ";//sequence of items
        case 19: return @"SS";//signed short
        case 20: return @"ST";//short text
        case 21: return @"TM";//time string
            //case 22: return @"EVR_UC";//unlimited characters
        case 22: return @"UI";//unique identifier
        case 23: return @"UL";//unsigned long
            //case 27: return @"EVR_UR";//universal resource identifier or universal resource locator (URI/URL)
        case 24: return @"US";//unsigned short
        case 25: return @"UT";//unlimited text
        case 26: return nil;//@"EVR_ox";//OB or OW depending on context
        case 27: return nil;//@"EVR_xs";//SS or US depending on context
        case 28: return nil;//@"EVR_lt";//US, SS or OW depending on context, used for LUT Data (thus the name)
        case 29: return nil;//@"EVR_na";//na="not applicable", for data which has no VR
        case 30: return nil;//@"EVR_up";//up="unsigned pointer", used internally for DICOMDIR support
        case 31: return nil;//@"EVR_item";//used internally for items
        case 32: return nil;//@"EVR_metainfo";//used internally for meta info datasets
        case 33: return nil;//@"EVR_dataset";//used internally for datasets
        case 34: return nil;//@"EVR_fileFormat";//used internally for DICOM files
        case 35: return nil;//@"EVR_dicomDir";//used internally for DICOMDIR objects
        case 36: return nil;//@"EVR_dirRecord";//used internally for DICOMDIR records
        case 37: return nil;//@"EVR_pixelSQ";//used internally for pixel sequences in a compressed image
        case 38: return nil;//@"EVR_pixelItem";//used internally for pixel items in a compressed image
        case 39: return nil;//@"EVR_UNKNOWN";//used internally for elements with unknown VR (encoded with 4-byte length field in explicit VR)
        case 40: return @"UN";//unknown value representation
        case 41: return nil;//@"EVR_PixelData";//used internally for uncompressed pixel data
        case 42: return nil;//@"EVR_OverlayData";//used internally for overlay data
        case 43: return nil;//@"EVR_UNKNOWN2B";//used internally for elements with unknown VR with 2-byte length field in explicit VR
    }
    return nil;
}

-(UInt16)vrUInt16
{
    return [[self vrString]dicomVrShortValue];
}

-(BOOL)overwriteWithJSONValues:(NSString*)s
{
    NSDictionary *d=[s dictionaryForJSONElement];//validity check performed
    if (d) return [self overwriteWithDictionaryValues:d];
    return false;
}
-(BOOL)overwriteWithDictionaryValues:(NSDictionary*)d
{
    uint16 vrShort=[[d objectForKey:@"vr"]dicomVrShortValue];
    NSLog(@"%d",vrShort);
    NSString *n=[[d objectForKey:@"Value"]componentsJoinedByString:@"\\"];
    switch (vrShort) {
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
            return (dcmElement->putOFStringArray(OFString([n cStringUsingEncoding:NSISOLatin1StringEncoding]))).good();
//number strings
        case DS:
        case IS:
            
//number
        case FL:
            //putFloat32Array (const Float32 *vals, const unsigned long num)
        case FD:
            //putFloat64Array (const Float64 *vals, const unsigned long num)
        case SL:
            //putSint32Array (const Sint32 *vals, const unsigned long num)
        case SS:
            //putSint16Array (const Sint16 *vals, const unsigned long num)
        case UL:
            //putUint32Array (const Uint32 *vals, const unsigned long num)
        case US:
            //putUint16Array (const Uint16 *vals, const unsigned long num)
            NSLog(@"vr not implemented");
            return false;
            
            //putUint8Array (const Uint8 *vals, const unsigned long num)
            //Reimplemented in DcmPixelData, DcmOtherByteOtherWord, and DcmPolymorphOBOW

//base64
        case OB:
        case OD:
        case OF:
        case OW:
        case UN:
            NSLog(@"vr not implemented");
            return false;
 
//Attribute Tag
        case AT:
            //AT putTagVal (const DcmTagKey &attrTag, const unsigned long pos=0)
            NSLog(@"vr not implemented");
            return false;
    }
    return false;
}
-(BOOL)clearValues
{
    NSLog(@"%d%@ %@ -> clearValues",[self retainCount],[self debugDescription],tagPath);
    return (BOOL)(dcmElement->clear()).good();
}

-(void)remove
{
    NSLog(@"%d%@ %@ -> remove",[self retainCount],[self debugDescription],tagPath);
    [parentNode removeElement:[tagPath substringFromIndex:[tagPath length]-8]];
}
-(NSString*)stringValue
{
    NSLog(@"%d%@ \"%@\" -> stringValue",[self retainCount],[self debugDescription],tagPath);
    return [self stringValueWithEncodings:NSISOLatin1StringEncoding];
}

-(NSString*)stringValueWithEncodings:(NSStringEncoding)encoding{
    
    OFString ofstr;
    if (dcmElement->getOFStringArray(ofstr).good())
        return [NSString stringWithCString:ofstr.c_str() encoding:encoding];
    return nil;
}
-(NSData*)data
{
    return nil;
}
-(NSUInteger)count
{
    return 0;
}
-(NSArray*)childrenArray
{
    return nil;
}

@end



