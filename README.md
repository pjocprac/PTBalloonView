# PTBalloonView / PTBalloonLabel

[![Version](https://img.shields.io/cocoapods/v/PTBalloonView.svg?style=flat)](http://cocoapods.org/pods/PTBalloonView)
[![License](https://img.shields.io/cocoapods/l/PTBalloonView.svg?style=flat)](http://cocoapods.org/pods/PTBalloonView)
[![Platform](https://img.shields.io/cocoapods/p/PTBalloonView.svg?style=flat)](http://cocoapods.org/pods/PTBalloonView)

PTBalloonView and PTBalloonLabel are the view and label, like balloon.
It is easy to use this balloon view and label.
And it can be set balloon's inflating and deflating animations.

|PTBalloonView|PTBalloonLabel|
|---|---|
|![PTBalloonView](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/balloon_view.gif "PTBalloonView")|![PTBalloonLabel](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/style_popshift.gif "PTBalloonLabel")|

## Description
PTBalloonView is a simple popup view like a balloon. The `contentView` property is used for your view to be shown in a balloon.

PTBalloonLabel is a simple popup label, which is subclass of PTBalloonView. It have additional properties, title, text, and buttons, instead of contentView.

## Requirements
iOS 8.0

## Installation

PTBalloonView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PTBalloonView"
```

## Usage

At first, to popup balloon view is only code below. (shows empty balloon.)
```swift
let balloonView = PTBalloonView()
balloonView
    .contentView(UIView(frame: CGRectMake(0, 0, 120, 80))) // replace to your content view
    .inflate(TARGET_VIEW) // replace TARGET_VIEW to target view
```
and deflate balloon is only code below.
```swift
balloonView.deflate()
```

To popup PTBalloonLabel.
```swift
let balloonLabel = PTBalloonLabel()
balloonLabel
    .title("PTBalloonLabel Demo")
    .text("This balloon is PTBalloonLabel Demo")
    .addButton(title: "close", type: .Close)
    .inflate(TARGET_VIEW) // replace TARGET_VIEW to target view
```

Details, see the Demo and the [Class Reference](#ClassReference).

#### Balloon Style
To change balloon's style, you can use methods (named same as properties).

#### Balloon Animations
To change balloon's animations, `inflateAnimation()` and `deflatingAnimation()` methods can be used.

<a name="ClassReference"></a>
## Class Reference
[Class Reference](Documents/README.md)

## Demo
To run the example project, clone the repo, and run `pod install` from the Example directory first.

#### Balloon Animation
Balloon's pumping up and deflating animations can be selected.

|Pop|PopShift|Fade|
|---|---|---|
|![Pop](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/style_pop.gif "Pop")|![PopShift](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/style_popshift.gif "PopShift")|![Fade](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/style_fade.gif "Fade")|

|FadeShift|Revolution|RevolutionShift|
|---|---|---|
|![FadeShift](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/style_fadeshift.gif "FadeShift")|![Revolution](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/style_revolution.gif "Revolution")|![RevolutionShift](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/style_revolutionshift.gif "RevolutionShift")|

|Slide (can chose direction)|
|---|
|![Slide](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/style_slide.gif "Slide")|

#### Target Animation
Target view's animations can be selected also. (It applies only when balloon inflating.)

|Pop|Blink|Rotation|Sway|
|---|---|---|---|
|![Target Pop](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/target_style_pop.gif "Target Pop")|![Target Blink](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/target_style_blink.gif "Target Blink")|![Target Rotation](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/target_style_rotation.gif "Target Rotation")|![Target Sway](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/target_style_sway.gif "Target Sway")|

## Author

Takeshi Watanabe, watanabe@tritrue.com

## License

PTBalloonView is available under the MIT license. See the LICENSE file for more info.
