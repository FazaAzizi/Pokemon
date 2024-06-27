//
//  UIImageView+Ext.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import Foundation
import SDWebImage

extension UIImageView {
    func loadImageUrl(_ url: String, placeholder: String = "ic_pokeball") {
        self.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: placeholder), options: [.continueInBackground])
    }
}
