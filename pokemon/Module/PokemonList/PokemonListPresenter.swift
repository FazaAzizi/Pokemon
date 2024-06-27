// 
//  PokemonListPresenter.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import Foundation
import Combine
import UIKit

class PokemonListPresenter {
    
    private let interactor: PokemonListInteractor
    private let router = PokemonListRouter()
    var type: PokemonListType = .alllistpokemon
    
    init(interactor: PokemonListInteractor, type: PokemonListType) {
        self.interactor = interactor
        self.type = type
    }
    
    @Published public var pokemonList: [PokemonDetailEntity] = []
    
    var anyCancellable = Set<AnyCancellable>()
    
    var hasMoreData = true
    var offset = 0
    var limit = 10
    var isLoading = false
    
    func fetchPokemonList() {
        guard hasMoreData, !isLoading else { return }
        isLoading = true
        interactor.fetchPokemonList(offset: offset, limit: limit)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { completion in
                switch completion {
                   case .finished: break
                   case .failure(let error):
                       self.isLoading = false
                   }
            }, receiveValue: { [weak self] listResponse in
                guard let self = self else { return }
                
                if let results = listResponse.results {
                    if results.count < self.limit {
                        self.hasMoreData = false
                    } else {
                        self.offset += self.limit
                    }
                    self.fetchAllDetailPokemons(results: results)
                }
            })
            .store(in: &anyCancellable)
    }
    
    private func fetchAllDetailPokemons(results: [PokemonListEntity]) {
        let dispatchGroup = DispatchGroup()
        var tempPokemonDetails: [PokemonDetailEntity] = []
        
        for result in results {
            if let url = result.url {
                dispatchGroup.enter()
                interactor.fetchPokemonDetail(url: url)
                    .eraseToAnyPublisher()
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            print("Error fetching Pokémon detail: \(error)")
                            dispatchGroup.leave()
                        }
                    }, receiveValue: { pokemonDetail in
                        tempPokemonDetails.append(pokemonDetail)
                        dispatchGroup.leave()
                    })
                    .store(in: &anyCancellable)
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.pokemonList.append(contentsOf: tempPokemonDetails)
            self.isLoading = false
        }
    }
    
    func goToHome(nav: UINavigationController) {
        router.goToHome(nav: nav)
    }
    
    func goToDetail(nav: UINavigationController, data: PokemonDetailEntity) {
        router.goToDetail(nav: nav, data: data, type: type)
    }
}
