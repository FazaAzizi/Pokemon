// 
//  PokemonListRouter.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import UIKit

class PokemonListRouter {
    
    func showView(type: PokemonListType = .alllistpokemon) -> PokemonListView {
        let interactor = PokemonListInteractor()
        let presenter = PokemonListPresenter(interactor: interactor, type: type)
        let view = PokemonListView(nibName: String(describing: PokemonListView.self), bundle: nil)
        view.presenter = presenter
        return view
    }
    
    func goToHome(nav: UINavigationController) {
        nav.popViewController(animated: false)
    }
    
    func goToDetail(nav: UINavigationController, data: PokemonDetailEntity, type: PokemonListType) {
        let vc = PokemonDetailRouter().showView(pokemonDetail: data, type: type)
        nav.pushViewController(vc, animated: true)
    }
    
}
