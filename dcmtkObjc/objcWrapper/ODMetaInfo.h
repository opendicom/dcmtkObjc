#import <Foundation/Foundation.h>
#import "ODItem.h"

#include "osconfig.h"
//#include "dcvr.h"
#include "dcmetinf.h"

@interface ODMetaInfo : ODItem <ODItem>
{
    id                  _dcmetinf;
}

@end
