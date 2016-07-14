//
//  ShrinkingNonInteractiveTransitor.swift
//  ShrinkingModalInteractiveTransitionDemo
//
//  Created by 张威 on 16/7/14.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

import UIKit

class ShrinkingNonInteractiveTransitor: NSObject, UIViewControllerTransitioningDelegate {
  
  let presentationDuration: NSTimeInterval = 0.45
  let dismissalDuration: NSTimeInterval = 0.30
//  let shrinkingTransformScale: CGFloat = 0.9
  
  private var isPresentation = false    // distinguish presentation from dismissal
  
  func animationControllerForPresentedController(presented: UIViewController,
                                                 presentingController presenting: UIViewController,
                                                                      sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    isPresentation = true
    return self
  }
  
  func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    isPresentation = false
    return self
  }
  
}

extension ShrinkingNonInteractiveTransitor: UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return isPresentation ? presentationDuration : dismissalDuration
  }
  
  var midTransformForPresentedView: CATransform3D {
    var transform = CATransform3DIdentity
    transform.m34 = -1.0/700.0
    transform = CATransform3DScale(transform, 0.95, 0.95, 1.0)
    transform = CATransform3DRotate(transform, CGFloat(M_PI_4) / 8, 1, 0, 0)
    transform.m23 = 0.0
    return transform
  }
  
  var finalTransformForPresentedView: CATransform3D {
    var transform = CATransform3DIdentity
    transform.m34 = -1.0/700.0
    transform = CATransform3DScale(transform, 0.9, 0.9, 1)
    return transform
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    let fromVC: UIViewController! = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
    let toVC: UIViewController! = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
    let containerView: UIView! = transitionContext.containerView()
    
    if isPresentation {
      var toViewTargetFrame = containerView!.bounds
      toViewTargetFrame.origin.y = (toViewTargetFrame.height / 5.0)
      toViewTargetFrame.size.height -= toViewTargetFrame.origin.y
      toVC.view.frame = toViewTargetFrame
      
      toVC.view.transform = CGAffineTransformMakeTranslation(0, toViewTargetFrame.height)
      
      containerView.addSubview(toVC.view)
    }
    
    if isPresentation {
      
      let duration = transitionDuration(transitionContext)
      
      UIView.animateWithDuration(duration,
                                 delay: 0.0, options: .CurveEaseInOut, animations: {
                                  toVC.view.transform = CGAffineTransformIdentity
        }, completion: { (finished) in
          transitionContext.completeTransition(true)
      })
      
      let duration1 = duration * 2.0 / 3.0
      let duration2 = duration - duration1
      
      UIView.animateWithDuration(duration1,
                                 delay: 0.0, options: .CurveEaseIn, animations: {
        fromVC.view.layer.transform = self.midTransformForPresentedView
        }, completion: { (finished) in
          UIView.animateWithDuration(duration2,
            delay: 0.0, options: .CurveEaseOut, animations: {
            fromVC.view.layer.transform = self.finalTransformForPresentedView
            }, completion: nil)
      })
      
    } else {
      
      let duration = transitionDuration(transitionContext)
      
      UIView.animateWithDuration(duration,
                                 delay: 0.0,
                                 options: .CurveEaseInOut,
                                 animations: {
                                  fromVC.view.transform = CGAffineTransformMakeTranslation(0, fromVC.view.bounds.height)
        },
                                 completion: { (finished) in
                                  transitionContext.completeTransition(true)
      })
      
      let duration1 = duration / 3.0
      let duration2 = duration - duration1
      
      UIView.animateWithDuration(duration1,
                                 delay: 0.0,
                                 options: .CurveEaseIn,
                                 animations: {
                                  toVC.view.layer.transform = self.midTransformForPresentedView
        },
                                 completion: { (finished) in
                                  
                                  UIView.animateWithDuration(duration2,
                                    delay: 0.0,
                                    options: .CurveEaseOut,
                                    animations: {
                                      toVC.view.layer.transform = CATransform3DIdentity
                                    },
                                    completion: nil)
      })
      
    }
  }
}
