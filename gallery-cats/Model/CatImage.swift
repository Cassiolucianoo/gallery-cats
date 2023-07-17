//
//  CatImage.swift
//  gallery-cats
//
//  Created by cassio on 15/07/23.
//


import Foundation

struct RespostaGaleriaGatos: Codable {
    let data: [DadosImagemDeGato]
}

struct DadosImagemDeGato: Codable {
    let images: [ImagemDeGato]?
}

struct ImagemDeGato: Codable {
    let link: String
    let type: String
}
