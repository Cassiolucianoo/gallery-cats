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
    @IBOutlet weak var backGrund: UIView!
    
    // Método chamado quando a célula é instanciada a partir do storyboard ou xib
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI() // Configura a aparência da célula
    }
    
    // Método chamado quando a célula é redimensionada ou tem seu layout atualizado
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI() // Configura a aparência da célula novamente, garantindo que ela permaneça consistente ao ser redimensionada
    }
    
    // Configura a aparência da célula
    func setupUI() {
        imageView.layer.cornerRadius = 10.0 // Define o raio dos cantos da imagem para torná-la arredondada
        imageView.layer.masksToBounds = true // Define que a imagem deve respeitar o raio dos cantos (arredondada)
        backGrund.applyShadowAndRoundedCorners() // Aplica sombra e cantos arredondados na view de fundo (background)
    }
    
    // Método para configurar a célula com a URL da imagem a ser carregada
    func configurar(com urlImagem: String) {
        if let url = URL(string: urlImagem) {
            // Usa o AlamofireImage (método af.setImage) para carregar a imagem a partir da URL
            imageView.af.setImage(withURL: url, completion: { response in
                switch response.result {
                case .success(let image):
                    let tamanhoDesejado = CGSize(width: 75, height: 75) // Define o tamanho desejado para a imagem (75x75)
                    let imagemRedimensionada = image.af.imageAspectScaled(toFill: tamanhoDesejado) // Redimensiona a imagem para o tamanho desejado
                    self.imageView.image = imagemRedimensionada // Define a imagem redimensionada na imageView
                case .failure(let error):
                    print("Erro ao carregar imagem: \(urlImagem), erro: \(error)")
                }
            })
        } else {
            print("URL inválida")
        }
    }
}
