//
//  UIColor+Hex.swift
//  Appt


import UIKit

extension UIColor {
  
  convenience init?(hexCode: String) {
    
    guard hexCode.characters.count == 7 else {
      return nil
    }
    
    guard hexCode.characters.first! == "#" else {
      return nil
    }
    
    guard let value = Int(String(hexCode.characters.dropFirst()), radix: 16) else {
      return nil
    }
    
    let red = value >> 16 & 0xff
    let green = value >> 8 & 0xff
    let blue = value & 0xff
    
    self.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1)
  }
}
