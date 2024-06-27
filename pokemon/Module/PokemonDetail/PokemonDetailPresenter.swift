// 
//  PokemonDetailPresenter.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import Foundation
import UIKit

class PokemonDetailPresenter {
    
    private let interactor: PokemonDetailInteractor
    private let router = PokemonDetailRouter()
    var pokemonDetail: PokemonDetailEntity?
    var type: PokemonListType = .alllistpokemon
    
    init(interactor: PokemonDetailInteractor, pokemonDetail: PokemonDetailEntity, type: PokemonListType) {
        self.interactor = interactor
        self.pokemonDetail = pokemonDetail
        self.type = type
    }
    
    func goToList(nav: UINavigationController) {
        router.goToList(nav: nav)
    }
    
    func showPopupMove(nav: UINavigationController, data: [Move]) {
        router.showPopupMove(nav: nav, data: data)
    }
}
