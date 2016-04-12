//
//  Scribblable.swift
//  PaintKit
//
//  Created by Kari Kraam on 08/04/2016.
//  Copyright © 2016 Fresh Leaf. All rights reserved.
//

import UIKit

// MARK: Scribblable protocol

protocol Scribblable
{
    func beginDrawing(point: CGPoint)
    func appendDrawing(point: CGPoint)
    func endDrawing()
    func clearDrawing()
}
