//
//  CatGalleryViewModel.swift
//  gallery-cats
//
//  Created by cassio on 15/07/23.
//
//let clientId = "9d32f5daf5806b6"
//let apiUrl = "https://api.imgur.com/3/gallery/search/?q=cats"import Foundation

import Foundation
import Alamofire

import Foundation
import Alamofire

class CatGalleryViewModel {
    private var catImages: [CatImage] = []
    
    func fetchCatImages(section: String = "hot", sort: String = "viral", window: String = "day", page: Int = 1, showViral: Bool = true, showMature: Bool = false, albumPreviews: Bool = false, completion: @escaping (Result<Void, Error>) -> Void) {
        let clientId = "9d32f5daf5806b6"
        let apiUrl = "https://api.imgur.com/3/gallery/\(section)/\(sort)/\(window)/\(page)?showViral=\(showViral)&mature=\(showMature)&album_previews=\(albumPreviews)"

        guard let url = URL(string: apiUrl) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.addValue("Client-ID \(clientId)", forHTTPHeaderField: "Authorization")

        AF.request(request).validate().responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(CatGalleryResponse.self, from: data)
                    self.catImages = response.data.compactMap { CatImage(imageUrl: $0.link) }
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func numberOfImages() -> Int {
        return catImages.count
    }
    
    func imageUrl(at index: Int) -> String {
        return catImages[index].imageUrl
    }
}
