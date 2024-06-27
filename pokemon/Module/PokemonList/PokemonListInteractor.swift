//
//  PokemonListInteractor.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import Foundation
import Combine

class PokemonListInteractor {
    
    open var api = ApiManager()
    
    func fetchPokemonList(offset: Int, limit: Int) -> AnyPublisher<PokemonListResponse, Error> {
        return api.requestApiPublisher(.list(offset: offset, limit: limit))
    }
    
    func fetchPokemonDetail(url: String) -> AnyPublisher<PokemonDetailEntity, Error> {
        return api.requestApiPublisher(.detail(url: url))
    }
}
