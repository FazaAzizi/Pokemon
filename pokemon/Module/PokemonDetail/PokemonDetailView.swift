//
//  PokemonDetailView.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import UIKit
import Combine

class PokemonDetailView: UIViewController {
    @IBOutlet weak var namePokemonLbl: UILabel!
    @IBOutlet weak var containerVw: UIView!
    @IBOutlet weak var backImgVw: UIImageView!
    @IBOutlet weak var pokemonImgVw: UIImageView!
    @IBOutlet weak var catchBtn: UIView!
    @IBOutlet weak var abilityTableVw: UITableView!
    @IBOutlet weak var typeTableVw: UITableView!
    @IBOutlet weak var statsTableVw: UITableView!
    @IBOutlet weak var moveTableVw: UITableView!
    @IBOutlet weak var containerLoadMoreVw: UIView!
    @IBOutlet weak var catchLbl: UILabel!
    @IBOutlet weak var renameBtn: UIView!
    
    @IBOutlet weak var abilityHeighConstraint: NSLayoutConstraint!
    @IBOutlet weak var moveHeighConstraint: NSLayoutConstraint!
    @IBOutlet weak var typeHeighConstraint: NSLayoutConstraint!
    @IBOutlet weak var statHeighConstraint: NSLayoutConstraint!
    
    var presenter: PokemonDetailPresenter?
    var anyCancellable = Set<AnyCancellable>()
    let publicCache = PublicCache.shared
    var savePokemon: [PokemonDetailEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension PokemonDetailView {
    private func setupView() {
        savePokemon = self.publicCache.myPokemon[CacheKey.myPokemon.key()] ?? [PokemonDetailEntity]()
        setupAction()
        setupData()
        setupTableView()
        self.containerVw.makeCornerRadius(24, [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        self.containerLoadMoreVw.makeCornerRadius(8)
        
        calculateHeightTableView()
    }
    
    private func calculateHeightTableView() {
        guard let presenter = self.presenter,
              let data = presenter.pokemonDetail,
              let abilities = data.abilities,
              let stats = data.stats,
              let types = data.types,
              let moves = data.moves
        else {return}
        let movesCount = moves.count > 3 ? 3 : moves.count
        abilityHeighConstraint.constant = CGFloat(abilities.count * 50)
        moveHeighConstraint.constant = CGFloat(movesCount * 50)
        typeHeighConstraint.constant = CGFloat(types.count * 50)
        statHeighConstraint.constant = CGFloat(stats.count * 40)
    }
    
    private func setupData() {
        guard let presenter = self.presenter,
              let data = presenter.pokemonDetail
        else {return}
        
        namePokemonLbl.text = presenter.type == .alllistpokemon ? data.name : data.saveName
        catchLbl.text = presenter.type == .alllistpokemon ? "Catch!" : "Release"
        renameBtn.isHidden = presenter.type == .alllistpokemon
        
        self.view.setBackground(type: data.types?.first?.type?.name ?? "")
        self.catchBtn.setBackground(type: data.types?.first?.type?.name ?? "")
        self.catchBtn.makeCornerRadius(8)
        self.renameBtn.setBackground(type: data.types?.first?.type?.name ?? "")
        self.renameBtn.makeCornerRadius(8)
        
        if let img = data.sprites?.frontDefault {
            pokemonImgVw.loadImageUrl(img)
        }
    }
    
    private func setupAction() {
        backImgVw.gesture()
            .sink { [weak self] _ in
                guard let self = self,
                      let presenter = self.presenter,
                      let nav = self.navigationController
                else { return }
                presenter.goToList(nav: nav)
            }
            .store(in: &anyCancellable)
        
        containerLoadMoreVw.gesture()
            .sink { [weak self] _ in
                guard let self = self,
                      let presenter = self.presenter,
                      let nav = self.navigationController,
                      let pokemonDetail = presenter.pokemonDetail,
                      let data = pokemonDetail.moves
                else { return }
                presenter.showPopupMove(nav: nav, data: data)
            }
            .store(in: &anyCancellable)
        
        catchBtn.gesture()
            .sink { [weak self] _ in
                guard let self = self,
                      let presenter = self.presenter
                else { return }
                presenter.type == .alllistpokemon ? self.onCatch() : self.onRelease()
            }
            .store(in: &anyCancellable)
        
        renameBtn.gesture()
            .sink { [weak self] _ in
                self?.onRename()
            }
            .store(in: &anyCancellable)
        
    }
    
    private func setupTableView() {
        self.statsTableVw.dataSource = self
        self.statsTableVw.delegate = self
        self.statsTableVw.register(StatTVC.nib, forCellReuseIdentifier: StatTVC.identifier)
        
        self.moveTableVw.dataSource = self
        self.moveTableVw.delegate = self
        self.moveTableVw.register(MoveTVC.nib, forCellReuseIdentifier: MoveTVC.identifier)
        
        self.abilityTableVw.dataSource = self
        self.abilityTableVw.delegate = self
        self.abilityTableVw.register(MoveTVC.nib, forCellReuseIdentifier: MoveTVC.identifier)
        
        self.typeTableVw.dataSource = self
        self.typeTableVw.delegate = self
        self.typeTableVw.register(TypeTVC.nib, forCellReuseIdentifier: TypeTVC.identifier)
    }
}

extension PokemonDetailView {
    func onCatch(){
        let alert = UIAlertController(title: "Pokemon", message: "Are you sure want to catch this pokemon?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            let random = Int(arc4random_uniform(100))
            random < 50 ? self.alertTextField() : self.showAlert(message: "Failed catch pokemon!")
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func onRelease(){
        let alert = UIAlertController(title: "Pokemon", message: "Are you sure want to release this pokemon?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            let newSave = self.savePokemon.filter{$0.saveName != self.presenter?.pokemonDetail?.saveName}
            self.publicCache.myPokemon[CacheKey.myPokemon.key()] = newSave
            if let navigation = self.navigationController{
                navigation.popViewController(animated: false)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func onRename(){
        let alert = UIAlertController(title: "Pokemon", message: "Are you sure want to rename this pokemon?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] action in
            guard let self = self,
                  let presenter = self.presenter,
                  let pokemonDetail = presenter.pokemonDetail,
                  let index = self.savePokemon.firstIndex(where: { $0.saveName == pokemonDetail.saveName }) else { return }
            
            let fibNumber = self.fibonacci(pokemonDetail.renameCount ?? 0)
            var newName: String
            
            if let renameCount = pokemonDetail.renameCount, renameCount > 0, let dashIndex = pokemonDetail.saveName?.lastIndex(of: "-") {
                let baseName = String(pokemonDetail.saveName?[..<dashIndex] ?? "")
                newName = "\(baseName)-\(fibNumber)"
            } else {
                newName = "\(pokemonDetail.saveName ?? "")-\(fibNumber)"
            }
            presenter.pokemonDetail?.saveName = newName
            presenter.pokemonDetail?.renameCount? += 1
            
            self.savePokemon[index].saveName = newName
            self.savePokemon[index].renameCount? += 1
            
            self.publicCache.myPokemon[CacheKey.myPokemon.key()] = self.savePokemon
            
            self.namePokemonLbl.text = newName
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func fibonacci(_ n: Int) -> Int {
        if n <= 1 {
            return n
        }
        var fibs = [0, 1]
        for i in 2...n {
            fibs.append(fibs[i-1] + fibs[i-2])
        }
        return fibs[n]
    }
    
    func alertTextField() {
        let alert = UIAlertController(title: "Great!", message: "Give this pokemon name?", preferredStyle: UIAlertController.Style.alert )
        
        let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if textField.text != "" {
                var temp = self.presenter?.pokemonDetail
                temp?.saveName = textField.text
                temp?.renameCount = 0
                if let temp = temp {
                    self.savePokemon.append(temp)
                    self.publicCache.myPokemon[CacheKey.myPokemon.key()] = self.savePokemon
                    self.showAlert(message: "Catch success!")
                }
            }
        }
        
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter name for pokemon"
            textField.textColor = .black
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(save)
        alert.addAction(cancel)
        
        self.present(alert, animated:true, completion: nil)
    }
    
    func showAlert(message : String){
        let toastLabel = UILabel(frame: CGRect(x: 40, y: self.view.frame.size.height-100, width: self.view.frame.size.width - 80, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension PokemonDetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = self.presenter,
              let data = presenter.pokemonDetail
        else {return 0}
        
        switch tableView {
        case typeTableVw:
            return data.types?.count ?? 0
        case abilityTableVw:
            return data.abilities?.count ?? 0
        case statsTableVw:
            return data.stats?.count ?? 0
        case moveTableVw:
            if let moves = data.moves {
                return moves.count > 3 ? 3 : moves.count
            } else {
                return 0
            }
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter = self.presenter,
              let data = presenter.pokemonDetail
        else {return UITableViewCell()}
        
        switch tableView {
        case typeTableVw:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TypeTVC.identifier, for: indexPath) as? TypeTVC,
                  let types = data.types
            else { return UITableViewCell() }
            
            cell.configureCell(data: types[indexPath.row])
            return cell
            
        case abilityTableVw:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MoveTVC.identifier, for: indexPath) as? MoveTVC,
                  let moves = data.moves
            else { return UITableViewCell() }
            
            cell.configureCell(data: moves[indexPath.row])
            return cell
            
        case statsTableVw:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StatTVC.identifier, for: indexPath) as? StatTVC,
                  let stats = data.stats
            else { return UITableViewCell() }
            
            cell.configureCell(data: stats[indexPath.row])
            return cell
            
        case moveTableVw:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MoveTVC.identifier, for: indexPath) as? MoveTVC,
                  let moves = data.moves
            else { return UITableViewCell() }
            
            cell.configureCell(data: moves[indexPath.row])
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case statsTableVw:
            return 40
        default: return 50
        }
    }
}


