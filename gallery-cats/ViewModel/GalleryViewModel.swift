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

class GalleryViewModel {
    private var imagensDeGatos: [ImagemDeGato] = []

    func buscarImagensDeGatos(pagina: Int, conclusao: @escaping (Result<Void, Error>) -> Void) {
        let clientId = "9d32f5daf5806b6"
        let apiUrl = "https://api.imgur.com/3/gallery/search/?q=cats"

        guard let url = URL(string: "\(apiUrl)&page=\(pagina)") else {
            conclusao(.failure(NSError(domain: "URL inválida", code: 0, userInfo: nil)))
            return
        }

        var requisicao = URLRequest(url: url)
        requisicao.addValue("Client-ID \(clientId)", forHTTPHeaderField: "Authorization")

        AF.request(requisicao).validate().responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodificador = JSONDecoder()
                    let respostaApi = try decodificador.decode(RespostaGaleriaGatos.self, from: data)

                    let novasImagens = respostaApi.data.compactMap { dadosImagem in
                        if let imagem = dadosImagem.images?.first, imagem.type == "image/jpeg" {
                            return ImagemDeGato(link: imagem.link, type: imagem.type)
                        }
                        return nil
                    }
                    self.imagensDeGatos += novasImagens
                    conclusao(.success(()))
                } catch {
                    conclusao(.failure(error))
                }
            case .failure(let error):
                conclusao(.failure(error))
            }
        }
    }

    func numeroDeImagens() -> Int {
        return imagensDeGatos.count
    }

    func urlImagem(at index: Int) -> String {
        return imagensDeGatos[index].link
    }
}
