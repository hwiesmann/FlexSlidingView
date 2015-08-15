# Flexible Sliding View iOS SDK
FlexibleSlidingView (FSV) iOS SDK is an open source library using the MIT license that runs natively on iOS 7.1 or greater.

The library implements a container view controller class that manages two UIViewController objects. The main view controller manages the main view. The sliding view controller manages a view that slides on top of the main view. Though it has also the capability to push the main view.

[![FSV demo video](FSV Demo.gif)]()

## Main Features
* sliding view can slide in from bottom, left, right and top
* sliding view can slide above main view or may push main view
* when in "push mode" views can keep their sizes or are resized to fit into the container view controller's view
* a sliding view that slides above the main view can optionally darken the main view when the sliding view's size is larger than its minimum size
* sliding view can be positioned by the user between programmatically specified limits or can snap to the limits

## Installation
Clone from GitHub and integrate the project "FlexibleSlidingView.xcodeproj" found in the "Library" folder into your project and link its library to your project.

To access the source header files you have to include in your projects header path the path to the "Library" directory. Add

* `#import "FlexibleSlidingView/FSVContainerViewController.h"`,
* `#import "FlexibleSlidingView/FSVDimension.h"` 
* `#import "FlexibleSlidingView/FSVRelativePositioning.h"` and/or
* `#import "FlexibleSlidingView/FSVSlidingStyle.h"`

to your files.

The FSV SDK makes no use of any other libraries than the ones found in the iOS SDK.

## Demo
An app is integrated in the repository that shows the usage and features of the FSV SDK. Open the file "FlexibleSlidingView.xcworkspace" with Xcode, build and run the app either on an iPhone, iPad or a simulator.

The app's action button opens a view that lets you manipulate the behaviour of the managed views.

