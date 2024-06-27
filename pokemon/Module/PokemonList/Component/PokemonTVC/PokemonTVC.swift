//
//  PokemonTVC.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import UIKit

class PokemonTVC: UITableViewCell {

    @IBOutlet weak var containerVw: UIView!
    @IBOutlet weak var containerImageVw: UIView!
    @IBOutlet weak var pokemonImgVw: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var containerTypeVw: UIView!
    
    static let identifier = String(describing: PokemonTVC.self)
    
    static let nib = {
       UINib(nibName: identifier, bundle: nil)
    }()
    
    @IBOutlet weak var typeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerVw.makeCornerRadius(8)
        containerTypeVw.makeCornerRadius(8)
        containerImageVw.makeCornerRadius(8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


extension PokemonTVC {
    func configureCell(data: PokemonDetailEntity, listType: PokemonListType) {
        nameLbl.text = listType == .alllistpokemon ? data.name : data.saveName
        typeLbl.text = data.types?.compactMap { $0.type?.name }.joined(separator: ", ")
        containerVw.setBackground(type: data.types?.first?.type?.name ?? "")
        
        if let img = data.sprites?.frontDefault {
            pokemonImgVw.loadImageUrl(img)
        }
    }
}
