#import <Foundation/Foundation.h>

@interface HDKObjC : NSObject

+ (id)catchException:(id(^)())tryBlock error:(__autoreleasing NSError **)error;

@end
