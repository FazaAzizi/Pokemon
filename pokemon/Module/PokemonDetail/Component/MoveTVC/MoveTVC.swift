//
//  MoveTVC.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import UIKit

class MoveTVC: UITableViewCell {
    @IBOutlet weak var moveLbl: UILabel!
    @IBOutlet weak var containerVw: UIView!
    
    static let identifier = String(describing: MoveTVC.self)
    
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

extension MoveTVC {
    func configureCell(data: Move) {
        guard let move = data.move else {return}
        moveLbl.text = move.name
    }
}
