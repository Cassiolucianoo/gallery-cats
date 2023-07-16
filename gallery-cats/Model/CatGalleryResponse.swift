//
//  CatGalleryResponse.swift
//  gallery-cats
//
//  Created by cassio on 15/07/23.
//

import Foundation


import Foundation

struct CatGalleryResponse: Codable {
    let data: [CatImageData]
}

struct CatImageData: Codable {
    let images: [CatImage]?
}

struct CatImage: Codable {
    let link: String
    let type: String
}
