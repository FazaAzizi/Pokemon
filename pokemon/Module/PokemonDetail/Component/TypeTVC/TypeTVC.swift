//
//  AbilityTVC.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import UIKit

class TypeTVC: UITableViewCell {
    @IBOutlet weak var abilityLbl: UILabel!
    @IBOutlet weak var containerVw: UIView!
    
    static let identifier = String(describing: TypeTVC.self)
    
    static let nib = {
       UINib(nibName: identifier, bundle: nil)
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerVw.makeCornerRadius(8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension TypeTVC {
    func configureCell(data: TypeElement) {
        guard let type = data.type,
              let name = type.name
        else {return}
        
        abilityLbl.text = name
        containerVw.setBackground(type: name)
    }
}
