// 
//  HomePresenter.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import Foundation
import UIKit

class HomePresenter {
    
    private let interactor: HomeInteractor
    private let router = HomeRouter()
    
    init(interactor: HomeInteractor) {
        self.interactor = interactor
    }
    
    func goToPokemonList(nav: UINavigationController) {
        router.goToPokemonList(nav: nav)
    }
    
    func goToMyPokemon(nav: UINavigationController) {
        router.goToMyPokemon(nav: nav)
    }
}
