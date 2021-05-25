#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(InstaShare, NSObject)

RCT_EXTERN_METHOD(share:(NSString)uri
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)

@end
