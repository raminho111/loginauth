#import <Foundation/Foundation.h>

@interface Ramoss4mLogin : NSObject

+ (void)showLoginIfNeeded;
+ (void)validateKey:(NSString *)key completion:(void(^)(BOOL))completion;
+ (NSString *)getHWID;

@end
