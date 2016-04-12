//
//  Page.swift
//  PaintKit
//
//  Created by Kari Kraam on 08/04/2016.
//  Copyright © 2016 Fresh Leaf. All rights reserved.
//

//  Scribblable Page Class

import UIKit

class Page: UIView
{
    let backgroundLayer = CAShapeLayer()
    let drawingLayer = CAShapeLayer()
    
    let titleLabel = UILabel()
    
    //Pencil Property Init
    required init(title: String)
    {
        super.init(frame: CGRectZero)
        
        backgroundLayer.strokeColor = UIColor.darkGrayColor().CGColor
        backgroundLayer.fillColor = nil
        backgroundLayer.lineWidth = 2
        
        drawingLayer.strokeColor = UIColor.blackColor().CGColor
        drawingLayer.fillColor = nil
        drawingLayer.lineWidth = 2
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(drawingLayer)
        
        titleLabel.text = title
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor.blueColor()
        addSubview(titleLabel)
        
        layer.borderColor = UIColor.blueColor().CGColor
        layer.borderWidth = 1
        
        layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews()
    {
        titleLabel.frame = CGRect(x: 0,
                                  y: frame.height - titleLabel.intrinsicContentSize().height - 2,
                                  width: frame.width,
                                  height: titleLabel.intrinsicContentSize().height)
    }
}
