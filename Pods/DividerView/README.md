# DividerView

[![CI Status](https://img.shields.io/travis/CraigSiemens/DividerView/master.svg?style=flat)](https://travis-ci.org/CraigSiemens/DividerView)
[![Version](https://img.shields.io/cocoapods/v/DividerView.svg?style=flat)](http://cocoapods.org/pods/DividerView)
[![License](https://img.shields.io/cocoapods/l/DividerView.svg?style=flat)](http://cocoapods.org/pods/DividerView)
[![Platform](https://img.shields.io/cocoapods/p/DividerView.svg?style=flat)](http://cocoapods.org/pods/DividerView)

Simplifies the creation of a one pixel line on any device.

* Horizontal or vertical
* Works with or without autolayout.
* Can be created programmatically or in storyboards/xibs

## Example

To run the example project, run `pod try DividerView`.

## Usage

### Programmatically

Create a new instance and set the axis to `DividerAxis.horzontal` or `DividerAxis.vertical`. This can be done with the init method `DividerView(axis:)`.

```swift
let divider = DividerView(axis: .horizontal)
```
or by setting the `type` property.
```swift
divider.axis = DividerAxis.horzontal;
```

### Storyboard/Xib
1. Add a UIView.

2. In the Identity Inspector (⌥⌘3), set the class to `DividerView`.

3. You may also need to set the module to `DividerView` if it isnt set automatically.

    ![class](Images/class.png)

4. In the Attribute Inspector (⌥⌘4), set the `vertical` option bool to match the type of divider you want to create (default is NO).

    ![verical](Images/vertical.png)

## Installation

DividerView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod "DividerView"
```

## License

DividerView is available under the MIT license. See the LICENSE file for more info.
