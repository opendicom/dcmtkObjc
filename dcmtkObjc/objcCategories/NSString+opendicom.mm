#import "NSString+opendicom.h"

@implementation NSString (opendicom)

const unsigned long ascii2LittleHexa[71] =   {
    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
    0,   0,   0,   0,   0,   0,   0,   0,   0,   1,
    2,   3,   4,   5,   6,   7,   8,   9,   0,   0,
    0,   0,   0,   0,   0,  10,  11,  12,  13,  14,
    15
};

const unsigned long ascii2BigHexa[71] =      {
    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
    0,   0,   0,   0,   0,   0,   0,   0,   0,  16,
    32, 48,  64,  80,  96, 112, 128, 144,   0,   0,
    0,	 0,   0,   0,   0, 160, 176, 192, 208, 224,
    240
};

static NSRegularExpression *opendicomDecimalCardStringRegex=nil;
static NSRegularExpression *opendicomHexaTagStringRegex=nil;
static NSRegularExpression *opendicomUntilVrFromJSONElementRegex=nil;

//version 3.6 (without new datatypes)
static NSArray *vrs=@[
@"AE",
@"AS",
@"AT",
@"CS",
@"DA",
@"DS",
@"DT",
@"FL",
@"FD",
@"IS",
@"LO",
@"LT",
@"OB",
@"OF",
@"OW",
@"PN",
@"SH",
@"SL",
@"SQ",
@"SS",
@"ST",
@"TM",
@"UI",
@"UL",
@"US",
@"UT",
@"ox",
@"xs",
@"lt",
@"na",
@"up",
@"_i",
@"_m",
@"_d",
@"_f",
@"_e",
@"_g",
@"ps",
@"pi",
@"un",
@"UN",
@"pd",
@"_o",
@"_u"
];

-(UInt32)dicomTagLongValue{
    if (!opendicomDecimalCardStringRegex) opendicomDecimalCardStringRegex = [[NSRegularExpression regularExpressionWithPattern:@"^[0-9]{4}$" options:0 error:nil]retain];
    if (!opendicomHexaTagStringRegex) opendicomHexaTagStringRegex = [[NSRegularExpression regularExpressionWithPattern:@"^[0-9a-fA-F]{8}$" options:0 error:nil]retain];
    if ([opendicomHexaTagStringRegex numberOfMatchesInString:self options:0 range:NSMakeRange(0,[self length])]) return (UInt32)
    (((ascii2BigHexa[[self characterAtIndex:0]] + ascii2LittleHexa[[self characterAtIndex:1]]) <<  24)
    +((ascii2BigHexa[[self characterAtIndex:2]] + ascii2LittleHexa[[self characterAtIndex:3]]) <<  16)
    +((ascii2BigHexa[[self characterAtIndex:4]] + ascii2LittleHexa[[self characterAtIndex:5]]) <<   8)
    +((ascii2BigHexa[[self characterAtIndex:6]] + ascii2LittleHexa[[self characterAtIndex:7]]) <<   0)
    );
    else if ([opendicomDecimalCardStringRegex numberOfMatchesInString:self options:0 range:NSMakeRange(0,[self length])]) return (UInt32)
        [self intValue];
    return 0;
}

-(UInt16)dicomVrShortValue
{
    if ([self length]==2)
    {
        return [self characterAtIndex:0]+([self characterAtIndex:1]<<8);
    }
    return 0;
}

-(NSString*)firstNodeString
{
    NSUInteger length=[self length];
    if (length==4)return self;
    if (length<8) return 0;
    if ([self characterAtIndex:4]=='-') return [self substringToIndex:4];
    return [self substringToIndex:8];
    
}

-(NSArray*)tagPathComponents
{
    NSUInteger tagPathLength=[self length];
    if (tagPathLength%14==9) return nil;//SQ end
    if (tagPathLength%14==0) return nil;//Item end
    return [self componentsSeparatedByString:@"-"];
}

+(id)stringForDcmEVR:(int)dcmEVR
{
    switch (dcmEVR) {
        case  0: return @"EVR_AE";//AE title string
        case  1: return @"EVR_AS";//age string
        case  2: return @"EVR_AT";//attribute tag
        case  3: return @"EVR_CS";//code string
        case  4: return @"EVR_DA";//date string
        case  5: return @"EVR_DS";//decimal string
        case  6: return @"EVR_DT";//date time string
        case  7: return @"EVR_FL";//float single-precision
        case  8: return @"EVR_FD";//float double-precision
        case  9: return @"EVR_IS";//integer string
        case 10: return @"EVR_LO";//long string
        case 11: return @"EVR_LT";//long text
        case 12: return @"EVR_OB";//other byte
        //case 13: return @"EVR_OD";//other double
        case 13: return @"EVR_OF";//other float
        //case 15: return @"EVR_OL";//other long
        case 14: return @"EVR_OW";//other word
        case 15: return @"EVR_PN";//person name
        case 16: return @"EVR_SH";//short string
        case 17: return @"EVR_SL";//signed long
        case 18: return @"EVR_SQ";//sequence of items
        case 19: return @"EVR_SS";//signed short
        case 20: return @"EVR_ST";//short text
        case 21: return @"EVR_TM";//time string
        //case 22: return @"EVR_UC";//unlimited characters
        case 22: return @"EVR_UI";//unique identifier
        case 23: return @"EVR_UL";//unsigned long
        //case 27: return @"EVR_UR";//universal resource identifier or universal resource locator (URI/URL)
        case 24: return @"EVR_US";//unsigned short
        case 25: return @"EVR_UT";//unlimited text
        case 26: return @"EVR_ox";//OB or OW depending on context
        case 27: return @"EVR_xs";//SS or US depending on context
        case 28: return @"EVR_lt";//US, SS or OW depending on context, used for LUT Data (thus the name)
        case 29: return @"EVR_na";//na="not applicable", for data which has no VR
        case 30: return @"EVR_up";//up="unsigned pointer", used internally for DICOMDIR support
        case 31: return @"EVR_item";//used internally for items
        case 32: return @"EVR_metainfo";//used internally for meta info datasets
        case 33: return @"EVR_dataset";//used internally for datasets
        case 34: return @"EVR_fileFormat";//used internally for DICOM files
        case 35: return @"EVR_dicomDir";//used internally for DICOMDIR objects
        case 36: return @"EVR_dirRecord";//used internally for DICOMDIR records
        case 37: return @"EVR_pixelSQ";//used internally for pixel sequences in a compressed image
        case 38: return @"EVR_pixelItem";//used internally for pixel items in a compressed image
        case 39: return @"EVR_UNKNOWN";//used internally for elements with unknown VR (encoded with 4-byte length field in explicit VR)
        case 40: return @"EVR_UN";//unknown value representation
        case 41: return @"EVR_PixelData";//used internally for uncompressed pixel data
        case 42: return @"EVR_OverlayData";//used internally for overlay data
        case 43: return @"EVR_UNKNOWN2B";//used internally for elements with unknown VR with 2-byte length field in explicit VR
    }
    return nil;
}

/*
-(NSUInteger)dcmEVROfJSONElement
{
    if (!opendicomUntilVrFromJSONElementRegex) opendicomUntilVrFromJSONElementRegex = [[NSRegularExpression regularExpressionWithPattern:@"^\\\{\\\"vr\\\":\\\"[a-zA-Z]{2}" options:0 error:nil]retain];

    NSTextCheckingResult *vr = [opendicomUntilVrFromJSONElementRegex firstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    NSUInteger length=vr.range.length;
    //NSLog(@"vr='%@'",[self substringWithRange:NSMakeRange(length-2,2)]);
    NSUInteger i=[vrs indexOfObject:[self substringWithRange:NSMakeRange(length-2,2)]];
    if (i==NSNotFound)return 39;
    return i;
}
*/

-(NSDictionary*)dictionaryForJSONElement
{
    NSError *err=nil;
    id jsonObject=[NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&err];
    NSLog(@"%@",[jsonObject description]);
    
    if (err) return nil;
    if (![jsonObject isKindOfClass:[NSDictionary class]])return nil;

    id values=[jsonObject objectForKey:@"Value"];
    if (!values || ![values isKindOfClass:[NSArray class]])return nil;
    
    NSUInteger dcmEVR=[vrs indexOfObject:[jsonObject objectForKey:@"vr"]];
    NSLog(@"%d",dcmEVR);
    switch (dcmEVR) {
        case NSNotFound: return nil;
        case  0: return nil;// @"EVR_AE";//AE title string
        case  1: return nil;// @"EVR_AS";//age string
        case  2: return nil;// @"EVR_AT";//attribute tag
        case  3: return nil;// @"EVR_CS";//code string
        case  4: return nil;// @"EVR_DA";//date string
        case  5: return nil;// @"EVR_DS";//decimal string
        case  6: return nil;// @"EVR_DT";//date time string
        case  7: return nil;// @"EVR_FL";//float single-precision
        case  8: return nil;// @"EVR_FD";//float double-precision
        case  9: return nil;// @"EVR_IS";//integer string
        case 10: return nil;// @"EVR_LO";//long string
        case 11: return nil;// @"EVR_LT";//long text
        case 12: return nil;// @"EVR_OB";//other byte
            //case 13: return nil;// @"EVR_OD";//other double
        case 13: return nil;// @"EVR_OF";//other float
            //case 15: return nil;// @"EVR_OL";//other long
        case 14: return nil;// @"EVR_OW";//other word
        case 15: return nil;// @"EVR_PN";//person name
        case 16:
            // @"EVR_SH";//short string
            BOOL isString=true;
            for (id value in values)
            {
                isString &= [value isKindOfClass:[NSString class]];
            }
            
            if (isString) return jsonObject;
            return nil;
    }
    return nil;
}

@end
