#import <UIKit/UIKit.h>
#import "Ramoss4mLogin.h"

__attribute__((constructor))
static void initialize() {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
        [Ramoss4mLogin showLoginIfNeeded];
    }];
}
