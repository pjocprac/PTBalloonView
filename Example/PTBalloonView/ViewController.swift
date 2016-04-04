//
//  ViewController.swift
//  PTBalloonView
//
//  Created by Takeshi Watanabe on 03/29/2016.
//  Copyright (c) 2016 Takeshi Watanabe. All rights reserved.
//

import UIKit
import PTBalloonView

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var demoView: UIView!
    @IBOutlet weak var pinDirectionButton     : UIButton!
    @IBOutlet weak var balloonAnimationButton : UIButton!
    @IBOutlet weak var targetAnimationButton  : UIButton!
    @IBOutlet weak var durationValue          : UILabel!
    @IBOutlet weak var durationSlider         : UISlider!
    @IBOutlet weak var springButton           : UIButton!
    @IBOutlet weak var pickerView             : UIPickerView!
    @IBOutlet weak var pickerViewHeight       : NSLayoutConstraint!

    var pinDirection     : PTBalloonViewPinDirection         = .Vertical
    var balloonAnimation : PTBalloonViewAnimationStyle       = .PopShift
    var targetAnimation  : PTBalloonViewTargetAnimationStyle = .Pop
    var duration : NSTimeInterval = 0.6
    var spring   : Bool           = true

    var values : [AnyObject] = []
    let pinDirectionValues     : [PTBalloonViewPinDirection]
        = [.None, .Vertical, .Horizontal, .Top, .Bottom, .Left, .Right]

    let balloonAnimationValues : [PTBalloonViewAnimationStyle]
        = [.None, .Pop, .PopShift, .Fade, .FadeShift, .Revolution, .RevolutionShift, .Slide(.Auto)]

    let targetAnimationValues : [PTBalloonViewTargetAnimationStyle]
        = [.None, .Pop, .Blink, .Rotation, .Sway]

    var selectedButton : UIButton?

    let balloonLabel = PTBalloonLabel()
    let balloonView = PTBalloonView()
    
    let targetView = UILabel()
    
    var count : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        pinDirectionButton.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
        balloonAnimationButton.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
        targetAnimationButton.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
        springButton.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)

        durationSlider.addTarget(self, action: "sliderChanged:", forControlEvents: .ValueChanged)

        pickerView.delegate = self
        pickerView.dataSource = self

        pinDirectionButton.setTitle(String(pinDirection), forState: .Normal)
        balloonAnimationButton.setTitle(String(balloonAnimation), forState: .Normal)
        targetAnimationButton.setTitle(String(targetAnimation), forState: .Normal)
        springButton.setTitle(String(spring), forState: .Normal)

        targetView.text = "★"
        targetView.font = UIFont.systemFontOfSize(48)
        targetView.bounds = CGRectMake(0, 0, 60, 60)
        targetView.textAlignment = .Center
        targetView.backgroundColor = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1)
        targetView.textColor = .whiteColor()
        targetView.layer.cornerRadius = 30
        targetView.clipsToBounds = true

        // setup balloon view
        let image = UIImage(data: NSData(base64EncodedString:imageString, options: .IgnoreUnknownCharacters)!)
        let imageView = UIImageView(image: image?.imageWithRenderingMode(.AlwaysTemplate))
        imageView.tintColor = .whiteColor()
        imageView.userInteractionEnabled = true
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(_:)))
        imageView.addGestureRecognizer(imageTapGesture)
        balloonView.contentView(imageView)

        // setup balloon label
        balloonLabel
            .title("Gettysburg Address")
            .text("Four score and seven years ago our fathers brought forth on this continent, a new nation, conceived in Liberty, and dedicated to the proposition that all men are created equal.")
            .addButton(title: "Close", type: .Normal, handler: {
                self.balloonLabel.deflate() { completed in
                    self.targetView.removeFromSuperview()
                }
            })
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tap(_:)))
        demoView.addGestureRecognizer(gesture)
    }

    func tap (sender: UITapGestureRecognizer) {
        self.pickerViewHeight.constant = 0

        var deflate = false
        if balloonLabel.superview != nil {
            balloonLabel.deflate() { completed in
                self.targetView.removeFromSuperview()
            }
            deflate = true
        } else if balloonView.superview != nil {
            balloonView.deflate() { completed in
                self.targetView.removeFromSuperview()
            }
            deflate = true
        }

        if !deflate {
            targetView.center = sender.locationOfTouch(0, inView: self.view)
            self.view.addSubview(targetView)
            
            let balloon : PTBalloonView
            count += 1
            if count % 2 == 0 {
                balloon = balloonView
            } else {
                balloon = balloonLabel
            }
            balloon
                .pinDirection(self.pinDirection)
                .inflateAnimation(self.balloonAnimation, targetAnimation: self.targetAnimation, duration: self.duration, spring: self.spring)
                .deflateAnimation(self.balloonAnimation, duration: self.spring ? self.duration * 0.5 : self.duration, spring: self.spring)
                .inflate(self.targetView, inView: nil)
        }
    }

    func buttonTapped (sender: UIButton) {
        selectedButton = sender
        if sender == springButton {
            spring = !spring
            springButton.setTitle(String(spring), forState: .Normal)
        } else {
            pickerViewHeight.constant = 200
            pickerView.reloadAllComponents()
            pickerView.alpha = 0
            UIView.animateWithDuration(
                0.3,
                animations: {
                    self.pickerView.alpha = 1
                },
                completion: { completed in
                    if sender == self.pinDirectionButton {
                        self.pickerView.selectRow(self.pinDirectionValues.indexOf(self.pinDirection)!, inComponent: 0, animated: true)
                    } else if sender == self.balloonAnimationButton {
                        let index : Int
                        switch self.balloonAnimation {
                        case .None           : index = 0
                        case .Pop            : index = 1
                        case .PopShift       : index = 2
                        case .Fade           : index = 3
                        case .FadeShift      : index = 4
                        case .Revolution     : index = 5
                        case .RevolutionShift: index = 6
                        case .Slide          : index = 7
                        }
                        self.pickerView.selectRow(index, inComponent: 0, animated: true)
                    } else if sender == self.targetAnimationButton {
                        self.pickerView.selectRow(self.targetAnimationValues.indexOf(self.targetAnimation)!, inComponent: 0, animated: true)
                    }
            })
        }
    }
    
    func imageTapped(sender: UITapGestureRecognizer) {
        balloonView.deflate() { completed in
            self.targetView.removeFromSuperview()
        }
    }

    func sliderChanged (sender: UISlider) {
        durationValue.text = String(roundf(sender.value * 100) / 100)
        duration = Double(roundf(sender.value * 100) / 100)
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if selectedButton == pinDirectionButton {
            return pinDirectionValues.count
        } else if selectedButton == balloonAnimationButton {
            return balloonAnimationValues.count
        } else if selectedButton == targetAnimationButton {
            return targetAnimationValues.count
        } else {
            return 0
        }
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectedButton == pinDirectionButton {
            return String(pinDirectionValues[row])
        } else if selectedButton == balloonAnimationButton {
            return String(balloonAnimationValues[row])
        } else if selectedButton == targetAnimationButton {
            return String(targetAnimationValues[row])
        } else {
            return ""
        }
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerViewHeight.constant = 0

        if selectedButton == pinDirectionButton {
            pinDirection = pinDirectionValues[row]
            selectedButton?.setTitle(String(pinDirection), forState: .Normal)
        } else if selectedButton == balloonAnimationButton {
            balloonAnimation = balloonAnimationValues[row]
            selectedButton?.setTitle(String(balloonAnimation), forState: .Normal)
        } else if selectedButton == targetAnimationButton {
            targetAnimation = targetAnimationValues[row]
            selectedButton?.setTitle(String(targetAnimation), forState: .Normal)
        }
    }
    
    let imageString = "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"
}