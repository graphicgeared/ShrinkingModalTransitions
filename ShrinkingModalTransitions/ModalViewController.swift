//
//  ModalViewController.swift
//  ShrinkingModalInteractiveTransitionDemo
//
//  Created by 张威 on 16/6/26.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {
  
  var dismissButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // CABasicAnimation
    // CAKeyframeAnimation
    // kCAMediaTimingFunctionLinear
    
    /*
     kCAMediaTimingFunctionLinear
     kCAMediaTimingFunctionEaseIn
     kCAMediaTimingFunctionEaseOut
     kCAMediaTimingFunctionEaseInEaseOut
     kCAMediaTimingFunctionDefault
     */
    
    let lightRedColor = UIColor(red: 240.0/255.0, green: 145.0/255.0, blue: 146.0/255.0, alpha: 1.0)
    let lightYellowColor = UIColor(red: 253.0/255.0, green: 224.0/255.0, blue: 165.0/255.0, alpha: 1.0)
    
    view.backgroundColor = lightYellowColor
    
    let viewBounds = view.bounds
    
    dismissButton = UIButton(frame: CGRectMake((viewBounds.width-100)/2, (viewBounds.height-40)/2, 100, 40))
    dismissButton.backgroundColor = lightRedColor
    dismissButton.layer.cornerRadius = 5.0
    dismissButton.layer.borderWidth = 1.0
    dismissButton.layer.borderColor = lightRedColor.CGColor
    dismissButton.layer.masksToBounds = true
    dismissButton.addTarget(self, action: #selector(buttonClicked(_:)), forControlEvents: .TouchUpInside)
    dismissButton.setTitle("Dismiss", forState: .Normal)
    dismissButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    dismissButton.titleLabel?.font = UIFont.systemFontOfSize(14.0)
    view.addSubview(dismissButton)
  }
  
  override func viewWillLayoutSubviews() {
    dismissButton.center = CGPointMake(view.bounds.midX, view.bounds.midY)
    super.viewWillLayoutSubviews()
  }
  
  @objc func buttonClicked(sender: UIButton) {
    dismissViewControllerAnimated(true) {}
  }
}
