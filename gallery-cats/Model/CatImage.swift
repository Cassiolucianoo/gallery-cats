//
//  CatImage.swift
//  gallery-cats
//
//  Created by cassio on 15/07/23.
//
import Foundation

// Estrutura que representa a resposta da API do Imgur contendo um array de DadosImagemDeGato
struct RespostaGaleriaGatos: Codable {
    let data: [DadosImagemDeGato]
}

// Estrutura que representa os dados de uma imagem de gato contendo um array de ImagemDeGato
struct DadosImagemDeGato: Codable {
    let images: [ImagemDeGato]?
}

// Estrutura que representa uma imagem de gato com sua URL (link) e tipo de imagem
struct ImagemDeGato: Codable {
    let link: String
    let type: String
}
