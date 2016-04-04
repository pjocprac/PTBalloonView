//
//  PTBalloonLabel.swift
//  PTBalloonView
//
//  Created by Takeshi Watanabe on 2016/04/04.
//  Copyright © 2016 Takeshi Watanabe. All rights reserved.
//

import Foundation
import UIKit

public class PTBalloonLabel : PTBalloonView {
    // MARK: Content View's Subviews
    private var titleLabel      = UILabel()
    private var textLabel       = UILabel()
    private var buttonContainer = UIView()

    // MARK: Private properties
    private var buttons      : [UIButton]    = []
    private var closeButtons : [UIButton]    = []
    private var handlers     : [(()->Void)?] = []

    // MARK: Title Area's Properties
    public private(set) var title      : String? = nil
    public private(set) var titleFont  : UIFont  = UIFont.boldSystemFontOfSize(16)
    public private(set) var titleColor : UIColor = UIColor(red: 232/255, green: 245/255, blue: 233/255, alpha: 1)
    
    /// Title of the balloon label. If not set (default), title area is hided. (Default nil)
    public func title(value: String?) -> Self {
        self.title = value
        return self
    }
    
    /// Font setting of the balloon label's title. (Default: boldSystemFontOfSize(16))
    public func titleFont(value: UIFont) -> Self {
        self.titleFont = value
        return self
    }
    
    /// Color setting of the balloon label's title. (Default: light green)
    public func titleColor(value: UIColor) -> Self {
        self.titleColor = value
        return self
    }
    
    // MARK: Text Area's Properties
    public private(set) var text      : String? = nil
    public private(set) var textFont  : UIFont  = UIFont.systemFontOfSize(14)
    public private(set) var textColor : UIColor = UIColor(red: 232/255, green: 245/255, blue: 233/255, alpha: 1)

    /// Text content of the balloon label.
    public func text(value: String?) -> Self {
        self.text = value
        return self
    }
    
    /// Font setting of the balloon text's title. (Default: boldSystemFontOfSize(14))
    public func textFont(value: UIFont) -> Self {
        self.textFont = value
        return self
    }
    
    /// Color setting of the balloon label's text. (Default: light green)
    public func textColor(value: UIColor) -> Self {
        self.textColor = value
        return self
    }

    // MARK: Button Area's Properties
    public private(set) var buttonFont      : UIFont  = UIFont.boldSystemFontOfSize(16)
    public private(set) var buttonTextColor : UIColor = UIColor(red: 232/255, green: 245/255, blue: 233/255, alpha: 1)
    public private(set) var buttonHeight    : CGFloat = 24

    /// Font setting of the balloon text's buttons. (Default: boldSystemFontOfSize(16))
    public func buttonFont(value: UIFont) -> Self {
        self.buttonFont = value
        return self
    }
    
    /// Color setting of the balloon label's buttons. (Default: light green)
    public func buttonTextColor(value: UIColor) -> Self {
        self.buttonTextColor = value
        return self
    }
    
    /// Height of the balloon label's buttons. (Default: 24.0)
    public func buttonHeight(value: CGFloat) -> Self {
        self.buttonHeight = value
        return self
    }

    // MARK: Balloon's Style Properties
    public private(set) var maxWidth : CGFloat? = nil
    
    /// Max width of balloon label. If not set (default), max width is set screen width x 0.8
    public func maxWidth(value: CGFloat?) -> Self {
        self.maxWidth = value
        return self
    }

    override public init() {
        super.init()
        
        titleLabel.textAlignment = .Center
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .ByWordWrapping
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Add button with title.
     
     - parameters:
        - title  : Title of button.
        - type   : Button type. If .Close is set, button behave close button. (Default: .Normal)
        - handler: The handler which is executed at button tapped. (Default: nil)
     */
    public func addButton(title title: String?, type: PTBalloonLabelButtonType = .Normal, handler: (()->Void)? = nil) -> Self {
        let button = UIButton(type: .System)
        button.setTitle(title, forState: .Normal)
        
        buttons.append(button)
        if type == .Close {
            closeButtons.append(button)
        }
        handlers.append(handler)
        return self
    }
    
    /**
     Add button with UIButton.
     
     - parameters:
        - button : User's predefined button.
        - type   : Button type. If .Close is set, button behave close button. (Default: .Normal)
        - handler: The handler which is executed at button tapped. (Default: nil)
     */
    public func addButton(button button: UIButton, type: PTBalloonLabelButtonType = .Normal, handler: (()->Void)? = nil) -> Self {
        buttons.append(button)
        if type == .Close {
            closeButtons.append(button)
        }
        handlers.append(handler)
        return self
    }
    
    private func setupView() {
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        
        let maxWidth : CGFloat
        if self.maxWidth != nil {
            maxWidth = self.maxWidth!
        } else {
            maxWidth = UIScreen.mainScreen().bounds.width * 0.8
        }
        
        var realWidth : CGFloat = contentView.bounds.width
        
        // estimate size
        titleLabel.frame = CGRectZero
        textLabel.frame = CGRectZero
        buttonContainer.frame = CGRectZero
        
        if let title = self.title {
            contentView.addSubview(titleLabel)
            
            titleLabel.text = title
            titleLabel.textColor = titleColor
            titleLabel.font = titleFont
            
            let fitSize = titleLabel.sizeThatFits(CGSizeMake(maxWidth, CGFloat.max))
            realWidth = max(realWidth, fitSize.width)
        }
        
        if let text = self.text {
            contentView.addSubview(textLabel)
            
            textLabel.text = text
            textLabel.textColor = textColor
            textLabel.font = textFont

            let fitSize = textLabel.sizeThatFits(CGSizeMake(maxWidth, CGFloat.max))
            realWidth = max(realWidth, fitSize.width)
        }
        
        realWidth = min(realWidth, maxWidth)

        if let title = self.title {
            let fitSize = titleLabel.sizeThatFits(CGSizeMake(realWidth, CGFloat.max))
            titleLabel.frame = CGRectMake(0, 0, realWidth, fitSize.height)
        }
        
        if let text = self.text {
            let fitSize = textLabel.sizeThatFits(CGSizeMake(realWidth, CGFloat.max))
            textLabel.frame = CGRectMake(0,
                                         titleLabel.bounds.height == 0 ? 0 : titleLabel.bounds.height + 4,
                                         realWidth, fitSize.height)
        }
        
        if buttons.count > 0 {
            contentView.addSubview(buttonContainer)
            let upperViewBottom = max(titleLabel.frame.origin.y + titleLabel.frame.height, textLabel.frame.origin.y + textLabel.frame.height)
            buttonContainer.frame = CGRectMake(0, upperViewBottom + 4, realWidth, buttonHeight)
            
            let buttonWidth = realWidth / CGFloat(buttons.count)
            for i in 0 ..< buttons.count {
                let button = buttons[i]
                button.tintColor = buttonTextColor
                button.titleLabel?.font = buttonFont
                button.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
                
                buttonContainer.addSubview(button)
                button.frame = CGRectMake(buttonWidth * CGFloat(i), 0, buttonWidth, buttonHeight)
            }
        }
        
        contentView.bounds = CGRectMake(0, 0, realWidth,
            max(titleLabel.frame.origin.y + titleLabel.frame.height,
                textLabel.frame.origin.y + textLabel.frame.height,
                buttonContainer.frame.origin.y + buttonContainer.frame.height))
    }
    
    public func buttonTapped(sender: UIButton) {
        if closeButtons.indexOf(sender) != nil {
            deflate()
        }

        if let index = buttons.indexOf(sender) {
            if let handler = handlers[index] {
                handler()
            }
        }
    }
    
    override public func inflate(targetView : UIView, inView : UIView? = nil, completion : ((Bool)->Void)? = nil) -> Void {
        // setup contentView
        setupView()
        
        super.inflate(targetView, inView: inView, completion: completion)
    }
}

public enum PTBalloonLabelButtonType {
    /// Normal button, operation is defined by the handler.
    case Normal
    /// Close button.
    case Close
}