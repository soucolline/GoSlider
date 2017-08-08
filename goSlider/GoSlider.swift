//
//  GoSlider.swift
//  goSlider
//
//  Created by Thomas Guilleminot on 14/07/2017.
//  Copyright © 2017 Thomas Guilleminot. All rights reserved.
//

import Foundation
import UIKit

protocol GoSliderDelegate {
  func didFinishSlideAnimation()
}

@IBDesignable class GoSlider: UIView {
  
  @IBInspectable var roundButtonColor: UIColor {
    get {
      return self._roundButtonColor
    }
    
    set(newValue) {
      self._roundButtonColor = newValue
    }
  }
  
  @IBInspectable var sliderBackgroundColor: UIColor {
    get {
      return self._sliderBackgroundColor
    }
    
    set(newValue) {
      self._sliderBackgroundColor = newValue
    }
  }
  
  @IBInspectable var selectedRoundButtonColor: UIColor {
    get {
      return self._selectedRoundButtonColor
    }
    
    set(newValue) {
      self._selectedRoundButtonColor = newValue
    }
  }
  
  @IBInspectable var selectedSliderBackgroundColor: UIColor {
    get {
      return self._selectedSliderBackgroundColor
    }
    
    set(newValue) {
      self._selectedSliderBackgroundColor = newValue
    }
  }
  
  @IBInspectable var buttonText: String {
    get {
      return self._buttonText
    }
    
    set(newValue) {
      self._buttonText = newValue
    }
  }
  
  @IBInspectable var backgroundImage: UIImage {
    get {
      return self._backgroundImage
    }
    
    set(newValue) {
      self._backgroundImage = newValue
    }
  }
  
  private var _buttonText: String = "GO"
  private var _backgroundImage: UIImage = UIImage(named: "navya_app_go")!
  private var _roundButtonColor: UIColor = UIColor.fromRGB(rgbValue: 0x00b1ff)
  private var _sliderBackgroundColor: UIColor = UIColor.fromRGB(rgbValue: 0x00b1ff)
  private var _selectedRoundButtonColor: UIColor = UIColor.fromRGB(rgbValue: 0x36dd36)
  private var _selectedSliderBackgroundColor: UIColor = UIColor.fromRGB(rgbValue: 0x36dd36)
  
  var roundBtnView: UIView!
  var backgroundView: UIView!
  var btn: UIButton!
  var backgroundImageView: UIImageView!
  
  var delegate: GoSliderDelegate?
  let generator = UIImpactFeedbackGenerator(style: .heavy)
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    // Set background
    self.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
    self.backgroundView.backgroundColor = self.sliderBackgroundColor
    self.backgroundView.clipsToBounds = true
    self.backgroundView.layer.cornerRadius = 37.0
    self.backgroundView.alpha = 0.3
    self.addSubview(self.backgroundView)
    
    // Set background image
    self.backgroundImageView = UIImageView(frame: CGRect(x: (self.backgroundView.frame.size.width / 2) - 22, y: (self.backgroundView.frame.size.height / 2) - 16, width: 44, height: 32))
    self.backgroundImageView.image = self.backgroundImage
    self.backgroundImageView.contentMode = .scaleAspectFit
    self.addSubview(self.backgroundImageView)
    
    // Set btn View
    self.roundBtnView = UIView(frame: CGRect(x: 0, y: 0, width: 71, height: self.frame.size.height))
    self.roundBtnView.backgroundColor = self.roundButtonColor
    self.roundBtnView.clipsToBounds = true
    self.roundBtnView.layer.cornerRadius = self.roundBtnView.frame.size.width / 2
    self.addSubview(self.roundBtnView)
    
    // Set btn
    self.btn = UIButton(type: .system)
    self.btn.setTitle(self.buttonText, for: .normal)
    self.btn.tintColor = UIColor.white
    self.btn.frame = CGRect(x: 0, y: 0, width: self.roundBtnView.frame.size.width, height: self.roundBtnView.frame.size.height)
    self.roundBtnView.addSubview(btn)
    
    // Set btn drag action
    let pan = UIPanGestureRecognizer(target: self, action: #selector(dragSlider(panGesture:)))
    btn.addGestureRecognizer(pan)
    
    // Set haptic feedback
    self.generator.prepare()
  }
  
  func moveSlider() {
    UIView.animate(withDuration: 0.5, animations: {
      self.roundBtnView.frame.origin.x = (self.backgroundView.frame.maxX - self.roundBtnView.frame.width)
      self.roundBtnView.backgroundColor = self.selectedRoundButtonColor
      self.backgroundView.backgroundColor = self.selectedSliderBackgroundColor
    }, completion: { finished in
      self.delegate?.didFinishSlideAnimation()
      self.btn.isUserInteractionEnabled = false
    })
  }
  
  func resetSlider() {
    UIView.animate(withDuration: 0.5) {
      self.roundBtnView.frame.origin.x = self.backgroundView.frame.minX
      self.roundBtnView.backgroundColor = self.roundButtonColor
      self.backgroundView.backgroundColor = self.sliderBackgroundColor
      self.btn.isUserInteractionEnabled = true
    }
  }
  
  @IBAction func didPressReset(_ sender: UIButton) {
    self.resetSlider()
  }
  
  func dragSlider(panGesture recognizer: UIPanGestureRecognizer) {
    let btnY = self.btn.frame.origin.y
    
    switch recognizer.state {
      case .changed:
        let newX = recognizer.translation(in: self.btn).x
        
        guard newX < 130.0 && newX > 0.0
          else { return }
        
        self.roundBtnView.frame.origin = CGPoint(x: newX, y: btnY)
      
      case .ended:
        let lastX = recognizer.translation(in: self.btn).x
        if lastX >= 100 {
          self.generator.impactOccurred()
          self.moveSlider()
        } else {
          self.resetSlider()
        }
      
      default: ()
    }
  }
  
}

extension UIColor {
  
  static func fromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
  
}

