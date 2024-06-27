// 
//  SplashRouter.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import UIKit

class SplashRouter {
    
    func showView() -> SplashView {
        let interactor = SplashInteractor()
        let presenter = SplashPresenter(interactor: interactor)
        let view = SplashView(nibName: String(describing: SplashView.self), bundle: nil)
        view.presenter = presenter
        return view
    }
    
    func goToHome() {
        let homeViewController = HomeRouter().showView()
        let navigationController = UINavigationController(rootViewController: homeViewController)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
}
