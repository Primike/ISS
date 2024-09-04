//
//  Coordinator.swift
//  ISS
//
//  Created by Prince Avecillas on 9/3/24.
//

import Foundation
import UIKit

class ISSCoordinator {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let dataManager = ISSDataManager()
        let viewModel = ISSViewModel(dataManager: dataManager)
        let viewController = ISSViewController(viewModel: viewModel)
        viewController.view.backgroundColor = .blue
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
