//
//  CatGalleryViewController.swift
//  gallery-cats
//
//  Created by cassio on 15/07/23.
//

import UIKit
import AlamofireImage

class GalleryViewController: UIViewController {
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    let MyCollectionViewCellId: String = "CatImageCellCollectionViewCell"

    let viewModel = GalleryViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchCatImages()
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CatImageCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MyCollectionViewCellId)
    }

    private func fetchCatImages() {
        viewModel.fetchCatImages { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching cat images: \(error)")
            }
        }
    }
}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfImages()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath)

        if let catCell = cell as? CatImgCollectionViewCell {
            catCell.configure(with: viewModel.imageUrl(at: indexPath.item))
        }

        return cell
    }
}

extension GalleryViewController: UICollectionViewDelegate {

}
