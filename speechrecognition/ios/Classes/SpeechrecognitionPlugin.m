#import "SpeechrecognitionPlugin.h"
#import <speechrecognition/speechrecognition-Swift.h>

@implementation SpeechrecognitionPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSpeechrecognitionPlugin registerWithRegistrar:registrar];
}
@end
