//
//  ShadowAndRoundedCorners.swift
//  gallery-cats
//
//  Created by cassio on 17/07/23.
//

import Foundation


import UIKit

extension UIView {
    func applyShadowAndRoundedCorners(shadowColor: UIColor = .black,
                                      shadowOpacity: Float = 0.5,
                                      shadowOffset: CGSize = CGSize(width: 0, height: 2),
                                      shadowRadius: CGFloat = 4.0,
                                      cornerRadius: CGFloat = 10.0) {
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        layer.cornerRadius = cornerRadius
    }
}

