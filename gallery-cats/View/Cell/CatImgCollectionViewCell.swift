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
        print("Configurando célula com a imagem: \(imageUrl)")
        if let url = URL(string: imageUrl) {
            // Use o método `af.setImage(withURL:)` para carregar a imagem da URL e configurar o UIImageView
            imageView.af.setImage(withURL: url, completion:  { response in
                switch response.result {
                case .success:
                    print("Imagem carregada com sucesso: \(url)")
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
    
    
