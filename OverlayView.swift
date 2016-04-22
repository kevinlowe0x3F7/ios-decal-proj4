//
//  OverlayView.swift
//  LocalEats
//
//  Created by Kevin Lowe on 4/22/16.
//  Copyright © 2016 Kevin Lowe. All rights reserved.
//
//  OverlayView class from SwiftTinderCards
//  https://github.com/lgandecki/SwiftTinderCards

import UIKit
enum OverlayViewMode {
    case None
    case Left
    case Right
}
    
    
class OverlayView:UIView {
    var imageView = UIImageView()
    var mode = OverlayViewMode.None
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        setView()
        addImageView()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    func addImageView() {
        setImageViewFrame()
        self.addSubview(imageView)
    }
        
    func setImageViewFrame() {
        let imageWidth = self.frame.size.width / 3
        let imageHeight = imageWidth * 2 / 3
        imageView.frame = CGRectMake(self.frame.size.width / 2 - (imageWidth / 2), self.frame.size.height / 2 - (imageHeight / 2), imageWidth, imageHeight)
        
    }
    func setMyImageView(buttonString: String) {
        imageView.image = UIImage(named: buttonString)
    }
    
    func setMode(mode: OverlayViewMode) {
        if (self.mode == mode) {
            return;
        }
        self.mode = mode;
        
        switch (mode) {
        case .Left:
            setMyImageView("no_stamp_trans.png")
            break;
        case .Right:
            setMyImageView("yes_stamp_trans.png")
            break;
        case .None:
            break;
        }
    }

}
