#import "HDKStringUtils.h"
#import "CommonCrypto/CommonDigest.h"

@implementation HDKStringUtils

#pragma mark - Hash

+ (NSString *)aiMd5FromString:(NSString *)source
{
    const char *cStr = [source UTF8String];
    unsigned char digest[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
	
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return  output;
}

@end
