//
//  GalleryViewModelTests.swift
//  gallery-catsTests
//
//  Created by cassio on 17/07/23.
//

import XCTest
@testable import gallery_cats


final class GalleryViewModelTests: XCTestCase {
    
    
    func testBuscarImagensDeGatos() {
        let viewModel = GalleryViewModel()
        let expectation = XCTestExpectation(description: "Buscar imagens de gatos")
        
        viewModel.buscarImagensDeGatos(pagina: 0) { result in
            switch result {
            case .success:
                // Verifica se a lista de imagens não está vazia
                XCTAssertFalse(viewModel.numeroDeImagens() == 0, "Nenhuma imagem encontrada")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Erro ao buscar imagens: \(error)")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    func testNumeroDeImagens() {
        let viewModel = GalleryViewModel()
        
        // Teste quando não há imagens
        XCTAssertEqual(viewModel.numeroDeImagens(), 0, "O número de imagens deve ser zero inicialmente")
        
        // Teste após buscar imagens
        let expectation = XCTestExpectation(description: "Buscar imagens de gatos")
        viewModel.buscarImagensDeGatos(pagina: 0) { _ in
            XCTAssertGreaterThan(viewModel.numeroDeImagens(), 10, "O número de imagens deve ser maior que zero após a busca")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testUrlImagem() {
        let viewModel = GalleryViewModel()
        
        // Teste quando não há imagens
        XCTAssertEqual(viewModel.numeroDeImagens(), 0, "O número de imagens deve ser zero inicialmente")
        
        // Teste após buscar imagens
        let expectation = XCTestExpectation(description: "Buscar imagens de gatos")
        viewModel.buscarImagensDeGatos(pagina: 0) { _ in
            let url = viewModel.urlImagem(at: 0)
            XCTAssertFalse(url.isEmpty, "A URL da primeira imagem não deve estar vazia")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
