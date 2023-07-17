//
//  CatImageCellCollectionViewCell.swift
//  gallery-cats
//
//  Created by cassio on 16/07/23.
//

import UIKit
import AlamofireImage
import Alamofire

class CatImgCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with imageUrl: String) {
        if let url = URL(string: imageUrl) {
            // Carregue a imagem da URL e redimensione-a para o tamanho desejado
            // Certifique-se de importar a biblioteca AlamofireImage para usar o método "af.setImage(withURL:)"
            imageView.af.setImage(withURL: url, completion: { response in
                switch response.result {
                case .success(let image):
                    // Redimensione a imagem para o tamanho desejado
                    let desiredSize = CGSize(width: 100, height: 126) // Defina o tamanho desejado aqui
                    let resizedImage = image.af.imageAspectScaled(toFill: desiredSize)
                    self.imageView.image = resizedImage
                case .failure(let error):
                    print("Erro ao carregar imagem: \(url), erro: \(error)")
                }
            })
        } else {
            print("URL inválida")
        }
    }

    func loadImage(from url: URL?) {
            guard let url = url else {
                print("URL inválida")
                return
            }

            AF.request(url)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        if let image = UIImage(data: data) {
                            self.imageView.image = image
                            print("Imagem carregada com sucesso!")
                        } else {
                            print("Erro ao carregar imagem: \(url), imagem inválida")
                        }
                    case .failure(let error):
                        print("Erro ao carregar imagem: \(url), erro: \(error)")
                    }
                }
        }
    }
