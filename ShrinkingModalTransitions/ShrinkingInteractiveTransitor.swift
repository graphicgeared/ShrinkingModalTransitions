//
//  ShrinkingInteractiveTransitor.swift
//  ShrinkingModalInteractiveTransitionDemo
//
//  Created by 张威 on 16/6/26.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

import UIKit

// subclass UIPercentDrivenInteractiveTransition
class ShrinkingInteractiveTransitor: UIPercentDrivenInteractiveTransition {
  
  let presentationDuration: NSTimeInterval = 0.5
  let dismissalDuration: NSTimeInterval = 0.25
  let shrinkingTransformScale: CGFloat = 0.9
  
  private var isPresentation = false    // distinguish presentation from dismissal
  private var isInteracting = false     // indicates whether the transition is currently interactive.
  private var shouldComplete = false    // indicates whether the transition should complete/cancel
  
  private var transitionContext: UIViewControllerContextTransitioning!
  
  private var presentedViewController: UIViewController!
  
  // before
  func attachPanGestureRecognizerToViewController(viewController: UIViewController) {
    presentedViewController = viewController
    prepareGestureRecognizerInView(presentedViewController.view)
  }
  
  private func prepareGestureRecognizerInView(view: UIView) {
    let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer(_:)))
    view.addGestureRecognizer(pan)
  }
  
  @objc private func handlePanGestureRecognizer(pan: UIPanGestureRecognizer) {
    
    switch pan.state {
      
    case .Began:
      isInteracting = true
      pan.setTranslation(CGPointZero, inView: pan.view?.superview)
      presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
      
    case .Changed:
      let translation = pan.translationInView(pan.view?.superview)
      var fraction = translation.y / CGRectGetHeight(presentedViewController!.view.bounds)
      fraction = fmax(0.0, fmin(1.0, fraction))
      shouldComplete = (fraction >= 0.5)
      updateInteractiveTransition(fraction)
      
    case .Cancelled, .Ended:
      isInteracting = false
      
      if pan.state == .Cancelled || !shouldComplete {
        cancelInteractiveTransition()
      } else {
        finishInteractiveTransition()
        
        // remove gesture recognizer
        presentedViewController.view.removeGestureRecognizer(pan)
      }
      
    default:
      break
    }
  }
  
  override func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
    super.startInteractiveTransition(transitionContext)
    
    self.transitionContext = transitionContext
  }
  
  override func updateInteractiveTransition(percentComplete: CGFloat) {
    super.updateInteractiveTransition(percentComplete)
    let presentingVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
    presentingVC?.view.transform = CGAffineTransformMakeScale(0.9+0.1*percentComplete, 0.9+0.1*percentComplete)
  }
  
  override func finishInteractiveTransition() {
    super.finishInteractiveTransition()
    let presentingVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
    UIView.animateWithDuration((1.0 - Double(percentComplete)) * (isPresentation ? presentationDuration : dismissalDuration)) {
      presentingVC?.view.transform = CGAffineTransformIdentity
    }
  }
  
  override func cancelInteractiveTransition() {
    super.cancelInteractiveTransition()
    let presentingVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
    UIView.animateWithDuration((1.0 - Double(percentComplete)) * (isPresentation ? presentationDuration : dismissalDuration)) {
      presentingVC?.view.transform = CGAffineTransformMakeScale(self.shrinkingTransformScale, self.shrinkingTransformScale)
    }
  }
}

extension ShrinkingInteractiveTransitor: UIViewControllerTransitioningDelegate {
  
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
  
  func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return isInteracting ? self : nil
  }
}

extension ShrinkingInteractiveTransitor: UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return isPresentation ? presentationDuration : dismissalDuration
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
      UIView.animateWithDuration(transitionDuration(transitionContext),
                                 delay: 0.0,
                                 usingSpringWithDamping: 0.6,
                                 initialSpringVelocity: 0.0,
                                 options: .CurveEaseInOut,
                                 animations: {
                                  toVC.view.transform = CGAffineTransformIdentity
                                  fromVC.view.transform = CGAffineTransformMakeScale(self.shrinkingTransformScale, self.shrinkingTransformScale)
        },
                                 completion: { (finished) in
                                  transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
      })
    } else {
      
      UIView.animateWithDuration(transitionDuration(transitionContext),
                                 animations: {
        
                                  fromVC.view.transform = CGAffineTransformMakeTranslation(0, fromVC.view.bounds.height)
        
                                  if !transitionContext.isInteractive() {
                                    toVC.view.transform = CGAffineTransformIdentity
                                  }
        },
                                 completion: { (finished) in
                                  transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
      })
    }
  }
}
