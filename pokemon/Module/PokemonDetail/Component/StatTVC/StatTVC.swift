//
//  StatTVC.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import UIKit

class StatTVC: UITableViewCell {
    @IBOutlet weak var statLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    
    static let identifier = String(describing: StatTVC.self)
    
    static let nib = {
       UINib(nibName: identifier, bundle: nil)
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension StatTVC {
    func configureCell(data: Stat) {
        guard let stat = data.stat,
              let nameStat = stat.name,
              let value = data.baseStat
        else {return}
        statLbl.text = nameStat
        valueLbl.text = "\(value)"
    }
}
