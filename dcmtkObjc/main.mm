#import <Foundation/Foundation.h>
#import "ODFile.h"
#import "NSString+opendicom.h"
//#include "dcvr.h"

int main(int argc, const char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSMutableArray *args=[NSMutableArray arrayWithArray:[[NSProcessInfo processInfo] arguments]];
    NSLog(@"args:\r\n%@",[args description]);
    ODFile *test=[[ODFile alloc]initWithFilePath:args[1]];
    
    //NSLog(@"tagPath: %@",[[[test dataset]find:@"00100010"]tagPath]);
    //NSLog(@"tagPath: %@",[[[test dataset]SQAt:@"00081140"]tagPath]);
    id i=[[test dataset]find:@"00100010"];
    if (i) NSLog(@"%@",[i stringValue]);
    //[i overwriteWithJSONValues:args[3]];
    //NSLog(@"ELE remove SQ 00081140 start (no subnodes)");
    //[i remove];
    NSLog(@"%@",[[[[test dataset]find:@"00081140"]childrenArray]description]);
    //if (i != ii) NSLog(@"diferent node: %@",[ii debugDescription]);
    //else NSLog(@"new value: %@",[ii stringValue]);
    //NSLog(@"tagPath: %@",[[[test dataset]find:args[3]] stringValue]);
    return 0;
}
