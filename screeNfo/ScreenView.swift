//
//  ScreenView.swift
//  screeNfo
//
//  Created by Ayra Obazee on 10/03/2017.
//  Copyright © 2017 sourcepad. All rights reserved.
//

import ScreenSaver

class ScreenView : ScreenSaverView {
    
    var defaultsManager: DefaultsManager = DefaultsManager()
    lazy var sheetController: ConfigureSheetController = ConfigureSheetController()
    var textDrawingRect = CGRect(x: 0, y: 0, width: 200, height: 200)
    var textDrawingColor: NSColor!
    var changeBy: NSPoint!
    var lastColorChange: Date!
    var textString: NSString!
    var image: NSImage?
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)!
        loadConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func hasConfigureSheet() -> Bool {
        return true
    }
    
    override func configureSheet() -> NSWindow? {
        return sheetController.window
    }

    
    override func startAnimation() {
        super.startAnimation()
        needsDisplay = true
    }
    
    override func stopAnimation() {
        super.stopAnimation()
    }
    

    override func draw(_ rect: NSRect) {
        super.draw(rect)
        startAnimation()
     }
    
    override func animateOneFrame() {
        self.showTexts()
    }
    
    // MARK: - Methods
    
    func randomColor() -> NSColor {
        let colorTag = SSRandomIntBetween(1, 5)
        switch colorTag {
        case 1:
            return NSColor.yellow
        case 2:
            return NSColor.cyan
        case 3:
            return NSColor.magenta
        case 4:
            return NSColor.green
        case 5:
            return NSColor.orange
        default:
            return NSColor.yellow
        }
    }
    
    func wrapString(_ string: String, toLength len: CGFloat, withAttributes attribs: [String: AnyObject]) -> String {
        var newString = String()
        var newLines = [AnyObject]()
        let words = string.components(separatedBy: " ")
        for theWord: String in words {
            if (newString == "") {
                newString += theWord
            }
            else {
                let testString = newString.appendingFormat(" %@", theWord)
                let testSize = testString.size(withAttributes: attribs)
                if testSize.width > len {
                    newLines.append(newString as AnyObject)
                    newString = theWord
                }
                else {
                    newString += " \(theWord)"
                }
            }
        }
        newLines.append(newString as AnyObject)
        return (newLines as NSArray).componentsJoined(by: "\n")
    }
    
    
    func randomRectForSize(_ requiredSize: NSSize) -> NSRect {
        let viewBounds = self.bounds
        let screenWidth: CGFloat = viewBounds.size.width
        let screenHeight: CGFloat = viewBounds.size.height
        let textWidth: CGFloat = requiredSize.width
        let textHeight: CGFloat = requiredSize.height
        let textLeft: CGFloat = SSRandomFloatBetween(0, screenWidth - textWidth)
        let textTop: CGFloat = SSRandomFloatBetween(0, screenHeight - textHeight)
        let textRect = NSMakeRect(textLeft, textTop, textWidth, textHeight)
        return textRect
    }
    
    
    func rectIsOutOfBounds(_ theRect: NSRect) -> Bool {
        if theRect.origin.x < 0 || theRect.origin.y < 0 {
            return true
        }
        let viewBounds = self.bounds
        if theRect.origin.x + theRect.size.width > viewBounds.size.width {
            return true
        }
        if theRect.origin.y + theRect.size.height > viewBounds.size.height {
            return true
        }
        return false
    }
    
    
    func changeDirection(_ theRect: NSRect) -> NSPoint {
        let viewBounds = self.bounds
        var newChangeBy = self.changeBy
        if theRect.origin.x < 0 {
            newChangeBy?.x = 1
        }
        else if theRect.origin.y < 0 {
            newChangeBy?.y = 1
        }
        else if theRect.origin.x + theRect.size.width > viewBounds.size.width {
            newChangeBy?.x = -1
        }
        else if theRect.origin.y + theRect.size.height > viewBounds.size.height {
            newChangeBy?.y = -1
        }
        
        return newChangeBy!
    }
    
    
    func adjustCurrentRect(_ theRect: NSRect, forSize requiredSize: NSSize) -> NSRect {
        let textWidth: CGFloat = requiredSize.width
        let textHeight: CGFloat = requiredSize.height
        let textRect = NSMakeRect(theRect.origin.x, theRect.origin.y, textWidth, textHeight)
        return textRect
    }
    
    
    func showTexts() {
        if self.textDrawingRect.size.width > 0 {
            NSColor.black.set()
            NSBezierPath.fill(self.frame)
        }
        
        var fontSize: CGFloat = self.bounds.size.width / 50
        if fontSize < 10 {
            fontSize = 10
        }
        
        var textAttribs = [NSFontAttributeName: NSFont.boldSystemFont(ofSize: fontSize)] as NSDictionary
        let wrapWidth: CGFloat = fontSize * 12
        let wrappedText = self.wrapString(self.textString as String, toLength: wrapWidth, withAttributes: textAttribs as! [String : AnyObject])

        let textSize = wrappedText.size(withAttributes: textAttribs as? [String : AnyObject])
        
        if self.textDrawingRect.size.width == 0 {
            self.textDrawingRect = self.randomRectForSize(textSize)
            self.textDrawingColor = self.randomColor()
        }else {
            var newRect = self.textDrawingRect
            newRect.origin.x += self.changeBy.x
            newRect.origin.y += self.changeBy.y
            
            if self.rectIsOutOfBounds(newRect) {
                self.changeBy = self.changeDirection(newRect)
                var newRect = self.textDrawingRect
                newRect.origin.x += self.changeBy.x
                newRect.origin.y += self.changeBy.y
                self.textDrawingRect = newRect
                
                var pickNewColor = true
                if let _ = lastColorChange, let _ = textDrawingColor {
                    let timeSinceLastChange = -self.lastColorChange.timeIntervalSinceNow
                    if timeSinceLastChange < 0.5 {
                        pickNewColor = false
                    }
                }
                if pickNewColor {
                    var newColor = self.randomColor()
                    if (self.textDrawingColor != nil) {
                        while newColor.isEqual(self.textDrawingColor) {
                            newColor = self.randomColor()
                        }
                    }
                    self.textDrawingColor = newColor
                    self.lastColorChange = Date()
                }
                self.textString = self.textToDisplay() as NSString!
                self.textDrawingRect = self.adjustCurrentRect(self.textDrawingRect, forSize: textSize)
            }else {
                self.textDrawingRect = newRect
            }
        }
        
        
        textAttribs = [NSFontAttributeName: NSFont.boldSystemFont(ofSize: fontSize), NSForegroundColorAttributeName: self.textDrawingColor]
        wrappedText.draw(at: self.textDrawingRect.origin, withAttributes: textAttribs as? [String : AnyObject])

    }
    
    func textToDisplay() -> String {
        return "Hello world! This is a sample text from House Slytherin."
    }
    
    func loadConfig() {
        self.animationTimeInterval = 1 / 30.0
        self.changeBy = NSMakePoint(1, 1)
        self.textDrawingColor = self.randomColor()
        self.textString = self.textToDisplay() as NSString!
    }
    
    func loadImage() {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            let url = URL(string: "https://raw.githubusercontent.com/yomajkel/ImageStream/added-swift-image/assets/swift.png")
            let data = try? Data(contentsOf: url!)
            if let data = data {
                self.image = NSImage(data: data)
                self.needsDisplay = true
            }
        }
    }
    
    func drawImage() {
        if let image = image {
            let point = CGPoint(x: (frame.size.width - image.size.width) / 2, y: (frame.size.height - image.size.height) / 2)
            image.draw(at: point, from: NSZeroRect, operation: .sourceOver, fraction: 1)
        }
    }
    
}
    

