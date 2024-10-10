# Koodall Agora Plugin Filters IOS
[![](https://www.koodall.ai/media/images/logo/logo-color.svg)](https://www.koodall.ai/)


Examples for Koodall SDK on iOS and [Agora.io](https://www.agora.io/en/) SDK integration via Agora Plugin Filters to enhance video calls with real-time face filters and virtual backgrounds.

# Getting Started

## Prerequisites

1. Visit agora.io to sign up and get the app id, client token and channel id. Please consult with [Agora documentation about account management](https://docs.agora.io/en/voice-calling/reference/manage-agora-account) to find out exactly how mentioned IDs are created.

2. Activate the [Koodall Face AR SDK extension](https://console.agora.io/marketplace/extension/introduce?serviceName=koodall). Our sales representatives will provide you the license token used by extension. Please check out the [extension integration documentation](https://docs.agora.io/en/video-calling/develop/use-an-extension?platform=ios) if you have any questions regarding this step.

## Dependencies

|                             | Version |                    Description                    | 
|-----------------------------|:-------:|:-------------------------------------------------:|
| AgoraRtcEngine_iOS/RtcBasic |  4.2.0  |               Agora RTC dependency                |
| Koodall                   |  1.7.0  | Koodall Face AR dependency for applying AR filters |
| KoodallFiltersAgoraExtension |  2.3.0  |            Koodall Extension for Agora             |

## Installation

1. Open Terminal and run the following command to clone the project to your computer:
```sh
git clone https://github.com/koodall-ai/agora-plugin-filters-ios.git
```

2. In the terminal open the project directory and run the 'pod install' command to get the Koodall and Agora SDKs and plugin framework:
```sh
cd agora-plugin-filters-ios/
pod install --repo-update
```

3. Open the KoodallAgoraFilters.xcworkspace file in Xcode.

4. Copy and paste your Agora token, app and chanel ID to the appropriate section of `/KoodallAgoraFilters/Token.swift` with “ ” symbols. For example: 
``` swift
internal let agoraAppID = "Agora App ID"
internal let agoraClientToken = "Agora Token"
internal let agoraChannelId = "Agora Channel ID"
```

5. Copy and Paste your Koodall license token received from the sales representative to the appropriate section of `/KoodallAgoraFilters/Token.swift` with “ ” symbols. For example: 
``` swift
let koodallLicenseToken = "Koodall Extension License Token"
```

6. The sample includes a few basic AR effects, however you can download additional effects from [here](https://docs.koodall.ai/face-ar-sdk-v1/overview/demo_face_filters). This guarantees, that you will use the up-to-date version of the effects. The effects must be copied to the `agora-plugin-filters-ios -> KoodallAgoraFilters -> effects` folder.

7. Run the `KoodallAgoraFilters` target.

# Integrating Koodall SDK and AgoraRtcKit in your own project

Integrating Koodall SDK to your project is similar to the steps in the `Getting Started` section. 

# KoodallFiltersAgoraExtension

The `KoodallFiltersAgoraExtension` plugin and Koodall SDK can be installed with Cocoapods. Simply add the following lines to your Podfile:
```ruby
pod 'KoodallFiltersAgoraExtension', '2.3.0'
pod 'KoodallSdk', '1.7.0'
```
Please make sure that you have also added our custom Podspecs source to your Podfile:
```ruby
source 'https://github.com/sdk-koodall/koodall-sdk-podspecs.git'
```

Alternatively you can also install the extension by downloading the prebuilt xcframework from [here](https://github.com/koodall-ai/koodall-filters-agora-extension-framework) and manually linking it to your project.

## AgoraRtcKit

Add the following line to your Podfile:
```ruby
pod 'AgoraRtcEngine_iOS', '4.2.0'
```

# How to use `KoodallFiltersAgoraExtension`

To control `KoodallFiltersAgoraExtension` with Agora libs use the following keys from `KoodallPluginKeys.h` file:
```objc
extern NSString * __nonnull const BNBKeyVendorName;
extern NSString * __nonnull const BNBKeyExtensionName;
extern NSString * __nonnull const BNBKeyLoadEffect;
extern NSString * __nonnull const BNBKeyUnloadEffect;
extern NSString * __nonnull const BNBKeySetBanubaLicenseToken;
extern NSString * __nonnull const BNBKeySetEffectsPath;
extern NSString * __nonnull const BNBKeyEvalJSMethod;
```

To enable/disable `KoodallFiltersAgoraExtension` use the following method:
```swift
import KoodallFiltersAgoraExtension

agoraKit?.enableExtension(
    withVendor: BNBKeyVendorName,
    extension: BNBKeyExtensionName,
    enabled: true
)
```

Before applying an effect to your video you have to initialize `KoodallFiltersAgoraExtension` with the path to effects and extension license token. Look at how it can be achieved:
```swift
agoraKit?.setExtensionPropertyWithVendor(BNBKeyVendorName,
                                         extension: BNBKeyExtensionName,
                                         key: BNBKeySetEffectsPath,
                                         value: KoodallEffectsManager.effectsURL.path)
                                         
agoraKit?.setExtensionPropertyWithVendor(BNBKeyVendorName,
                                         extension: BNBKeyExtensionName,
                                         key: BNBKeySetBanubaLicenseToken,
                                         value: banubaLicenseToken)
```

After those steps you can tell `KoodallFiltersAgoraExtension` to enable or disable the mask:

```swift
agoraKit?.setExtensionPropertyWithVendor(
    BNBKeyVendorName,
    extension: BNBKeyExtensionName,
    key: BNBKeyLoadEffect,
    value: "put_effect_name_here"
)
  
agoraKit?.setExtensionPropertyWithVendor(
    BNBKeyVendorName,
    extension: BNBKeyExtensionName,
    key: BNBKeyUnloadEffect,
    value: " "
)
```

If the mask has parameters and you want to change them, you can do it the next way:

```swift
agoraKit?.setExtensionPropertyWithVendor(
    BNBKeyVendorName,
    extension: BNBKeyExtensionName,
    key: BNBKeyEvalJSMethod,
    value: string
)      
```
`string` must be a string with method’s name and parameters. You can find an example in our [documentation](https://docs.koodall.ai/face-ar-sdk-v1/effect_api/face_beauty).

# Effects managing

To retrieve effects list use the following code:

```swift
let effectsPath = KoodallEffectsManager.effectsURL.path
let effectsService = EffectsService(effectsPath: effectsPath)
let effectViewModels = effectsService
    .getEffectNames()
    .sorted()
    .compactMap { effectName in
        guard let effectPreviewImage = effectsService.getEffectPreview(effectName) else {
          return nil
        }

        let effectViewModel = EffectViewModel(image: effectPreviewImage, effectName: effectName)
        return effectViewModel
      }
```

`EffectViewModel` has the following properties:
```swift
class EffectViewModel {
    let image: UIImage
    let effectName: String?
    var cancelEffectModel: Bool {
        return effectName == nil
    }
}
```
