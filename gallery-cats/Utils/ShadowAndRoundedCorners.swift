//
//  ShadowAndRoundedCorners.swift
//  gallery-cats
//
//  Created by cassio on 17/07/23.
//

import Foundation


import UIKit

// Criação de uma extensão da classe UIView para adicionar novos métodos e propriedades a objetos UIView em toda a aplicação.
extension UIView {

    // Método para aplicar sombra e cantos arredondados a uma UIView, aceitando vários parâmetros opcionais que permitem personalizar a sombra e o raio do canto.
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

