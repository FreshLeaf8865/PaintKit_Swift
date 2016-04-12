//
//  ViewController.swift
//  PaintKit
//
//  Created by Kari Kraam on 4/8/2016.
//  Copyright (c) 2016 Fresh Leaf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//  @IBOutlet weak var mainImageView: UIImageView!
//  @IBOutlet weak var tempImageView: UIImageView!

  var lastPoint = CGPoint.zero
  var red: CGFloat = 0.0
  var green: CGFloat = 0.0
  var blue: CGFloat = 0.0
  var brushWidth: CGFloat = 10.0
  var opacity: CGFloat = 1.0
  var swiped = false
    
  let colors: [(CGFloat, CGFloat, CGFloat)] = [
    (0, 0, 0),
    (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
    (1.0, 0, 0),
    (0, 0, 1.0),
    (51.0 / 255.0, 204.0 / 255.0, 1.0),
    (102.0 / 255.0, 204.0 / 255.0, 0),
    (102.0 / 255.0, 1.0, 0),
    (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
    (1.0, 102.0 / 255.0, 0),
    (1.0, 1.0, 0),
    (1.0, 1.0, 1.0),
  ]
    
  let stackView = UIStackView()
    
  let scrollPageView = Pencil(title: "Hermite Interpolation")
  var touchOrigin: Page?
    
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    view.addSubview(stackView)
    
    stackView.addArrangedSubview(scrollPageView)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Actions

  @IBAction func reset(sender: AnyObject) {
    scrollPageView.clearDrawing()
  }

//  @IBAction func share(sender: AnyObject) {
//    UIGraphicsBeginImageContext(mainImageView.bounds.size)
//    mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, 
//      width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
//    let image = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//     
//    let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
//    presentViewController(activity, animated: true, completion: nil)
//  }
  
  @IBAction func eraserPressed(sender: AnyObject) {
    
//    var index = sender.tag ?? 0
//    if index < 0 || index >= colors.count {
//      index = 0
//    }
    
    (red, green, blue) = colors[10]
//    
//    if index == colors.count - 1 {
//      opacity = 1.0
//    }
  }
    
  @IBAction func pencilPressed(sender: AnyObject)
  {
    (red, green, blue) = colors[0]
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//    swiped = false
//    if let touch = touches.first{
//      lastPoint = touch.locationInView(self.view)
//    }
//  }
    guard let
        location = touches.first?.locationInView(self.view) else
    {
        return
    }
    
    if(scrollPageView.frame.contains(location))
    {
        touchOrigin = scrollPageView
    }
    else
    {
        touchOrigin = nil
        return
    }
    
    if let adjustedLocationInView = touches.first?.locationInView(touchOrigin)
    {
        scrollPageView.beginDrawing(adjustedLocationInView)
    }
  }
  
//  func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
//    
//    // 1
//    UIGraphicsBeginImageContext(view.frame.size)
//    let context = UIGraphicsGetCurrentContext()
//    tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
//    
//    // 2
//    CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
//    CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
//    
//    // 3
//    CGContextSetLineCap(context, CGLineCap.Round)
//    CGContextSetLineWidth(context, brushWidth)
//    CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
//    CGContextSetBlendMode(context, CGBlendMode.Normal)
//    
//    // 4
//    CGContextStrokePath(context)
//    
//    // 5
//    tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
//    tempImageView.alpha = opacity
//    UIGraphicsEndImageContext()
//    
//  }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        swiped = true

        guard let
            touch = touches.first,
            coalescedTouches = event?.coalescedTouchesForTouch(touch),
            touchOrigin = touchOrigin
            else
        {
            return
        }
        
        coalescedTouches.forEach
            {
                scrollPageView.appendDrawing($0.locationInView(touchOrigin))
            }
    }
  
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if !swiped
        {
            scrollPageView.endDrawing()        // draw a single point
        }
    }
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?)
    {
        if motion == UIEventSubtype.MotionShake
        {
            scrollPageView.clearDrawing()
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        stackView.frame = CGRect(x: 0,
            y: topLayoutGuide.length,
            width: view.frame.width,
            height: view.frame.height - topLayoutGuide.length).insetBy(dx: 10, dy: 35)
        
        stackView.axis = view.frame.width > view.frame.height
            ? UILayoutConstraintAxis.Horizontal
            : UILayoutConstraintAxis.Vertical
        
        stackView.spacing = 10
        
        stackView.distribution = UIStackViewDistribution.FillEqually
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let settingsViewController = segue.destinationViewController as! SettingsViewController
        settingsViewController.delegate = self
        settingsViewController.brush = brushWidth
        settingsViewController.opacity = opacity
        settingsViewController.red = red
        settingsViewController.green = green
        settingsViewController.blue = blue
    }
  
}

extension ViewController: SettingsViewControllerDelegate {
  func settingsViewControllerFinished(settingsViewController: SettingsViewController) {
    self.brushWidth = settingsViewController.brush
    self.opacity = settingsViewController.opacity
    self.red = settingsViewController.red
    self.green = settingsViewController.green
    self.blue = settingsViewController.blue
  }
}

