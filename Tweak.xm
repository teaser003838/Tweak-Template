#import <UIKit/UIKit.h>

%hook NSBundle
- (NSString *)bundleIdentifier {
    NSString *orig = %orig;
    if ([orig hasPrefix:@"com.facebook.Facebook"]) {
        return @"com.facebook.Facebook";
    }
    return orig;
}
%end
