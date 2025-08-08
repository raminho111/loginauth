#import "Ramoss4mLogin.h"
#import <UIKit/UIKit.h>

#define APP_NAME @"ramoss4m"
#define OWNER_ID @"wBOrQJSMB8"
#define APP_VERSION @"1.0"

@implementation Ramoss4mLogin

+ (void)showLoginIfNeeded {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (!keyWindow) {
            keyWindow = [UIApplication sharedApplication].windows.firstObject;
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
                [self showLoginIfNeeded]; // reaparece se vazio
                return;
            }
            
            [self validateKey:userKey completion:^(BOOL success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (success) {
                        [weakAlert dismissViewControllerAnimated:YES completion:nil];
                    } else {
                        // mostra alerta erro e reaparece login
                        UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Erro"
                                                                                            message:@"Key inválida"
                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                        [errorAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [self showLoginIfNeeded];
                        }]];
                        [keyWindow.rootViewController presentViewController:errorAlert animated:YES completion:nil];
                    }
                });
            }];
        }];
        
        [alert addAction:validateAction];
        
        [keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

+ (void)validateKey:(NSString *)key completion:(void(^)(BOOL))completion {
    NSString *hwid = [self getHWID];
    
    NSURL *url = [NSURL URLWithString:@"https://keyauth.win/api/1.2/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSDictionary *payload = @{
        @"type": @"login",
        @"key": key,
        @"hwid": hwid,
        @"name": APP_NAME,
        @"ownerid": OWNER_ID,
        @"ver": APP_VERSION
    };
    
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payload options:0 error:&err];
    if (err) {
        completion(NO);
        return;
    }
    
    request.HTTPBody = jsonData;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error || !data) {
            completion(NO);
            return;
        }
        
        NSDictionary *respJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        BOOL success = [respJson[@"success"] boolValue];
        completion(success);
    }];
    [task resume];
}

+ (NSString *)getHWID {
    // Usa identifierForVendor como HWID
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

@end
