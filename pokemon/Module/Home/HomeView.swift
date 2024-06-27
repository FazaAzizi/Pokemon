// 
//  HomeView.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import UIKit
import Combine

class HomeView: UIViewController {
    @IBOutlet weak var myPokemonVw: UIView!
    @IBOutlet weak var pokemonListVw: UIView!
    
    var presenter: HomePresenter?
    var anyCancellable = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension HomeView {
    private func setupView() {
        myPokemonVw.makeCornerRadius(8)
        pokemonListVw.makeCornerRadius(8)
        setupAction()
    }
    
    private func setupAction() {
        pokemonListVw.gesture()
            .sink { [weak self] _ in
                guard let self = self,
                      let presenter = self.presenter,
                      let nav = self.navigationController
                else { return }
                presenter.goToPokemonList(nav: nav)
            }
            .store(in: &anyCancellable)
        
        myPokemonVw.gesture()
            .sink { [weak self] _ in
                guard let self = self,
                      let presenter = self.presenter,
                      let nav = self.navigationController
                else { return }
                presenter.goToMyPokemon(nav: nav)
            }
            .store(in: &anyCancellable)
    }
}

