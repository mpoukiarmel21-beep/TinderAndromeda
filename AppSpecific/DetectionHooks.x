#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContainerContext.h"

static BOOL tinder_bypass_active(void) {
    return [[ContainerContext shared] bypassActive];
}

%group andromeda_tinder

%hook TNDRUser
- (BOOL)isBanned { return tinder_bypass_active() ? NO : %orig; }
- (BOOL)isShadowBanned { return tinder_bypass_active() ? NO : %orig; }
- (BOOL)isSuspended { return tinder_bypass_active() ? NO : %orig; }
- (BOOL)isBlocked { return tinder_bypass_active() ? NO : %orig; }
%end

%hook TNDRSecurityManager
- (BOOL)isDeviceCompromised { return tinder_bypass_active() ? NO : %orig; }
- (BOOL)isDeviceJailbroken { return tinder_bypass_active() ? NO : %orig; }
- (BOOL)isDeviceRooted { return tinder_bypass_active() ? NO : %orig; }
- (BOOL)isJailbroken { return tinder_bypass_active() ? NO : %orig; }
- (BOOL)isRooted { return tinder_bypass_active() ? NO : %orig; }
- (BOOL)isSafeEnvironment { return tinder_bypass_active() ? YES : %orig; }
- (BOOL)hasTamperedBinaries { return tinder_bypass_active() ? NO : %orig; }
- (BOOL)isRuntimePatched { return tinder_bypass_active() ? NO : %orig; }
- (BOOL)isSubstrateLoaded { return tinder_bypass_active() ? NO : %orig; }
- (BOOL)isDebuggerPresent { return tinder_bypass_active() ? NO : %orig; }
%end

%hook TNDRDeviceIntegrity
- (BOOL)checkIntegrity { return tinder_bypass_active() ? YES : %orig; }
- (BOOL)isTampered { return tinder_bypass_active() ? NO : %orig; }
- (BOOL)hasSuspiciousLibraries { return tinder_bypass_active() ? NO : %orig; }
- (BOOL)isEmulator { return tinder_bypass_active() ? NO : %orig; }
- (BOOL)validateAppSignature { return tinder_bypass_active() ? YES : %orig; }
- (BOOL)isRuntimePatched { return tinder_bypass_active() ? NO : %orig; }
- (BOOL)isInjected { return tinder_bypass_active() ? NO : %orig; }
- (BOOL)hasJailbreakFiles { return tinder_bypass_active() ? NO : %orig; }
%end

%hook TNDRAppIntegrity
- (BOOL)isValid { return tinder_bypass_active() ? YES : %orig; }
- (BOOL)isTampered { return tinder_bypass_active() ? NO : %orig; }
- (BOOL)isSignatureValid { return tinder_bypass_active() ? YES : %orig; }
- (BOOL)checkCodeSignature { return tinder_bypass_active() ? YES : %orig; }
- (BOOL)validateCodeSignature { return tinder_bypass_active() ? YES : %orig; }
%end

%hook TNDRMetaManager
- (BOOL)hasBannedDevice { return tinder_bypass_active() ? NO : %orig; }
- (BOOL)isDeviceBlacklisted { return tinder_bypass_active() ? NO : %orig; }
- (BOOL)hasDeviceEverSignedIn { return tinder_bypass_active() ? NO : %orig; }
%end

%hook TNDRFingerprintCollector
- (NSString *)persistentDeviceID {
    if(!tinder_bypass_active()) return %orig;
    return [[ContainerContext shared] containerId] ?: @"tinder-default-0000-0000-0000-000000000000";
}
- (NSDictionary *)deviceFingerprint {
    if(!tinder_bypass_active()) return %orig;
    ContainerContext *ctx = [ContainerContext shared];
    return @{@"device_id": ctx.containerId ?: @"default", @"verified": @YES};
}
%end

%hook TNDRAuth
- (NSDate *)authTokenExpiration {
    return tinder_bypass_active() ? [NSDate distantFuture] : %orig;
}
%end

%hook TNDRGeolocation
- (void)setLatLng:(id)coords {
    if(!tinder_bypass_active()) { %orig; return; }
    %orig;
}
%end

%hook TNDRPhoneVerification
- (BOOL)isVerified {
    return tinder_bypass_active() ? YES : %orig;
}
%end

%hook IOSSecuritySuite
+ (BOOL)amIJailbroken { return tinder_bypass_active() ? NO : %orig; }
+ (BOOL)amIReverseEngineered { return tinder_bypass_active() ? NO : %orig; }
+ (BOOL)amIDebugged { return tinder_bypass_active() ? NO : %orig; }
+ (BOOL)amIProxied { return tinder_bypass_active() ? NO : %orig; }
+ (BOOL)amIManipulated { return tinder_bypass_active() ? NO : %orig; }
+ (BOOL)amIJailbrokenWithFailMessage:(id *)msg {
    if(!tinder_bypass_active()) return %orig;
    if(msg) *msg = @"";
    return NO;
}
+ (NSString *)deviceIdiomString { return tinder_bypass_active() ? @"iPhone" : %orig; }
+ (NSArray *)amIAttachedToDebugger { return tinder_bypass_active() ? @[] : %orig; }
%end

%hook flutter_jailbreak_detection
+ (BOOL)isJailBroken { return tinder_bypass_active() ? NO : %orig; }
+ (BOOL)isDebugged { return tinder_bypass_active() ? NO : %orig; }
+ (BOOL)isJailbroken { return tinder_bypass_active() ? NO : %orig; }
- (BOOL)isJailbroken { return tinder_bypass_active() ? NO : %orig; }
+ (BOOL)checkForJailbreak { return tinder_bypass_active() ? NO : %orig; }
- (BOOL)checkForJailbreak { return tinder_bypass_active() ? NO : %orig; }
+ (BOOL)isDeviceModified { return tinder_bypass_active() ? NO : %orig; }
- (BOOL)isDeviceModified { return tinder_bypass_active() ? NO : %orig; }
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
