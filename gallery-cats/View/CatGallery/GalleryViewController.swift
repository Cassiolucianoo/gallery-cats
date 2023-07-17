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
    var loadingBackgroundView: UIView?

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
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor) // Centraliza o indicador de loading na tela
        ])
    }

    private func showLoadingBackgroundView() {
        loadingBackgroundView = UIView(frame: view.bounds)
        loadingBackgroundView?.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        loadingBackgroundView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingBackgroundView!)

        NSLayoutConstraint.activate([
            loadingBackgroundView!.topAnchor.constraint(equalTo: view.topAnchor),
            loadingBackgroundView!.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingBackgroundView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingBackgroundView!.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func hideLoadingBackgroundView() {
        loadingBackgroundView?.removeFromSuperview()
        loadingBackgroundView = nil
    }

    private func fetchCatImages(pagina: Int) {
        isLoadingData = true
        ongoingRequest?.cancel() // Cancela qualquer requisição em andamento antes de fazer uma nova

        // Mostra o indicador de loading e o fundo cinza transparente
        loadingIndicator.startAnimating()
        showLoadingBackgroundView()

        // Adiciona um pequeno delay para tornar o loading mais perceptível
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
            self.viewModel.buscarImagensDeGatos(pagina: pagina) { [weak self] result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                        self?.isLoadingData = false
                        self?.loadingIndicator.stopAnimating() // Para a animação do indicador de loading
                        self?.hideLoadingBackgroundView() // Esconde o fundo cinza transparente
                    }
                case .failure(let error):
                    print("Erro ao buscar imagens de gatos: \(error)")
                    self?.isLoadingData = false
                    self?.loadingIndicator.stopAnimating() // Para a animação do indicador de loading em caso de erro também
                    self?.hideLoadingBackgroundView() // Esconde o fundo cinza transparente em caso de erro também
                }
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
