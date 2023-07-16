//
//  File.swift
//  gallery-cats
//
//  Created by cassio on 16/07/23.
//


import Foundation
import UIKit
import AlamofireImage

extension UIImageView {
    func loadImage(from url: URL?) {
        // Verifica se a URL é válida
        guard let url = url else {
            print("URL inválida")
            return
        }
        
        // Usa o AlamofireImage para carregar a imagem da URL no UIImageView
        self.af.setImage(withURL: url) { response in
            switch response.result {
            case .success(let image):
                // Imagem carregada com sucesso, você pode fazer algo com ela, se necessário
                print("Imagem carregada com sucesso: \(image)")
            case .failure(let error):
                // Ocorreu um erro ao carregar a imagem
                print("Erro ao carregar imagem: \(error)")
            }
        }
    }
}
