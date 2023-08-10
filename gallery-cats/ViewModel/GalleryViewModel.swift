//
//  CatGalleryViewModel.swift
//  gallery-cats
//
//  Created by cassio on 15/07/23.
//
//let clientId = "9d32f5daf5806b6"
//let apiUrl = "https://api.imgur.com/3/gallery/search/?q=cats"

import Foundation
import Alamofire

// Classe GalleryViewModel que gerencia as imagens de gatos exibidas na galeria
class GalleryViewModel {
    private var imagensDeGatos: [ImagemDeGato] = []
    
    // Adiciona a função para adicionar imagens de teste ao ViewModel
    func adicionarImagensDeTeste(_ imagens: [ImagemDeGato]) {
        imagensDeGatos += imagens
    }
    
    // Busca imagens de gatos na API do Imgur com base na página especificada
    func buscarImagensDeGatos(pagina: Int, conclusao: @escaping (Result<Void, Error>) -> Void) {
        let clientId = "9d32f5daf5806b6"
        let apiUrl = "https://api.imgur.com/3/gallery/search/?q=cats"
        
        // Constrói a URL da API do Imgur com base na página especificada
        guard let url = URL(string: "\(apiUrl)&page=\(pagina)") else {
            // Se a URL não pôde ser construída, chama a closure de conclusão com um erro
            conclusao(.failure(NSError(domain: "URL inválida", code: 0, userInfo: nil)))
            return
        }
        
        // Cria uma requisição HTTP com a URL construída e adiciona o cabeçalho de autenticação
        
        //Em resumo, essa parte do código cria uma requisição HTTP para acessar a API do Imgur e, em seguida, adiciona um cabeçalho de autenticação à requisição para permitir que a API identifique o aplicativo (por meio do ID do cliente) e autorize o acesso aos seus recursos protegidos, permitindo que a busca por imagens de gatos seja realizada com sucesso.
        
        var requisicao = URLRequest(url: url)
        requisicao.addValue("Client-ID \(clientId)", forHTTPHeaderField: "Authorization")
        
        // Faz a requisição HTTP com o Alamofire para buscar as imagens de gatos
        AF.request(requisicao).validate().responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    // Decodifica os dados da resposta da API em objetos do tipo RespostaGaleriaGatos
                    let decodificador = JSONDecoder()
                    let respostaApi = try decodificador.decode(RespostaGaleriaGatos.self, from: data)
                    
                    // Filtra os dados da resposta para obter as imagens de gatos em formato de ImagemDeGato
                    let novasImagens = respostaApi.data.compactMap { dadosImagem in
                        if let imagem = dadosImagem.images?.first, imagem.type == "image/jpeg" {
                            return ImagemDeGato(link: imagem.link, type: imagem.type)
                        }
                        return nil
                    }
                    
                    // Adiciona as novas imagens ao array de imagens do ViewModel
                    self.imagensDeGatos += novasImagens
                    // Chama a closure de conclusão indicando que a busca foi bem-sucedida
                    conclusao(.success(()))
                } catch {
                    // Se ocorrer algum erro na decodificação, chama a closure de conclusão com o erro
                    conclusao(.failure(error))
                }
            case .failure(let error):
                // Se ocorrer um erro na requisição, chama a closure de conclusão com o erro
                conclusao(.failure(error))
            }
        }
    }
    
    // Retorna o número total de imagens de gatos armazenadas no ViewModel
    func numeroDeImagens() -> Int {
        return imagensDeGatos.count
    }
    
    // Retorna a URL da imagem de gato na posição especificada pelo índice dentro do array de imagens
    func urlImagem(at index: Int) -> String {
        return imagensDeGatos[index].link
    }
}
