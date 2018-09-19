#import "HDKObjC.h"

@implementation HDKObjC

// from http://stackoverflow.com/a/39672161

+ (id)catchException:(id(^)(void))tryBlock error:(__autoreleasing NSError **)error {
    @try {
        return tryBlock();
    }
    @catch (NSException *exception) {
        NSMutableDictionary * userInfo = [NSMutableDictionary dictionaryWithDictionary:exception.userInfo];
        [userInfo setValue:exception.reason forKey:NSLocalizedDescriptionKey];
        [userInfo setValue:exception.name forKey:NSUnderlyingErrorKey];

        *error = [[NSError alloc] initWithDomain:exception.name
                                            code:0
                                        userInfo:userInfo];
        return nil;
    }
}

@end
