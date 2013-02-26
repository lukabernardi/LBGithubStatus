LBGithubStatus
============

A Objective-C wrapper for [GitHub Status API](https://status.github.com/api) based on [AFNetworking](https://github.com/AFNetworking/AFNetworking).


Installation
============
The preferred way to install is by using CocoaPods, but you can alway copy the files.

## CocoaPods

You can use [CocoaPods](http://cocoapods.org) to manage your dependencies and install *LBGithubStatus*.
Follow the instructions on the CocoaPods site to [install the gem](https://github.com/CocoaPods/CocoaPods#installation) and add `pod 'LBGithubStatus', :git => "https://github.com/lukabernardi/LBGithubStatus.git` to your *Podfile*.

## Copy Files

This code must be used with deploy target 5.0+ and under ARC. 
If your code doesn't use ARC you can [mark this source with the compiler flag](http://www.codeography.com/2011/10/10/making-arc-and-non-arc-play-nice.html) `-fobjc-arc` 

- Grab the files that starts with the `LBGithubStatus*` prefix 
- `#import "LBGithubStatus.h"` where you need it.

Use
============
The project is provided with an [example code](https://github.com/lukabernardi/LBGithubStatus/blob/master/LBGithubStatus/LBViewController.m).

The library is composed by an `AFHTTPClient` subclass called `LBGithubStatusAPIClient`. Other that the networking code it also provide a couple of utility method i.e. `+ [LBGithubStatusAPIClient dateOutputFormatter]` that return a cached dateFormatter for output the date that comes from GitHub API.

You will probably deal with `LBGithubStatus` and `LBGithubStatusMessage`. 

The former expose the method `+ [LBGithubStatus fetchGithubStatusWithCompletion:error:]` that fetch the current GitHub status.

`LBGithubStatusMessage` expose the method `+ [LBGithubStatusMessage listStatusMessagesWithCompletion:error]` that returns an NSArray of `LBGithubStatusMessage` that wrap a status message from GitHub.

Stay in touch
============

Tweet me [@luka_bernardi](https://twitter.com/luka_bernardi) if you use this code or simply want to tell me what you think about it.

License
============
LBGithubStatus is available under the MIT license. See the LICENSE file for more info.