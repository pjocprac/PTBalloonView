//
//  PTBalloonView.swift
//  PTBalloonView
//
//  Created by Takeshi Watanabe on 2016/04/04.
//  Copyright © 2016 Takeshi Watanabe. All rights reserved.
//

import Foundation
import UIKit

public class PTBalloonView : UIView {
    // MARK: Balloon View's Style Properties
    public private(set) var cornerRadius: CGFloat      = 8.0
    public private(set) var insets      : UIEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
    public private(set) var color       : UIColor      = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1)
    
    /// Balloon frame's corner radius (Default: 8.0)
    public func cornerRadius(value: CGFloat) -> Self {
        self.cornerRadius = value
        return self
    }

    /// Spacing between balloon frame and content (Default: UIEdgeInsetsMake(8, 8, 8, 8))
    public func insets(value: UIEdgeInsets) -> Self {
        self.insets = value
        return self
    }

    /// Balloon frame's color (Default: green)
    public func color(value: UIColor) -> Self {
        self.color = value
        return self
    }
    
    // MARK: Balloon's Pin Properties
    public private(set) var pinSize     : CGFloat = 8.0
    public private(set) var pinDirection: PTBalloonViewPinDirection = .Vertical
    
    /// Pin size (Default: 8.0)
    public func pinSize(value: CGFloat) -> Self {
        self.pinSize = value
        return self
    }
    
    /// Pin direction (Default: .Vertical)
    public func pinDirection(value: PTBalloonViewPinDirection) -> Self {
        self.pinDirection = value
        return self
    }

    // MARK: Balloon's Inflating Animation Properties
    private var inflateAnimation : PTBalloonViewAnimationStyle = .PopShift
    private var inflateTargetAnimation : PTBalloonViewTargetAnimationStyle = .Pop
    private var inflateDuration : NSTimeInterval = 0.6
    private var inflateSpring : Bool = true
    
    /**
     Set balloon's inflating animation.
     
     - parameters:
        - animation       : The balloon view's inflate animation. (Default: .PopShift)
        - targetAnimation : The target view's animation. (Default: .Pop)
        - duration        : The animation duration. (Default: 0.6)
        - spring          : Use or not, spring animation. (Default: true)
     */
    public func inflateAnimation(animation: PTBalloonViewAnimationStyle = .PopShift,
                            targetAnimation: PTBalloonViewTargetAnimationStyle = .Pop,
                            duration: NSTimeInterval = 0.6,
                            spring : Bool = true) -> Self {
        self.inflateAnimation = animation
        self.inflateTargetAnimation = targetAnimation
        self.inflateDuration = duration
        self.inflateSpring = spring
        return self
    }

    // MARK: Balloon's Deflating Animation Properties
    private var deflateAnimation : PTBalloonViewAnimationStyle = .PopShift
    private var deflateDuration : NSTimeInterval = 0.4
    private var deflateSpring : Bool = true
    
    /**
     Set balloon's deflating animation.
     
     - parameters:
        - animation : The balloon view's deflate animation. (Default: .Pop)
        - duration  : The animation duration. (Default: 0.4)
        - spring    : Use or not, spring animation. (Default: true)
     */
    public func deflateAnimation(animation: PTBalloonViewAnimationStyle = .Pop,
                            duration: NSTimeInterval = 0.4,
                            spring : Bool = true) -> Self {
        self.deflateAnimation = animation
        self.deflateDuration = duration
        self.deflateSpring = spring
        return self
    }

    /// MARK: Subviews
    private let pinView     = PTBalloonPinView()
    private let frameView   = UIView()
    public private(set) var contentView = UIView(frame: CGRectMake(0, 0, 100, 60))
    
    /// Set balloon view's content.
    public func contentView(value: UIView) -> Self {
        self.contentView = value
        return self
    }
    
    /// MARK: Other properties
    // resolved pin direction
    private var fixedDirection : PTBalloonViewPinDirection = .Top

    public init() {
        super.init(frame: CGRectZero)

        pinView.hidden = true
        self.addSubview(pinView)

        frameView.hidden = true
        self.addSubview(frameView)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(targetFrame: CGRect) {
        // if not have superview, return
        guard let superview = self.superview else {
            return
        }

        // replace contentView
        for subview in frameView.subviews {
            subview.removeFromSuperview()
        }
        frameView.addSubview(contentView)

        let targetCenter = center(targetFrame)
        let screenCenter = center(UIScreen.mainScreen().bounds)

        if pinDirection != .None {
            switch pinDirection {
            case .Vertical:
                if targetCenter.y <= screenCenter.y {
                    fixedDirection = .Top
                } else {
                    fixedDirection = .Bottom
                }

            case .Horizontal:
                if targetCenter.x <= screenCenter.x {
                    fixedDirection = .Left
                } else {
                    fixedDirection = .Right
                }

            default:
                fixedDirection = pinDirection
            }

            // setup pinView
            pinView.color(color).size(pinSize).pinDirection(fixedDirection)
        }

        // setup frameView
        frameView.layer.cornerRadius = cornerRadius
        frameView.backgroundColor = color
        frameView.bounds = CGRectMake(0, 0,
                                      contentView.bounds.width + insets.left + insets.right,
                                      contentView.bounds.height + insets.top + insets.bottom)
        frameView.center = CGPointMake(frameView.bounds.width / 2, frameView.bounds.height / 2)

        // locate contentView @ frameView
        contentView.frame = CGRectMake(insets.left, insets.top, contentView.bounds.width, contentView.bounds.height)

        // locate pinView & frameView
        let screenRect = UIScreen.mainScreen().bounds
        let pinSpacing   : CGFloat = 4.0 // The spacing between targetView and pin
        let frameSpacing : CGFloat = 8.0 // The spacing between screen edge and balloon

        self.bounds = self.frameView.bounds

        switch fixedDirection {
        case .Top, .Bottom :
            let offsetY = targetFrame.height / 2 + pinSize + pinSpacing + frameView.bounds.height / 2
            let offsetX : CGFloat
            if targetCenter.x - frameView.bounds.width/2 < frameSpacing {
                offsetX = frameSpacing - (targetCenter.x - frameView.bounds.width/2)
            } else if targetCenter.x + frameView.bounds.width/2 > screenRect.width - frameSpacing {
                offsetX = -frameSpacing - (targetCenter.x + frameView.bounds.width/2 - screenRect.width)
            } else {
                offsetX = 0
            }

            let pinCenterX = min(frameView.bounds.width - cornerRadius - pinSize,
                                 max(cornerRadius + pinSize, frameView.bounds.width/2 - offsetX))

            if fixedDirection == .Top {
                pinView.center = CGPointMake(pinCenterX, -(pinSize/2 - 1))
                self.center = CGPointMake(targetCenter.x + offsetX, targetCenter.y + offsetY)
            } else {
                pinView.center = CGPointMake(pinCenterX, +(frameView.bounds.height + pinSize/2 - 1))
                self.center = CGPointMake(targetCenter.x + offsetX, targetCenter.y - offsetY)
            }

        case .Left, .Right :
            let offsetX = targetFrame.width / 2 + pinSize + pinSpacing + frameView.bounds.width / 2
            let offsetY : CGFloat
            if targetCenter.y - frameView.bounds.height/2 < frameSpacing {
                offsetY = frameSpacing - (targetCenter.y - frameView.bounds.height/2)
            } else if targetCenter.y + frameView.bounds.height/2 > screenRect.height - frameSpacing {
                offsetY = -frameSpacing - (targetCenter.y + frameView.bounds.height/2 - screenRect.height)
            } else {
                offsetY = 0
            }

            let pinCenterY = min(frameView.bounds.height - cornerRadius - pinSize,
                                 max(cornerRadius + pinSize, frameView.bounds.height/2 - offsetY))

            if fixedDirection == .Left {
                pinView.center = CGPointMake(-(pinSize/2 - 1), pinCenterY)
                self.center = CGPointMake(targetCenter.x + offsetX, targetCenter.y + offsetY)
            } else {
                pinView.center = CGPointMake(+(frameView.bounds.width + pinSize/2 - 1), pinCenterY)
                self.center = CGPointMake(targetCenter.x - offsetX, targetCenter.y + offsetY)
            }

        default:
            break
        }
    }

    /**
     Show balloon.
     The balloon view will be added to inView automaticaly. Therefore, the balloon view need not be added any view.
     
     - parameters:
        - targetView      : The target view which will be pointed at by the balloon view.
        - inView          : The view which the balloon view will be added to.
                            If not specified, the balloon view will be added to root view. (Default: nil)
        - completion      : The completion handler which will be executed when the balloon view has been pumped up. (Default: nil)
     */
    public func inflate(targetView : UIView, inView : UIView? = nil, completion : ((Bool)->Void)? = nil) -> Void {

        // balloon and target need to belong to superview
        guard let targetSuperview = targetView.superview else {
            return
        }

        if let inView = inView {
            inView.addSubview(self)
        } else {
            var rootView = targetSuperview
            while rootView.superview != nil {
                rootView = rootView.superview!
            }
            rootView.addSubview(self)
        }
        let superview = self.superview
        
        // view setup
        let targetFrame = targetSuperview.convertRect(targetView.frame, toView: superview)
        setupView(targetFrame)

        self.alpha = 1
        self.transform = CGAffineTransformIdentity
        pinView.hidden = pinDirection == .None
        frameView.hidden = false

        // animation

        // prepare transforms
        let shift : CGFloat = 16
        let shiftTransform : CGAffineTransform
        switch fixedDirection {
        case .Top   : shiftTransform = CGAffineTransformMakeTranslation(0,  shift)
        case .Bottom: shiftTransform = CGAffineTransformMakeTranslation(0, -shift)
        case .Left  : shiftTransform = CGAffineTransformMakeTranslation( shift, 0)
        case .Right : shiftTransform = CGAffineTransformMakeTranslation(-shift, 0)
        default     : shiftTransform = CGAffineTransformIdentity
        }

        let pinShiftTransform :CGAffineTransform
        switch self.fixedDirection {
        case .Top   : pinShiftTransform = CGAffineTransformMakeTranslation(0, self.pinSize)
        case .Bottom: pinShiftTransform = CGAffineTransformMakeTranslation(0, -self.pinSize)
        case .Left  : pinShiftTransform = CGAffineTransformMakeTranslation( self.pinSize, 0)
        case .Right : pinShiftTransform = CGAffineTransformMakeTranslation(-self.pinSize, 0)
        default     : pinShiftTransform = CGAffineTransformIdentity
        }


        switch inflateAnimation {
        case .None:
            if let completion = completion {
                completion(true)
            }
            break

        case .Pop:
            self.transform = CGAffineTransformMakeScale(0, 0)
            UIView.animateWithDuration(
                inflateDuration, delay: 0, usingSpringWithDamping: inflateSpring ? 0.6 : 1, initialSpringVelocity: 0, options: [.CurveEaseInOut],
                animations: {
                    self.transform = CGAffineTransformIdentity
                }, completion: completion)

        case .PopShift:
            self.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0, 0), shiftTransform)
            pinView.alpha = 0

            UIView.animateWithDuration(
                inflateDuration * 2/3, delay: 0, usingSpringWithDamping: inflateSpring ? 0.75 : 1, initialSpringVelocity: 0, options: [.CurveEaseInOut],
                animations: {
                    self.transform = shiftTransform
                },
                completion: { completed in
                    self.pinView.alpha = 1
                    self.pinView.transform = pinShiftTransform
                    UIView.animateWithDuration(
                        self.inflateDuration * 1/3, delay: 0, usingSpringWithDamping: self.inflateSpring ? 0.75 : 1, initialSpringVelocity: 0, options: [.CurveEaseInOut],
                        animations: {
                            self.pinView.transform = CGAffineTransformIdentity
                            self.transform = CGAffineTransformIdentity
                        },
                        completion: completion)
            })


        case .Fade:
            self.alpha = 0

            UIView.animateWithDuration(
                inflateDuration, delay: 0, options: [.CurveEaseInOut],
                animations: {
                    self.alpha = 1
                },
                completion: completion)

        case .FadeShift:
            self.transform = shiftTransform
            self.alpha = 0

            UIView.animateWithDuration(
                inflateDuration, delay: 0, usingSpringWithDamping: inflateSpring ? 0.75 : 1, initialSpringVelocity: 0, options: [.CurveEaseInOut],
                animations: {
                    self.alpha = 1
                    self.transform = CGAffineTransformIdentity
                },
                completion: completion)

        case .Revolution:
            switch fixedDirection {
            case .Top, .Bottom : self.transform = CGAffineTransformMakeScale(0, 1)
            case .Left, .Right : self.transform = CGAffineTransformMakeScale(1, 0)
            default     : break
            }

            UIView.animateWithDuration(
                inflateDuration, delay: 0, usingSpringWithDamping: inflateSpring ? 0.75 : 1, initialSpringVelocity: 0, options: [.CurveEaseInOut],
                animations: {
                    self.transform = CGAffineTransformIdentity
                },
                completion: completion)

        case .RevolutionShift:
            switch fixedDirection {
            case .Top, .Bottom : self.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0, 1), shiftTransform)
            case .Left, .Right : self.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1, 0), shiftTransform)
            default     : break
            }

            pinView.alpha = 0
            UIView.animateWithDuration(
                inflateDuration * 2/3, delay: 0, usingSpringWithDamping: inflateSpring ? 0.75 : 1, initialSpringVelocity: 0, options: [.CurveEaseInOut],
                animations: {
                    self.transform = shiftTransform
                },
                completion: { completed in
                    self.pinView.alpha = 1
                    self.pinView.transform = pinShiftTransform
                    UIView.animateWithDuration(
                        self.inflateDuration * 1/3, delay: 0, usingSpringWithDamping: self.inflateSpring ? 0.75 : 1, initialSpringVelocity: 0, options: [.CurveEaseInOut],
                        animations: {
                            self.pinView.transform = CGAffineTransformIdentity
                            self.transform = CGAffineTransformIdentity
                        },
                        completion: completion)
                })

        case .Slide (let direction):
            let slideDirection = convertDirection(direction)

            self.transform = CGAffineTransformIdentity
            let screenRect = UIScreen.mainScreen().bounds
            switch slideDirection {
            case .Top   : self.transform = CGAffineTransformMakeTranslation(0, -(self.frame.origin.y + self.frame.height + pinSize))
            case .Bottom: self.transform = CGAffineTransformMakeTranslation(0, screenRect.height - self.frame.origin.y + pinSize)
            case .Left  : self.transform = CGAffineTransformMakeTranslation(-(self.frame.origin.x + self.frame.width + pinSize), 0)
            case .Right : self.transform = CGAffineTransformMakeTranslation(screenRect.width - self.frame.origin.x + pinSize, 0)
            default     : break
            }

            UIView.animateWithDuration(
                inflateDuration, delay: 0, usingSpringWithDamping: inflateSpring ? 0.75 : 1, initialSpringVelocity: 0, options: [.CurveEaseInOut],
                animations: {
                    self.transform = CGAffineTransformIdentity
                },
                completion: completion)

        }
        
        switch inflateTargetAnimation {
        case .None:
            break
            
        case .Blink:
            UIView.animateWithDuration(
                inflateDuration/2, delay: 0, options: [.CurveEaseInOut],
                animations: {
                    targetView.alpha = targetView.alpha * 0.5
                },
                completion: { completed in
                    UIView.animateWithDuration(
                        self.inflateDuration/2, delay: 0, options: [.CurveEaseInOut],
                        animations: {
                            targetView.alpha = targetView.alpha * 2
                        },
                        completion: nil)
            })
        case .Pop:
            let baseTransform = targetView.transform
            UIView.animateWithDuration(
                inflateDuration/4, delay: 0, options: [.CurveEaseInOut],
                animations: {
                    targetView.transform = CGAffineTransformScale(baseTransform, 1.2, 1.2)
                },
                completion: { completed in
                    UIView.animateWithDuration(
                        self.inflateDuration/2, delay: 0, options: [.CurveEaseInOut],
                        animations: {
                            targetView.transform = CGAffineTransformScale(baseTransform, 0.8, 0.8)
                        },
                        completion: { completed in
                            UIView.animateWithDuration(
                                self.inflateDuration/2, delay: 0, options: [.CurveEaseInOut],
                                animations: {
                                    targetView.transform = baseTransform
                                },
                                completion: nil)
                    })
            })
        case .Rotation:
            let baseTransform = targetView.transform
            targetView.transform = CGAffineTransformRotate(baseTransform, CGFloat(2 * M_PI))
            UIView.animateWithDuration(
                inflateDuration * 4/11, delay: 0, options: [.CurveEaseIn],
                animations: {
                    targetView.transform = CGAffineTransformRotate(baseTransform, CGFloat(2 * M_PI * 1/3))
                },
                completion: { completed in
                    UIView.animateWithDuration(
                        self.inflateDuration * 3/11, delay: 0, options: [.CurveLinear],
                        animations: {
                            targetView.transform = CGAffineTransformRotate(baseTransform, CGFloat(2 * M_PI * 2/3))
                        },
                        completion: { completed in
                            UIView.animateWithDuration(
                                self.inflateDuration * 4/11, delay: 0, options: [.CurveEaseOut],
                                animations: {
                                    targetView.transform = baseTransform
                                },
                                completion: nil)
                    })
            })
            
        case .Sway:
            let baseTransform = targetView.transform
            targetView.transform = CGAffineTransformRotate(baseTransform, CGFloat(2 * M_PI))
            UIView.animateWithDuration(
                inflateDuration * 1/3, delay: 0, options: [.CurveEaseInOut],
                animations: {
                    targetView.transform = CGAffineTransformRotate(baseTransform, CGFloat(2 * M_PI * -20 / 360))
                },
                completion: { completed in
                    UIView.animateWithDuration(
                        self.inflateDuration * 1/3, delay: 0, options: [.CurveEaseInOut],
                        animations: {
                            targetView.transform = CGAffineTransformRotate(baseTransform, CGFloat(2 * M_PI * 20 / 360))
                        },
                        completion: { completed in
                            UIView.animateWithDuration(
                                self.inflateDuration * 1/3, delay: 0, options: [.CurveEaseInOut],
                                animations: {
                                    targetView.transform = baseTransform
                                },
                                completion: nil)
                    })
            })
        }
    }

    /**
     Hide balloon.
     After hide animation, the balloon view will be remove from superview automaticaly.
     
     - parameters:
        - completion      : The completion handler which will be executed when the balloon view has been deflated. (Default: nil)
     */
    public func deflate (completion : ((Bool)->Void)? = nil) -> Void {

        let completionHandler : (Bool)->Void = { completed in
            self.removeFromSuperview()
            if let completion = completion {
                completion(completed)
            }
        }

        switch deflateAnimation {
        case .None:
            completionHandler(true)

        case .Pop, .PopShift:
            if deflateSpring {
                UIView.animateWithDuration(
                    deflateDuration * 1/3, delay: 0, options: [.CurveEaseInOut],
                    animations: {
                        self.transform = CGAffineTransformMakeScale(1.1, 1.1)
                    }, completion: { completed in
                        UIView.animateWithDuration(
                            self.deflateDuration * 2/3, delay: 0, options: [.CurveEaseInOut],
                            animations: {
                                self.transform = CGAffineTransformMakeScale(0.000001, 0.000001)
                            }, completion: completionHandler)
                })
            } else {
                UIView.animateWithDuration(
                    deflateDuration, delay: 0, options: [.CurveEaseInOut],
                    animations: {
                        self.transform = CGAffineTransformMakeScale(0.000001, 0.000001)
                    }, completion: completionHandler)
            }

        case .Fade, .FadeShift:
            UIView.animateWithDuration(
                deflateDuration, delay: 0, options: [.CurveEaseInOut],
                animations: {
                    self.alpha = 0
                }, completion: completionHandler)

        case .Revolution, .RevolutionShift:
            if deflateSpring {
                UIView.animateWithDuration(
                    deflateDuration * 1/3, delay: 0, options: [.CurveEaseInOut],
                    animations: {
                        switch self.fixedDirection {
                        case .Top, .Bottom : self.transform = CGAffineTransformMakeScale(1.1, 1)
                        case .Left, .Right : self.transform = CGAffineTransformMakeScale(1, 1.1)
                        default     : break
                        }
                    }, completion: { completed in
                        UIView.animateWithDuration(
                            self.deflateDuration * 2/3, delay: 0, options: [.CurveEaseInOut],
                            animations: {
                                switch self.fixedDirection {
                                case .Top, .Bottom : self.transform = CGAffineTransformMakeScale(0.000001, 1)
                                case .Left, .Right : self.transform = CGAffineTransformMakeScale(1, 0.000001)
                                default     : break
                                }
                            }, completion: completionHandler)
                })
            } else {
                UIView.animateWithDuration(
                    deflateDuration, delay: 0, options: [.CurveEaseInOut],
                    animations: {
                        switch self.fixedDirection {
                        case .Top, .Bottom : self.transform = CGAffineTransformMakeScale(0.000001, 1)
                        case .Left, .Right : self.transform = CGAffineTransformMakeScale(1, 0.000001)
                        default     : break
                        }
                    }, completion: completionHandler)
            }

        case .Slide (let direction):
            let slideDirection = convertDirection(direction)

            UIView.animateWithDuration(
                deflateDuration, delay: 0, options: [.CurveEaseInOut],
                animations: {
                    let screenRect = UIScreen.mainScreen().bounds
                    let pinSize = self.pinSize
                    switch slideDirection {
                    case .Top   : self.transform = CGAffineTransformMakeTranslation(0, -(self.frame.origin.y + self.frame.height + pinSize))
                    case .Bottom: self.transform = CGAffineTransformMakeTranslation(0, screenRect.height - self.frame.origin.y + pinSize)
                    case .Left  : self.transform = CGAffineTransformMakeTranslation(-(self.frame.origin.x + self.frame.width + pinSize), 0)
                    case .Right : self.transform = CGAffineTransformMakeTranslation(screenRect.width - self.frame.origin.x + pinSize, 0)
                    default     : break
                    }
                },
                completion: completionHandler)
        }
    }

    private func center(rect: CGRect) -> CGPoint {
        return CGPointMake(rect.origin.x + rect.width/2, rect.origin.y + rect.height/2)
    }

    private func convertDirection(direction: PTBalloonViewEffectDirection) -> PTBalloonViewDirection {
        var slideDirection : PTBalloonViewDirection = .Top
        switch direction {
        case .Auto:
            switch fixedDirection {
            case .Top   : slideDirection = .Top
            case .Bottom: slideDirection = .Bottom
            case .Left  : slideDirection = .Left
            case .Right : slideDirection = .Right
            default     : break
            }

        case .Reverse:
            switch fixedDirection {
            case .Top   : slideDirection = .Bottom
            case .Bottom: slideDirection = .Top
            case .Left  : slideDirection = .Right
            case .Right : slideDirection = .Left
            default     : break
            }

        case .Speified(let sdirection):
            slideDirection = sdirection
        }

        return slideDirection
    }
}

private class PTBalloonPinView : UIView {
    var color: UIColor?
    var size: CGFloat?
    var pinDirection : PTBalloonViewPinDirection?

    private func color(value: UIColor) -> Self {
        self.color = value
        return self
    }

    private func size(value: CGFloat) -> Self {
        self.size = value
        setupView()
        return self
    }

    private func pinDirection(value: PTBalloonViewPinDirection) -> Self {
        self.pinDirection = value
        setupView()
        setNeedsDisplay()
        return self
    }

    private func setupView() {
        self.backgroundColor = .clearColor()
        if let size = size, pinDirection = pinDirection {
            switch pinDirection {
            case .Vertical, .Top, .Bottom:
                self.bounds = CGRectMake(0, 0, size * 2, size)
            case .Horizontal, .Left, .Right:
                self.bounds = CGRectMake(0, 0, size, size * 2)
            case .None:
                self.bounds = CGRectZero
            }
        }
    }

    override func drawRect(rect: CGRect) {
        guard let color = self.color, let pinDirection = self.pinDirection else {
            return
        }

        var coordinates : [CGPoint] = []

        switch pinDirection {
        case .Top:
            coordinates.append(CGPointMake(0, self.bounds.height))
            coordinates.append(CGPointMake(bounds.width, self.bounds.height))
            coordinates.append(CGPointMake(bounds.width / 2, 0))
            coordinates.append(CGPointMake(0, self.bounds.height))

        case .Bottom:
            coordinates.append(CGPointMake(0, 0))
            coordinates.append(CGPointMake(bounds.width, 0))
            coordinates.append(CGPointMake(bounds.width / 2, self.bounds.height))
            coordinates.append(CGPointMake(0, 0))

        case .Left:
            coordinates.append(CGPointMake(bounds.width, 0))
            coordinates.append(CGPointMake(bounds.width, self.bounds.height))
            coordinates.append(CGPointMake(0, self.bounds.height / 2))
            coordinates.append(CGPointMake(bounds.width, 0))

        case .Right:
            coordinates.append(CGPointMake(0, 0))
            coordinates.append(CGPointMake(0, self.bounds.height))
            coordinates.append(CGPointMake(bounds.width, self.bounds.height / 2))
            coordinates.append(CGPointMake(0, 0))

        default:
            break
        }

        if coordinates.count > 0 {
            let path = UIBezierPath()

            path.moveToPoint(coordinates[0])
            for i in 1..<coordinates.count {
                path.addLineToPoint(coordinates[i])
            }

            color.setFill()
            path.fill()
        }
    }
}

/// Pin Direction
public enum PTBalloonViewPinDirection {
    /// Do not show the pin
    case None
    /// Semi auto (▲ or ▼)
    case Vertical
    /// Semi auto (◀ or ▶)
    case Horizontal
    
    /// Direction ▲
    case Top
    /// Direction ▼
    case Bottom
    /// Direction ◀
    case Left
    /// Direction ▶
    case Right
}

/// The balloon view's inflate/deflate animation style
public enum PTBalloonViewAnimationStyle {
    /// No animation
    case None
    /// Pop animation
    case Pop
    /// Pop and followed shift position animation
    case PopShift
    /// Fade animation
    case Fade
    /// Fade and shift position animation
    case FadeShift
    /// Revolution animation
    case Revolution
    /// Revolution and followed shift position animation
    case RevolutionShift
    /// Slide animation with argument PTBalloonViewEffectDirection
    case Slide (PTBalloonViewEffectDirection)
}

/// The target view's style
public enum PTBalloonViewTargetAnimationStyle {
    /// No animation
    case None
    /// Pop animation
    case Pop
    /// Blink animation
    case Blink
    /// Rotation animation
    case Rotation
    /// Sway animation
    case Sway
}

public enum PTBalloonViewEffectDirection {
    /// Automatic
    case Auto
    /// Reverse of Auto
    case Reverse
    /// Specified direction with argument of Top, Bottom, Left, or Right.
    case Speified(PTBalloonViewDirection)
}

public enum PTBalloonViewDirection {
    case Top, Bottom, Left, Right
}