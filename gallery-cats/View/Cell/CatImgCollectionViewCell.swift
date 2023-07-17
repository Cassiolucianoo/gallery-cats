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

    func configure(with imageUrl: String) {
        if let url = URL(string: imageUrl) {
            imageView.af.setImage(withURL: url, completion: { response in
                switch response.result {
                case .success(let image):
                    let desiredSize = CGSize(width: 100, height: 126)
                    let resizedImage = image.af.imageAspectScaled(toFill: desiredSize)
                    self.imageView.image = resizedImage
                case .failure(let error):
                    print("Error loading image: \(url), error: \(error)")
                }
            })
        } else {
            print("Invalid URL")
        }
    }
}
