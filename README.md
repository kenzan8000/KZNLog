# KZNLog
===============

![Screenshot](https://raw2.github.com/kenzan8000/KZNLog/master/Screenshot/Screenshot.gif "Screenshot")

KZNLog is log macro like NSLog and log viewer in iOS application.

KZNLog is tested on iOS 5.0+ and requires ARC.


## Installation

### CocoaPods
If you are using CocoaPods, then just add KZNLog to you Podfile.
```ruby
pod 'KZNLog', :git => 'https://github.com/kenzan8000/KZNLog.git'
```

### Manually
Simply add the files in the KZNLog directory to your project.


## Example
```objective-c
#define DEBUG_KZNLOG
#define KZNDemoLog KZNLog

KZNDemoLog(@"KZNLog Demo: %@", @"hoge");
```


## License
Released under the MIT license.
