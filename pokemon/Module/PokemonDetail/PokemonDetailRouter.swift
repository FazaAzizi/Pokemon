// 
//  PokemonDetailRouter.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import UIKit

class PokemonDetailRouter {
    
    func showView(pokemonDetail: PokemonDetailEntity, type: PokemonListType) -> PokemonDetailView {
        let interactor = PokemonDetailInteractor()
        let presenter = PokemonDetailPresenter(interactor: interactor, pokemonDetail: pokemonDetail, type: type)
        let view = PokemonDetailView(nibName: String(describing: PokemonDetailView.self), bundle: nil)
        view.presenter = presenter
        return view
    }
    
    func goToList(nav: UINavigationController) {
        nav.popViewController(animated: false)
    }
    
    func showPopupMove(nav: UINavigationController, data: [Move]) {
        let popupMoves = PopupMoves(nibName: String(describing: PopupMoves.self), bundle: nil)
        popupMoves.modalPresentationStyle = .overFullScreen
        popupMoves.modalTransitionStyle = .crossDissolve
        popupMoves.data = data
        nav.present(popupMoves, animated: true)
    }
}
