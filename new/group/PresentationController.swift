//
//  PresentationController.swift
//  new
//
//  Created by Track Ensure on 2021-05-12.
//

import UIKit

protocol ChangeSize {
  func changeSelected(state: Bool)
}

extension PresentationController: ChangeSize {
  func changeSelected(state: Bool) {
    if self.state != state {
      self.state = state
      self.containerViewDidLayoutSubviews()
    }
  }
}

class PresentationController: UIPresentationController {

  let blurEffectView: UIVisualEffectView!
  var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
  
  override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
      let blurEffect = UIBlurEffect(style: .dark)
      blurEffectView = UIVisualEffectView(effect: blurEffect)
      super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    
    if let vc = presentedViewController as? OverlayView {
      vc.changeState = self
    }
      tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
      blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      self.blurEffectView.isUserInteractionEnabled = true
      self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
  }
  
  var state: Bool = false
  var buttonPos: CGRect?
  var currentDevice = UIDevice().sizeType
  
  override var frameOfPresentedViewInContainerView: CGRect {
//    CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.4),
//           size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height *
//            0.6))
    var viewSettings: (originHeight: CGFloat, sizeHeight: CGFloat) = (0.20, 0.80)
    switch self.currentDevice {
    case .verySmall4inch:
      viewSettings = (originHeight: 0.20, sizeHeight: 0.80)
    case .small47inch:
      viewSettings = (originHeight: 0.25, sizeHeight: 0.75)
    case .medium55inch:
      viewSettings = (originHeight: 0.28, sizeHeight: 0.72)
    case .large58inch:
      viewSettings = (originHeight: 0.30, sizeHeight: 0.70)
    case .xL61inch:
      viewSettings = (originHeight: 0.40, sizeHeight: 0.60)
    case .xXL:
      viewSettings = (originHeight: 0.40, sizeHeight: 0.60)
    case .mini12:
      viewSettings = (originHeight: 0.35, sizeHeight: 0.65)
    }
    if self.state {
      return CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * viewSettings.originHeight),//0.20
             size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height *
                            viewSettings.sizeHeight))//0.80
    } else { // 111
      let indent = self.containerView!.frame.height - 111
      return CGRect(origin: CGPoint(x: 0, y: indent),
             size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height *
                            viewSettings.sizeHeight))//0.80
    }
  }

  override func presentationTransitionWillBegin() {
      self.blurEffectView.alpha = 0
      self.containerView?.addSubview(blurEffectView)
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.alpha = 0.7
      }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
  }
  
  override func dismissalTransitionWillBegin() {
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.alpha = 0
      }, completion: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.removeFromSuperview()
      })
  }
  
  override func containerViewWillLayoutSubviews() {
      super.containerViewWillLayoutSubviews()
    presentedView!.roundCorners([.topLeft, .topRight], radius: 22)
  }

  override func containerViewDidLayoutSubviews() {
      super.containerViewDidLayoutSubviews()
//      presentedView?.frame = frameOfPresentedViewInContainerView
    if self.state {
      UIView.animate(withDuration: 1) {
        self.presentedView?.frame = self.frameOfPresentedViewInContainerView
      }
    } else {
      UIView.animate(withDuration: 1) {
        self.presentedView?.frame = self.frameOfPresentedViewInContainerView
      }
    }
      blurEffectView.frame = containerView!.bounds
  }

  @objc func dismissController(){
      self.presentedViewController.dismiss(animated: true, completion: nil)
  }
}

extension UIView {
  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
      let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                              cornerRadii: CGSize(width: radius, height: radius))
      let mask = CAShapeLayer()
      mask.path = path.cgPath
      layer.mask = mask
  }
}

