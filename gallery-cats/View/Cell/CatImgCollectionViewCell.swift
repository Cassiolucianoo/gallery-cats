//
//  CatImageCellCollectionViewCell.swift
//  gallery-cats
//
//  Created by cassio on 16/07/23.
//

import UIKit
import AlamofireImage

class CatImgCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    func configurar(com urlImagem: String) {
        if let url = URL(string: urlImagem) {
            imageView.af.setImage(withURL: url, completion: { response in
                switch response.result {
                case .success(let image):
                    let tamanhoDesejado = CGSize(width: 100, height: 126)
                    let imagemRedimensionada = image.af.imageAspectScaled(toFill: tamanhoDesejado)
                    self.imageView.image = imagemRedimensionada
                case .failure(let error):
                    print("Erro ao carregar imagem: \(urlImagem), erro: \(error)")
                }
            })
        } else {
            print("URL inválida")
        }
    }
}
