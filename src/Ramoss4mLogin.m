#import "Ramoss4mLogin.h"
#import <UIKit/UIKit.h>

#define APP_NAME @"ramoss4m"
#define OWNER_ID @"wBOrQJSMB8"
#define APP_VERSION @"1.0"

@implementation Ramoss4mLogin

+ (void)showLoginIfNeeded {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    keyWindow = scene.windows.firstObject;
                    break;
                }
            }
        } else {
            keyWindow = [UIApplication sharedApplication].keyWindow;
        }
        if (!keyWindow) {
            keyWindow = [UIApplication sharedApplication].windows.firstObject;
        }

        UIViewController *rootVC = keyWindow.rootViewController;
        while (rootVC.presentedViewController) {
            rootVC = rootVC.presentedViewController;
        }

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:APP_NAME
                                                                       message:@"Insira sua key"
                                                                preferredStyle:UIAlertControllerStyleAlert];

        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Key";
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
        }];

        __weak UIAlertController *weakAlert = alert;

        UIAlertAction *validateAction = [UIAlertAction actionWithTitle:@"Validar"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
            UITextField *keyField = weakAlert.textFields.firstObject;
            NSString *userKey = keyField.text;
            if (userKey.length == 0) {
                [self showLoginIfNeeded];
                return;
            }

            [self validateKey:userKey completion:^(BOOL success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (success) {
                        [weakAlert dismissViewControllerAnimated:YES completion:nil];
                    } else {
                        UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Erro"
                                                                                            message:@"Key inválida"
                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                        [errorAlert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                       style:UIAlertActionStyleCancel
                                                                     handler:^(UIAlertAction * _Nonnull action) {
                            [self showLoginIfNeeded];
                        }]];
                        [rootVC presentViewController:errorAlert animated:YES completion:nil];
                    }
                });
            }];
        }];

        [alert addAction:validateAction];

        [rootVC presentViewController:alert animated:YES completion:nil];
    });
}

// ... mantenha os outros métodos validateKey e getHWID iguais da versão anterior

@end
