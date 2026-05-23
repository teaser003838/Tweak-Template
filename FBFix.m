#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import <objc/runtime.h>

static NSString *(*orig_bundleIdentifier)(id, SEL);
static NSString *hooked_bundleIdentifier(id self, SEL _cmd) {
    NSString *result = orig_bundleIdentifier(self, _cmd);
    if ([result hasPrefix:@"com.facebook.Facebook"]) {
        return @"com.facebook.Facebook";
    }
    return result;
}

static OSStatus (*orig_SecItemAdd)(CFDictionaryRef, CFTypeRef *);
OSStatus hooked_SecItemAdd(CFDictionaryRef attrs, CFTypeRef *result) {
    NSMutableDictionary *d = [(__bridge NSDictionary *)attrs mutableCopy];
    [d removeObjectForKey:(__bridge id)kSecAttrAccessGroup];
    return orig_SecItemAdd((__bridge CFDictionaryRef)d, result);
}

static OSStatus (*orig_SecItemCopyMatching)(CFDictionaryRef, CFTypeRef *);
OSStatus hooked_SecItemCopyMatching(CFDictionaryRef query, CFTypeRef *result) {
    NSMutableDictionary *d = [(__bridge NSDictionary *)query mutableCopy];
    [d removeObjectForKey:(__bridge id)kSecAttrAccessGroup];
    return orig_SecItemCopyMatching((__bridge CFDictionaryRef)d, result);
}

static OSStatus (*orig_SecItemUpdate)(CFDictionaryRef, CFDictionaryRef);
OSStatus hooked_SecItemUpdate(CFDictionaryRef query, CFDictionaryRef update) {
    NSMutableDictionary *d = [(__bridge NSDictionary *)query mutableCopy];
    [d removeObjectForKey:(__bridge id)kSecAttrAccessGroup];
    return orig_SecItemUpdate((__bridge CFDictionaryRef)d, update);
}

__attribute__((constructor))
static void FBFixInit(void) {
    Class cls = objc_getClass("NSBundle");
    if (cls) {
        Method m = class_getInstanceMethod(cls, @selector(bundleIdentifier));
        if (m) {
            orig_bundleIdentifier = (NSString *(*)(id, SEL))method_getImplementation(m);
            method_setImplementation(m, (IMP)hooked_bundleIdentifier);
        }
    }
    orig_SecItemAdd = SecItemAdd;
    orig_SecItemCopyMatching = SecItemCopyMatching;
    orig_SecItemUpdate = SecItemUpdate;
}
