# Class PTBalloonLabel
Subclass of [PTBalloonView](PTBalloonView.md) specializing in the message display.

## Usage
Basic operations, see [PTBalloonView](PTBalloonView.md)'s reference.

To set balloon's content, you can use `title()`, `text()` and `addButton()` methods instead of `contentView()`.
```swift
let balloonLabel = PTBalloonLabel()
balloonLabel
    .title("PTBalloonLabel Demo")
    .text("This balloon is PTBalloonLabel Demo")
    .addButton(title: "close", type: .Close)
    .inflate(targetView)
```

## Properties
Additional properties to [PTBalloonView](PTBalloonView.md#Properties). All properties are able to set by method chain *propertyName()*.

|Property|Type|Descrption|Default|
|:---|:---|:---|:---|
|**title**|String|Title of the balloon label. If not set (default), title area is hided.||
|titleFont|UIFont|Font setting of the balloon label's title.|boldSystemFontOfSize(16)|
|titleColor|UIColor|Color setting of the balloon label's title.|#EEEEEE|
|**text**|String|Text content of the balloon label.||
|textFont|UIFont|Font setting of the balloon text's title.|boldSystemFontOfSize(14)|
|textColor|UIColor|Color setting of the balloon label's buttons.|#EEEEEE|
|buttonFont|UIFont|Font setting of the balloon text's title.|boldSystemFontOfSize(16)|
|buttonColor|UIColor|Color setting of the balloon label's buttons.|#EEEEEE|
|buttonHeight|CGFloat|Height of the balloon label's buttons.|24.0|
|maxWidth|CGFloat|Max width of balloon label. If not set (default), max width is set *screen width* x 0.8||

## Methods
### addButton
Add button to balloon label.
```swift
// add button with title
public func addButton(title title: String?, type: PTBalloonLabelButtonType = .Normal, handler: (()->Void)? = nil) -> Self
```
|Argument|Type|Mandatory|Descrption|
|:---|:---|:---:|:---|
|title|String|Yes|Title of button.|
|type|[PTBalloonLabelButtonType](#PTBalloonLabelButtonType)|No|Button type. If `.Close` is set, button behave close button.|
|handler|(()->Void)|No|The handler which is executed at button tapped.|

```swift
// add button with UIButton
public func addButton(button button: UIButton, type: PTBalloonLabelButtonType = .Normal, handler: (()->Void)? = nil) -> Self
```
|Argument|Type|Mandatory|Descrption|
|:---|:---|:---:|:---|
|button|UIButton|Yes|User's predefined button.|

<a name="PTBalloonLabelButtonType"></a>
## PTBalloonLabelButtonType
Enum of PTBalloonLabelButtonType is defined as below.

|Definition|Description|
|:---|:---|
|Normal|Normal button, operation is defined by the handler.|
|Close|Close button.|
