// 
//  PokemonListView.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import UIKit
import Combine

class PokemonListView: UIViewController {
    
    @IBOutlet weak var backImgVw: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var presenter: PokemonListPresenter?
    var isLoading = false
    var anyCancellable = Set<AnyCancellable>()
    var pokemonList: [PokemonDetailEntity] = []
    let publicCache = PublicCache.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if presenter?.type == .mypokemon {
            let cachedPokemon = self.publicCache.myPokemon[CacheKey.myPokemon.key()] ?? [PokemonDetailEntity]()
            pokemonList = cachedPokemon
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension PokemonListView {
    private func setupView() {
        setupTableView()
        setupAction()
        
        if presenter?.type == .alllistpokemon {
            titleLbl.text = "Pokemon List"
            bindingData()
            presenter?.fetchPokemonList()
        } else {
            titleLbl.text = "My Pokemon"

            presenter?.hasMoreData = false
            tableView.reloadData()
        }
        tableView.reloadData()
    }
    
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(PokemonTVC.nib, forCellReuseIdentifier: PokemonTVC.identifier)
        self.tableView.reloadData()
    }
    
    private func bindingData() {
        guard let presenter = self.presenter else { return }
        presenter.$pokemonList
            .sink { [weak self] data in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.pokemonList = data
                    self.isLoading = false
                    self.tableView.reloadData()
                }
            }
            .store(in: &anyCancellable)
    }
    
    private func setupAction() {
        backImgVw.gesture()
            .sink { [weak self] _ in
                guard let self = self,
                      let presenter = self.presenter,
                      let nav = self.navigationController
                else { return }
                presenter.goToHome(nav: nav)
            }
            .store(in: &anyCancellable)
    }
}

extension PokemonListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonTVC.identifier, for: indexPath) as? PokemonTVC,
              let presenter = presenter
        else {
            return UITableViewCell()
        }
        
        cell.configureCell(data: pokemonList[indexPath.row], listType: presenter.type)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let navigation = self.navigationController,
              let presenter
        else {return}
        
        presenter.goToDetail(nav: navigation, data: pokemonList[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.frame.size.height
        
        if position > contentHeight - tableViewHeight * 2 {
            if let presenter = self.presenter, !presenter.isLoading, presenter.hasMoreData {
                presenter.fetchPokemonList()
            }
        }
     }
}
