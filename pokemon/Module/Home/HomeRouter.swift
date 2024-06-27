// 
//  HomeRouter.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import UIKit

class HomeRouter {
    
    func showView() -> HomeView {
        let interactor = HomeInteractor()
        let presenter = HomePresenter(interactor: interactor)
        let view = HomeView(nibName: String(describing: HomeView.self), bundle: nil)
        view.presenter = presenter
        return view
    }
    
    func goToPokemonList(nav: UINavigationController) {
        let vc = PokemonListRouter().showView()
        nav.pushViewController(vc, animated: true)
    }
    
    func goToMyPokemon(nav: UINavigationController) {
        let vc = PokemonListRouter().showView(type: .mypokemon)
        nav.pushViewController(vc, animated: true)
    }
}
