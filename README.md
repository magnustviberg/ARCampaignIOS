# ARCampaign IOS SDK

ARCampaign is an app development platform with tools to help you build Augmented Reality Campaigns into your app. More information about ARCampaign can be found at [https://ar.purpl.dev](https://ar.purpl.dev)

## Install the SDK

Go to the [ARCampaign Console](https://ar.purpl.dev) and create a project. 

### Prerequisites

Before you begin, you need a few things set up in your environment:
* Xcode 10.1 or later
* An Xcode project targeting iOS 12 or later
* Swift projects must use Swift 4.0 or later
* The bundle identifier of your app
* CocoaPods 1.4.0 or later

### Add the SDK

Go to the [ARCampaign Console](https://ar.purpl.dev) and create a project, then enter a Project name.
Enter the bundle identifier from your XCode Project and upload pictures and models.
Download the plist file and drag it into your XCode Project

### Add ARCampaign to your project

ARCampaign is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ARCampaign'
```

### Initialize ARCampaign in your app

Import the ARCampaign module in your UIApplicationDelegate:

```
import ARCampaign
```

Configure a ARCampaignApp shared instance, typically in your application's application:didFinishLaunchingWithOptions: method:

```swift
ARCampaignApp.configure()
```

Remember to add a NSCameraUsageDescription to your project if you havent already done so. Add the following code into your info.plist file

```xml
<key>NSCameraUsageDescription</key>
<string>ARCampaign-Example requires access to your phone’s camera.</string>
```

## Usage

With the ARCampaign SDK added to your project you can easly create a SimpleARCampaignViewController or use your own fully customizable UIViewController. 

### Quick and easy implementation

Initilize an instance of the SimpleARCampaignViewController  and present it. And thats it!

```swift
let simpleVC = SimpleARCampaignViewController()
present(simpleVC, animated: true, completion: nil)
```

You can also replace the default tutorial view with your own UIView. Just make sure to replace the tutorialView on the SimpleARViewController before you present it.

```swift
// create an instance of your own subclass of UIView
let customTutorialView = CustomTutorialView()

// create an instance of the SimpleViewController
let simpleVC = SimpleARCampaignViewController()

// replace the tutorialView
simpleVC.tutorialView = customTutorialView

// present 
present(simpleVC, animated: true, completion: nil)
```

### Advanced implementation

Create an instance of CampaignManager in your own ViewController and get access to the model, tracking image and image width.

```swift
let manager = CampaignManager()
manager.fetchCampaign { (campaignInfo, imageData, modelURL, error) in
    if error != nil {
        // Handle error
    } else {
        // get the tracking image width
        guard let width = campaignInfo?.trackingImageInfo.width else { return }

        // get tracking image
        guard let imageData = imageData else { return }
        guard let image = UIImage(data: imageData) else { return }

        // create a ARReferenceImage
        let arImage = ARReferenceImage(image.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: CGFloat(width))

        // get the 3D model
        guard let url = modelURL else { return }
        guard let scene = try? SCNScene.init(url: url, options: nil) else { return }
        let modelNode = scene.rootNode
    }
}
```

The CampaignManager class also has methods for getting the model and the tracking image information separately.

## Built With

* [Zip](https://github.com/marmelroy/Zip) - Used to unzip models recived as .zip files

## Versioning

For the versions available, see the [tags on this repository](https://github.com/purplos/ARCampaignIOS/tags). 

## Author

Purpl, hei@purpl.no

## License

ARCampaign is available under the MIT license. See the LICENSE file for more info.
