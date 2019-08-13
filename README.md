# ZBeaconKit for KDDI

## Prerequisites

- `Location Always Usage` permission should be enabled(*For iBeacon Region monitoring*).
- Device Bluetooth Service should always be active(*iBeacon is one of BLE Beacon specs, it needs Bluetooth to work properly*).

## Integrating ZBeaconKit for KDDI to your iOS App.

### Adding `Location Always Usage` permission.

Add `NSLocationAlwaysUsageDescription`, `NSLocationAlwaysAndWhenInUseUsageDescription`, `NSLocationWhenInUseUsageDescription` keys into your project `info.plist`. </br>

> you can change messages.

```xml
   <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
   <string>Will you allow this app to always know your location?</string>

   <key>NSLocationAlwaysUsageDescription</key>
   <string>Will you allow this app to always know your location?</string>

   <key>NSLocationWhenInUseUsageDescription</key>
   <string>Do you allow this app to know your current location?</string>  
```

![](http://s3.ap-northeast-2.amazonaws.com/zoyi-github-assets/wiki/ZBeacon/add-location-always-usage-permission.png)

### [install](https://cocoapods.org/) `Cocoapods`
- Add below into your Podfile
```pod
target YOUR_PROJECT_TARGET do
  pod 'ZBeaconKitKDDI'
end
```
- run following code
```
pod repo update
pod install
```

### [Install](https://github.com/Carthage/Carthage/releases) `carthage`.

![](http://s3.ap-northeast-2.amazonaws.com/zoyi-github-assets/wiki/ZBeacon/install-carthage.png)

### Adding copy file run script.

- On your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script with the following contents:
```
/usr/local/bin/carthage copy-frameworks
```
and add the paths to the frameworks you want to use under “Input Files”, e.g.:
```
$(SRCROOT)/ZBeaconKitKDDI.framework
```

![](http://s3.ap-northeast-2.amazonaws.com/zoyi-github-assets/wiki/ZBeacon/add-copy-file-run-script.png)

### The last step, configure your App specific info.

#### If you are building with Swift

- Import `ZBeaconKitKDDI`, configure your App authentication information.

```swift
import ZBeaconKitKDDI
...

override func viewDidLoad() {
  super.viewDidLoad()

  let manager = Manager(
    email: "app@zoyi.co",
    authToken: "YOUR_AUTH_TOKEN",
    target: .Production // For development, use .Development
  )
  Manager.debugMode = true // For debugging
  Manager.customerId = self.generateSampleCustomerId()

  // You must start manager manually.
  manager.start()

  // And if you want to stop,
  manager.stop()
}

func generateSampleCustomerId() -> String {
  let deviceId = UIDevice.current.identifierForVendor?.uuidString
  let deviceIdWithSalt = deviceId! + "YOUR_SALT"
  return deviceIdWithSalt.hmac(.sha512, key: "YOUR_KEY_FOR_HMAC")
}

```

#### If you are building with Objective-C

- Enable `Embedded Content Contains Swift Code` flag in `Build Settings`.

![](https://s3.ap-northeast-2.amazonaws.com/zoyi-github-assets/wiki/ZBeacon/enable-embedded-content-contains-swift-code.png)

- Import `<ZBeaconKitKDDI/ZBeaconKit.h>`, configure your App authentication information.

```objective-c

- (void)viewDidLoad {
  [super viewDidLoad];

  self.manager = [[Manager alloc]
                  initWithEmail:@"xxxx@zoyi.co"
                  authToken:@"A1B2C3D4E5F6"
                  target:TargetProduction];  // For development, use TargetDevelopment

  [Manager setDebugMode:true]; // For debugging

  NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
  NSString *deviceIdWithSalt = [deviceId stringByAppendingString:@"YOUR_SALT"];
  NSString *customerId = [self hmac: deviceIdWithSalt withKey: @"YOUR_KEY_FOR_HMAC"];

  [Manager setCustomerId: customerId];

  // You must start manager manually.
  [self.manager start];

  NSLog(@"%@", [Manager customerId]);
  NSLog(@"%@", [Manager packageId]);

  // And if you want to stop,
  [self.manager stop];
}

- (NSString *) hmac: (NSString *)plaintext withKey:(NSString *)key
  {
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
      [HMAC appendFormat:@"%02x", buffer[i]];
    }
    return HMAC;
  }

```

### Deployment Target
**Note** that you must describe _deployment target_ to manager when initializing.
The deployment target depends on ZOYI's actual O2O server endpoint.

This flag is only used for mutual test with ZOYI Corp.
So most of 3rd parties does not need to change this.

Case of Swift:
```swift
// Set target as PRODUCTION
let manager = Manager(
  email: "...",
  authToken: "...",
  target: .Production
)

// Set target as DEVELOPMENT (signals can not be seen by BLE API)
let manager = Manager(
  email: "...",
  authToken: "...",
  target: .Development
)
```

Objective-C:
```objective-c
// Set target as PRODUCTION
self.manager = [[Manager alloc]
                initWithEmail:@"..."
                authToken:@"..."
                target:TargetProduction];

// Set target as DEVELOPMENT (signals can not be seen by BLE API)
self.manager = [[Manager alloc]
                initWithEmail:@"..."
                authToken:@"..."
                target:TargetDevelopment];
```
