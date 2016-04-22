# Class PTBalloonView
PTBalloonView is UIView subclass, like balloon.

## Usage
PTBalloonView is instantiated with initializer init().
```swift
let balloonView = PTBalloonView()
```

To inflate and deflate balloon's view, you can use methods `inflate()` and `deflate()`.
```swift
// inflate balloon
balloonView.inflate(targetView)

// deflate balloon
balloonView.deflate()
```

To set balloon's content, you can use `contentView()` method.
```swift
balloonView.contentView(UIView(frame: CGRectMake(0, 0, 120, 80)))
```

To change balloon's style, you can use methods (named same as properties, `propertyName()`), and these methods can be used as method chain.
```swift
balloonView
    .cornerRadius(8.0)
    .insets(UIEdgeInsetsMake(8, 8, 8, 8))
    .color(UIColor.darkGrayColor())
    .pinSize(8.0)
    .pinDirection(.Top)
```

To change balloon's animations, `inflateAnimation()` and `deflatingAnimation()` methods can be used.
```swift
balloonView
    .inflateAnimation(.PopShift, targetAnimation: .Rotation, duration: 0.5, spring: true)
    .deflateAnimation(.Fade, duration: 0.25, spring: false)
```

<a name="Properties"></a>
## Properties
All properties are able to set by method chain *propertyName()*.

|Property|Type|Descrption|Default|
|:---|:---|:---|:---|
|contentView|UIView|Balloon's content.||
|cornerRadius|CGFloat|Balloon's corner radius.|8.0|
|insets|UIEdgeInsets|Insets between balloon's frame and content.|(8, 8, 8, 8)|
|color|UIColor|Balloon's color.|green|
|pinSize|CGFloat|Balloon pin's size.|8.0|
|pinDirection|[PTBalloonViewPinDirection](#PTBalloonViewPinDirection)|Balloon pin's direction.|.Vertical|

## Methods
- [inflate](#inflate)
- [deflate](#deflate)
- [inflateAnimation](#inflateAnimation)
- [deflateAnimation](#deflateAnimation)

<a name="inflate"></a>
### inflate
Inflate balloon view.
```swift
public func inflate (targetView: UIView, inView: UIView? = nil, completion: ((Bool)->Void)? = nil) -> Void
```

|Argument|Type|Mandatory|Descrption|
|:---|:---|:---:|:---|
|targetView|UIView|Yes|Target View which is pointed at by the balloon view.|
|inView|UIView|No|The view which the balloon view will be added to, if not specified, the balloon view will be added to root view of targetView (usually UIWindow).|
|completion|((Bool)->Void)|No|The completion handler, which will be executed at the balloon view will be inflated.|

<a name="deflate"></a>
### deflate
Deflate balloon view.
```swift
public func deflate (completion: ((Bool)->Void)? = nil) -> Void
```
|Argument|Type|Mandatory|Descrption|
|:---|:---|:---:|:---|
|completion|((Bool)->Void)|No|The completion handler, which will be executed at the balloon view will be deflated.|

<a name="inflateAnimation"></a>
### inflateAnimation
Set inflate animations.
```swift
public func inflateAnimation (
    animation: PTBalloonViewAnimationStyle = .PopShift,
    targetAnimation: PTBalloonViewTargetAnimationStyle = .Pop,
    duration: NSTimeInterval = 0.6,
    spring: Bool = true) -> Self
```

|Argument|Type|Mandatory|Descrption|
|:---|:---|:---:|:---|
|animation|PTBalloonViewAnimationStyle|No|Balloon view's inflate animation style.|
|targetAnimation|PTBalloonViewTargetAnimationStyle|No|Target view's animation style.|
|duration|NSTimeInterval|No|Animation duration.|
|spring|Bool|No|Use or not, spring animation.|

<a name="deflateAnimation"></a>
### deflateAnimation
Set deflate animations.
```swift
public func deflateAnimation (
    animation: PTBalloonViewAnimationStyle = .Pop,
    duration: NSTimeInterval = 0.4,
    spring: Bool = true) -> Self
```

|Argument|Type|Mandatory|Descrption|
|:---|:---|:---:|:---|
|animation|PTBalloonViewAnimationStyle|No|Balloon view's deflate animation style.|
|duration|NSTimeInterval|No|Animation duration.|
|spring|Bool|No|Use or not, spring animation.|

<a name="PTBalloonViewPinDirection"></a>
## PTBalloonViewPinDirection
Enum of PTBalloonViewPinDirection is defined as below.

|Definition|Description|
|:---|:---|
|None|Do not show the pin|
|Vertical|Semi auto (▲ or ▼)|
|Horizontal|Semi auto (◀ or ▶)|
|Top|Direction ▲|
|Bottom|Direction ▼|
|Left|Direction ◀|
|Right|Direction ▶|

<a name="PTBalloonViewAnimationStyle"></a>
## PTBalloonViewAnimationStyle
Enum of PTBalloonViewAnimationStyle is defined as below.

|Definition|Description|Demo|
|:---|:---|:---|
|None|No animation.|
|Pop|Pop animation.|![Pop](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/style_pop.gif "Pop")|
|PopShift|Pop and followed shift position animation.|![PopShift](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/style_popshift.gif "PopShift")|
|Fade|Fade animation.|![Fade](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/style_fade.gif "Fade")|
|FadeShift|Fade and shift position animation.|![FadeShift](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/style_fadeshift.gif "FadeShift")|
|Revolution|Revolution animation.|![Revolution](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/style_revolution.gif "Revolution")|
|RevolutionShift|Revolution and followed shift position animation.|![RevolutionShift](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/style_revolutionshift.gif "RevolutionShift")|
|Slide|Slide animation with argument [PTBalloonViewEffectDirection](#PTBalloonViewEffectDirection).|![Slide](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/style_slide.gif "Slide")

<a name="PTBalloonViewTargetAnimationStyle"></a>
## PTBalloonViewTargetAnimationStyle
Enum of PTBalloonViewTargetAnimationStyle is defined as below.

|Definition|Description|Demo|
|:---|:---|:---|
|None|No animation.|
|Pop|Pop animation.|![Target Pop](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/target_style_pop.gif "Target Pop")|
|Blink|Blink animation.|![Target Blink](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/target_style_blink.gif "Target Blink")|
|Rotation|Rotation animation.|![Target Rotation](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/target_style_rotation.gif "Target Rotation")|
|Sway|Sway animation.|![Target Sway](https://raw.githubusercontent.com/pjocprac/PTBalloonView/master/Images/target_style_sway.gif "Target Sway")|

<a name="PTBalloonViewEffectDirection"></a>
## PTBalloonViewEffectDirection
Enum of PTBalloonViewEffectDirection is defined as below.

|Definition|Description|
|:---|:---|
|Auto|Automatic|
|Reverse|Reverse of Auto|
|Speified(.Top)|Specified direction (Top)|
|Speified(.Bottom)|Specified direction (Bottom)|
|Speified(.Left)|Specified direction (Left)|
|Speified(.Right)|Specified direction (Right)|
