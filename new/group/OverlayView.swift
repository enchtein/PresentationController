//
//  OverlayView.swift
//  new
//
//  Created by Track Ensure on 2021-05-12.
//

import UIKit

extension UILabel {
  func startBlink() {
      UIView.animate(withDuration: 0.8,
                     delay:0.0,
                     options:[.autoreverse, .repeat],
                     animations: {
                      self.alpha = 0

      }, completion: nil)
  }

  func stopBlink() {
      alpha = 1
      layer.removeAllAnimations()
  }
}
class OverlayView: UIViewController {
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
  
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var confirmButtonOutlet: UIButton!

  @IBOutlet weak var startDateLabel: UILabel!
  @IBOutlet weak var endDateLabel: UILabel!
  
  var changeState: ChangeSize?
  var state: Bool = false
  var monthAgo: Date?
  let dateFormatt = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
//        slideIdicator.roundCorners(.allCorners, radius: 10)
//        subscribeButton.roundCorners(.allCorners, radius: 10)
      self.dateFormatt.dateFormat = "yyyy-MM-dd"
      self.setupStartProperties()
    }
  func setupStartProperties() {
    self.confirmButtonOutlet.setTitle("Choise Date", for: .normal)
    let today = Date()
    self.monthAgo = Calendar.current.date(byAdding: .month, value: -1, to: today)
    self.datePicker.minimumDate = self.monthAgo
    self.datePicker.maximumDate = today
  }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
  
  @IBAction func buttonAction(_ sender: UIButton) {
    if let buttonTitle = sender.titleLabel?.text, buttonTitle.elementsEqual("Search") {
      self.dismiss(animated: true, completion: nil)
      return
    }
    
    self.state = !self.state
    self.changeState?.changeSelected(state: self.state)
//    self.setConstraints(state: self.state)
//    self.startDateLabel.alpha = 20
    self.startDateLabel.layoutIfNeeded()
    self.startDateLabel.startBlink()
//    self.startDateLabel.stopBlink()
    sender.isEnabled = false
    sender.setTitle("Search", for: .disabled)
  }
  
  @IBAction func datePickerAction(_ sender: UIDatePicker) {
    
    if let startDateLabel = self.startDateLabel.text, startDateLabel.elementsEqual("From") {
      self.startDateLabel.text = "From: "+dateFormatt.string(from: sender.date)
//      let temp = dateFormatt.string(from: sender.date)
      self.startDateLabel.stopBlink()
      self.datePicker.minimumDate = sender.date
      self.endDateLabel.startBlink()
    } else {
      self.endDateLabel.text = "To: "+dateFormatt.string(from: sender.date)
      self.endDateLabel.stopBlink()
      self.confirmButtonOutlet.isEnabled = true
      self.confirmButtonOutlet.setTitle("Search", for: .normal)
    }
  }
  
}
