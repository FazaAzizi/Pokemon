//
//  PopupMoves.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import UIKit
import Combine

class PopupMoves: UIViewController {
    @IBOutlet weak var containerVw: UIView!
    @IBOutlet weak var closeImgVw: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var anyCancellable = Set<AnyCancellable>()
    var data: [Move] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

extension PopupMoves {
    private func setupView() {
        containerVw.makeCornerRadius(16)
        setupAction()
        setupTableView()
    }
    
    private func setupAction() {
        closeImgVw.gesture()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: false)
            }
            .store(in: &anyCancellable)
    }
    
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(MoveTVC.nib, forCellReuseIdentifier: MoveTVC.identifier)
        self.tableView.reloadData()
    }
}

extension PopupMoves: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoveTVC.identifier, for: indexPath) as? MoveTVC
        else { return UITableViewCell() }
        
        cell.configureCell(data: data[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
