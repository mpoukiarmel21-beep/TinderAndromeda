#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContainerContext.h"

%config(generator=internal)

static BOOL tinder_bypass_active(void) {
    return [[ContainerContext shared] bypassActive];
}

%group andromeda_tinder

%hook TNDRUser
- (BOOL)isBanned {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
- (BOOL)isShadowBanned {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
- (BOOL)isSuspended {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
- (BOOL)isBlocked {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
%end

%hook TNDRSecurityManager
- (BOOL)isDeviceCompromised {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
- (BOOL)isDeviceJailbroken {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
- (BOOL)isDeviceRooted {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
- (BOOL)isJailbroken {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
- (BOOL)isRooted {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
- (BOOL)isSafeEnvironment {
    if(!tinder_bypass_active()) return %orig;
    return YES;
}
- (BOOL)hasTamperedBinaries {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
- (BOOL)isRuntimePatched {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
%end

%hook TNDRDeviceIntegrity
- (BOOL)checkIntegrity {
    if(!tinder_bypass_active()) return %orig;
    return YES;
}
- (BOOL)isTampered {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
- (BOOL)hasSuspiciousLibraries {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
- (BOOL)isEmulator {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
- (BOOL)validateAppSignature {
    if(!tinder_bypass_active()) return %orig;
    return YES;
}
- (BOOL)isRuntimePatched {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
- (BOOL)isInjected {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
- (BOOL)hasJailbreakFiles {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
%end

%hook TNDRAppIntegrity
- (BOOL)isValid {
    if(!tinder_bypass_active()) return %orig;
    return YES;
}
- (BOOL)isTampered {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
- (BOOL)isSignatureValid {
    if(!tinder_bypass_active()) return %orig;
    return YES;
}
- (BOOL)checkCodeSignature {
    if(!tinder_bypass_active()) return %orig;
    return YES;
}
- (BOOL)validateCodeSignature {
    if(!tinder_bypass_active()) return %orig;
    return YES;
}
%end

%hook TNDRMetaManager
- (BOOL)hasBannedDevice {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
- (BOOL)isDeviceBlacklisted {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
- (BOOL)hasDeviceEverSignedIn {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
%end

%hook TNDRFingerprintCollector
- (NSString *)persistentDeviceID {
    if(!tinder_bypass_active()) return %orig;
    NSString *cid = [[ContainerContext shared] containerId];
    if(cid) return cid;
    return @"tinder-default-device-id";
}
- (NSDictionary *)deviceFingerprint {
    if(!tinder_bypass_active()) return %orig;
    return @{};
}
%end

%hook TNDRAuth
- (NSDate *)authTokenExpiration {
    if(!tinder_bypass_active()) return %orig;
    return [NSDate distantFuture];
}
%end

%hook TNDRGeolocation
- (void)setLatLng:(id)coords {
    if(!tinder_bypass_active()) {
        %orig;
        return;
    }
    %orig;
}
%end

%hook TNDRPhoneVerification
- (BOOL)isVerified {
    if(!tinder_bypass_active()) return %orig;
    return YES;
}
%end

%hook IOSSecuritySuite
+ (BOOL)amIJailbroken {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
+ (BOOL)amIReverseEngineered {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
+ (BOOL)amIDebugged {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
+ (BOOL)amIProxied {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
+ (BOOL)amIManipulated {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
+ (BOOL)amIJailbrokenWithFailMessage:(id *)msg {
    if(!tinder_bypass_active()) return %orig;
    if(msg) *msg = @"";
    return NO;
}
+ (NSString *)deviceIdiomString {
    if(!tinder_bypass_active()) return %orig;
    return @"iPhone";
}
+ (NSArray *)amIAttachedToDebugger {
    if(!tinder_bypass_active()) return %orig;
    return @[];
}
%end

%hook flutter_jailbreak_detection
+ (BOOL)isJailBroken {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
+ (BOOL)isDebugged {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
+ (BOOL)isJailbroken {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
- (BOOL)isJailbroken {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
+ (BOOL)checkForJailbreak {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
- (BOOL)checkForJailbreak {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
+ (BOOL)isDeviceModified {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
- (BOOL)isDeviceModified {
    if(!tinder_bypass_active()) return %orig;
    return NO;
}
%end

%end

%ctor {
    @try {
        %init(andromeda_tinder);
        NSLog(@"[Andromeda] Tinder detection hooks installed");
    } @catch(NSException *e) {
        NSLog(@"[Andromeda] Tinder hooks error: %@", e);
    }
}
