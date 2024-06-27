// 
//  SplashPresenter.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import Foundation

class SplashPresenter {
    
    private let interactor: SplashInteractor
    private let router = SplashRouter()
    
    init(interactor: SplashInteractor) {
        self.interactor = interactor
    }
    
    func goToHome() {
        router.goToHome()
    }
    
}
