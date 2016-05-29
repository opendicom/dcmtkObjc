#import <Foundation/Foundation.h>

@interface NSString (opendicom)

+(id)stringForDcmEVR:(int)dcmEVR;
-(UInt32)dicomTagLongValue;
-(UInt16)dicomVrShortValue;
-(NSString*)firstNodeString;
-(NSArray*)tagPathComponents;
//-(NSUInteger)dcmEVRFOfJSONElement;
-(NSDictionary*)dictionaryForJSONElement;
@end
