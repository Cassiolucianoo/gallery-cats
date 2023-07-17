//
//  CatGalleryViewController.swift
//  gallery-cats
//
//  Created by cassio on 15/07/23.
//
import UIKit
import Alamofire

class GalleryViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    let MyCollectionViewCellId: String = "CatImageCellCollectionViewCell"

    let viewModel = GalleryViewModel()
    var currentPage = 0
    var isLoadingData = false
    var ongoingRequest: DataRequest?
    var loadingIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupLoadingIndicator()
        fetchCatImages(pagina: currentPage)
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CatImageCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MyCollectionViewCellId)
    }

    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = .gray
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50) // Ajuste a posição do indicador de acordo com sua preferência
        ])
    }

    private func fetchCatImages(pagina: Int) {
        isLoadingData = true
        ongoingRequest?.cancel() // Cancela qualquer requisição em andamento antes de fazer uma nova
        loadingIndicator.startAnimating() // Inicia a animação do indicador de loading
        viewModel.buscarImagensDeGatos(pagina: pagina) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.isLoadingData = false
                    self?.loadingIndicator.stopAnimating() // Para a animação do indicador de loading
                }
            case .failure(let error):
                print("Erro ao buscar imagens de gatos: \(error)")
                self?.isLoadingData = false
                self?.loadingIndicator.stopAnimating() // Para a animação do indicador de loading em caso de erro também
            }
        }
    }
}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numeroDeImagens()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath)

        if let catCell = cell as? CatImgCollectionViewCell {
            catCell.configurar(com: viewModel.urlImagem(at: indexPath.item))
        }

        // Verifica se chegou ao final da lista e faz a carga de novas imagens
        if indexPath.item == viewModel.numeroDeImagens() - 1 && !isLoadingData {
            currentPage += 1
            fetchCatImages(pagina: currentPage)
        }

        return cell
    }
}
