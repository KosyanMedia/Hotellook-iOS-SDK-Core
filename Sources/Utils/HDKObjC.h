#import <Foundation/Foundation.h>

@interface HDKObjC : NSObject

+ (id)catchException:(id(^)(void))tryBlock error:(__autoreleasing NSError **)error;

@end
