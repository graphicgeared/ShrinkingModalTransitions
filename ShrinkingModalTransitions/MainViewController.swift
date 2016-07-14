//
//  MainViewController.swift
//  ShrinkingModalInteractiveTransitionDemo
//
//  Created by 张威 on 16/6/26.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  var presentButton: UIButton!
  var modeSwitch: UISwitch!
  
  var presenter: UIViewControllerTransitioningDelegate!
 
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let lightRedColor = UIColor(red: 240.0/255.0, green: 145.0/255.0, blue: 146.0/255.0, alpha: 1.0)
    let lightYellowColor = UIColor(red: 253.0/255.0, green: 224.0/255.0, blue: 165.0/255.0, alpha: 1.0)
    
    view.backgroundColor = lightRedColor
    
    let viewBounds = view.bounds
    
    /* present switch */
    modeSwitch = UISwitch(frame: CGRectMake((viewBounds.width-140)/2, (viewBounds.height-40)/2, 51, 31))
    view.addSubview(modeSwitch)
    
    let infoLabel = UILabel(frame: CGRectMake(CGRectGetMaxX(modeSwitch.frame) + 10, (viewBounds.height-40)/2, 79, 31))
    infoLabel.textAlignment = .Right
    infoLabel.text = "Interactive"
    infoLabel.font = UIFont.systemFontOfSize(14.0)
    infoLabel.textColor = lightYellowColor
    view.addSubview(infoLabel)
    
    /* present button */
    presentButton = UIButton(frame: CGRectMake((viewBounds.width-200)/2, CGRectGetMaxY(modeSwitch.frame) + 10, 200, 40))
    presentButton.backgroundColor = lightYellowColor
    presentButton.layer.cornerRadius = 5.0
    presentButton.layer.borderWidth = 1.0
    presentButton.layer.borderColor = lightYellowColor.CGColor
    presentButton.layer.masksToBounds = true
    presentButton.addTarget(self, action: #selector(buttonClicked(_:)), forControlEvents: .TouchUpInside)
    presentButton.setTitle("Show Modal View Controller", forState: .Normal)
    presentButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
    presentButton.titleLabel?.font = UIFont.systemFontOfSize(14.0)
    view.addSubview(presentButton)
  }
  
  @objc func buttonClicked(sender: UIButton) {
    let mvc =  ModalViewController()
    mvc.modalPresentationStyle = .Custom
    
    if modeSwitch.on {
      presenter = ShrinkingInteractiveTransitor()
    } else {
      presenter = ShrinkingNonInteractiveTransitor()
    }
    mvc.transitioningDelegate = presenter
    
    // before presenting mvc, should invoked wireToViewController
    (presenter as? ShrinkingInteractiveTransitor)?.attachPanGestureRecognizerToViewController(mvc)
    presentViewController(mvc, animated: true) {
    }
  }
}

