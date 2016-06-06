#import <Foundation/Foundation.h>
#import "ODItem.h"

#include "dcmtk/config/osconfig.h"
//#include "dcvr.h"
#include "dcmtk/dcmdata/dcmetinf.h"

@interface ODMetaInfo : ODItem <ODItem>
{
    id                  _dcmetinf;
}

@end
