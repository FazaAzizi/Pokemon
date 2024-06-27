// 
//  SplashView.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import UIKit

class SplashView: UIViewController {
    
    var presenter: SplashPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

extension SplashView {
    private func setupView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if let presenter = self.presenter {
                presenter.goToHome()
            }
        }
    }
}

