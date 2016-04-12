//
//  Pencil.swift
//  PaintKit
//
//  Created by Kari Kraam on 08/04/2016.
//  Copyright © 2016 Fresh Leaf. All rights reserved.
//

import UIKit

//  Hermite interplation Pencil Implementation

class Pencil : Page, Scribblable
{
    var penWidth: CGFloat?                  //The width of Pencil
    var penStrokeColor: CGColor?            //The color of Pencil
    
    let hermitePath = UIBezierPath()        //Instance of UIBezierPath Class
    var interpolationPoints = [CGPoint]()   //Interpolated Points
    
    func beginDrawing(point: CGPoint)
    {
        interpolationPoints = [point]
    }
    
    func appendDrawing(point: CGPoint)
    {
        interpolationPoints.append(point)
        
        hermitePath.removeAllPoints()
        
        hermitePath.interpolatePointsWithHermite(interpolationPoints)
        
        drawingLayer.path = hermitePath.CGPath
    }
    
    func endDrawing()
    {
        if let backgroundPath = backgroundLayer.path
        {
            hermitePath.appendPath(UIBezierPath(CGPath: backgroundPath))
        }
        
        backgroundLayer.path = hermitePath.CGPath
        
        hermitePath.removeAllPoints()
        
        drawingLayer.path = hermitePath.CGPath
    }
    
    func clearDrawing()
    {
        backgroundLayer.path = nil
    }
}
