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
    let MyCollectionViewCellId: String = "CatImageCellCollectionViewCell" // Identificador da célula usada na coleção
    
    // ViewModel responsável pela lógica da galeria
    let viewModel = GalleryViewModel()
    
    // Variáveis para controle da paginação e carregamento de dados
    var currentPage = 0
    var isLoadingData = false
    var ongoingRequest: DataRequest?
    var loadingIndicator: UIActivityIndicatorView!
    var loadingBackgroundView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView() // Configuração da coleção
        setupLoadingIndicator() // Configuração do indicador de carregamento
        fetchCatImages(pagina: currentPage) // Busca as imagens de gatos na página atual
    }
    
    // Configura a UICollectionView
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CatImageCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MyCollectionViewCellId)
        // Define o dataSource, delegate e registra a célula customizada na coleção
    }
    
    // Configura o indicador de carregamento
    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = .gray
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        
        // Centraliza o indicador de loading na tela
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // Mostra uma view de fundo cinza transparente com um indicador de carregamento centralizado
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
    
    // Esconde a view de fundo cinza transparente com o indicador de carregamento
    private func hideLoadingBackgroundView() {
        loadingBackgroundView?.removeFromSuperview()
        loadingBackgroundView = nil
    }
    
    // Método para buscar as imagens de gatos na página especificada
    private func fetchCatImages(pagina: Int) {
        isLoadingData = true
        ongoingRequest?.cancel() // Cancela a requisição anterior (se houver)
        
        loadingIndicator.startAnimating() // Inicia a animação do indicador de carregamento
        showLoadingBackgroundView() // Mostra a view de fundo cinza transparente com o indicador de carregamento
        
        // Simulação de busca das imagens de gatos após um pequeno atraso de 1.9 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
            self.viewModel.buscarImagensDeGatos(pagina: pagina) { [weak self] result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        // Atualiza a coleção com os resultados da busca
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

// Extension para implementação dos métodos do protocolo UICollectionViewDataSource
extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Retorna o número de imagens no ViewModel para serem exibidas na coleção
        return viewModel.numeroDeImagens()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath)
        
        if let catCell = cell as? CatImgCollectionViewCell {
            // Configura a célula customizada (CatImgCollectionViewCell) com a URL da imagem
            catCell.configurar(com: viewModel.urlImagem(at: indexPath.item))
        }
        
        // Se chegou na última célula e não está carregando, faz a paginação para a próxima página de imagens
        if indexPath.item == viewModel.numeroDeImagens() - 1 && !isLoadingData {
            currentPage += 1
            fetchCatImages(pagina: currentPage)
        }
        
        return cell
    }
}
