# ARCampaign IOS SDK

ARCampaign is an app development platform with tools to help you build Augmented Reality Campaigns into your app. More information about ARCampaign can be found at [https://ar.purpl.dev](https://ar.purpl.dev)

## Install the SDK

Go to the ARCampaign Console  [ARCampaign](https://ar.purpl.dev) and create a project. 
Download and drag the ARCampaignInfo.plist file into your XCode project.

### Prerequisites

Before you begin, you need a few things set up in your environment:
* Xcode 10.1 or later
* An Xcode project targeting iOS 12 or later
* Swift projects must use Swift 4.0 or later
* The bundle identifier of your app
* CocoaPods 1.4.0 or later

### Add the SDK

In the ARCampaign console, click create new project, then enter a Project name.
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

```
ARCampaignApp.configure()
```

## Usage

```
let simpleVC = SimpleARCampaignViewController()
present(simpleVC, animated: true, completion: nil)
```

## Built With

* [Zip](https://github.com/marmelroy/Zip) - Used to unzip models recived as .zip files

## Versioning

For the versions available, see the [tags on this repository](https://github.com/purplos/ARCampaignIOS/tags). 

## Author

Purpl, hei@purpl.no

## License

ARCampaign is available under the MIT license. See the LICENSE file for more info.
