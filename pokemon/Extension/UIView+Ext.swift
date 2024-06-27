//
//  UIView+Ext.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import Foundation
import Combine
import UIKit

extension UIView{
    func setBackground(type: String){
        switch type{
        case "normal":
            self.backgroundColor = UIColor(hexaRGB: "#a8a77a")
        case "fighting":
            self.backgroundColor = UIColor(hexaRGB: "#c22e28")
        case "flying":
            self.backgroundColor = UIColor(hexaRGB: "#a98ef3")
        case "poison":
            self.backgroundColor = UIColor(hexaRGB: "#a33ea2")
        case "ground":
            self.backgroundColor = UIColor(hexaRGB: "#e1bf65")
        case "rock":
            self.backgroundColor = UIColor(hexaRGB: "#b7a134")
        case "bug":
            self.backgroundColor = UIColor(hexaRGB: "#725797")
        case "ghost":
            self.backgroundColor = UIColor(hexaRGB: "#735797")
        case "steel":
            self.backgroundColor = UIColor(hexaRGB: "#b8b7ce")
        case "fire":
            self.backgroundColor = UIColor(hexaRGB: "#ee8130")
        case "water":
            self.backgroundColor = UIColor(hexaRGB: "#6390f1")
        case "grass":
            self.backgroundColor = UIColor(hexaRGB: "#7bc74b")
        case "electric":
            self.backgroundColor = UIColor(hexaRGB: "#ffd870")
        case "psychic":
            self.backgroundColor = UIColor(hexaRGB: "#fa5587")
        case "ice":
            self.backgroundColor = UIColor(hexaRGB: "#97d9d6")
        case "dragon":
            self.backgroundColor = UIColor(hexaRGB: "#7035fc")
        case "dark":
            self.backgroundColor = UIColor(hexaRGB: "#705846")
        case "fairy":
            self.backgroundColor = UIColor(hexaRGB: "#d685ad")
        case "unknown":
            self.backgroundColor = UIColor(hexaRGB: "#335734")
        case "shadow":
            self.backgroundColor = UIColor(hexaRGB: "#474747")
        case "abi" :
            self.backgroundColor = UIColor(hexaRGB: "#eeeee4")
        default:
            self.backgroundColor = UIColor(hexaRGB: "#a8a77a")
        }
    }
    
    public func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView ?? UIView()
    }
    
    func applyGradient(colors: [UIColor], locations: [NSNumber]? = nil) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func gesture(_ gestureType: GestureType = .tap()) -> GesturePublisher {
        .init(view: self, gestureType: gestureType)
    }
    
    func makeCornerRadius(_ radius: CGFloat, _ maskedCorner: CACornerMask? = nil) {
        layer.cornerRadius = radius
        layer.maskedCorners = maskedCorner ?? [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        clipsToBounds = true
    }
    
    func addBorder(width: CGFloat = 1, colorBorder: CGColor = UIColor.white.cgColor) {
        layer.borderWidth = width
        layer.borderColor = colorBorder
    }
    
    func addShadow(_ radius: CGFloat) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = radius
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
    }
}
