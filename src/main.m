#import <UIKit/UIKit.h>
#import "Ramoss4mLogin.h"

__attribute__((constructor))
static void initialize() {
    // Chama o login assim que a dylib carregar
    [Ramoss4mLogin showLoginIfNeeded];
}
