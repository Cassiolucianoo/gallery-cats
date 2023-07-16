//
//  CatGalleryResponse.swift
//  gallery-cats
//
//  Created by cassio on 15/07/23.
//

import Foundation


struct CatGalleryResponse: Codable {
    let data: [CatImageData]
}

struct CatImageData: Codable {
    let link: String
}
