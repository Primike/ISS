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
    
    /// Creates the first viewController
    func start() {
        let dataManager = ISSDataManager()
        let viewModel = ISSViewModel(dataManager: dataManager)
        let viewController = ISSViewController(viewModel: viewModel)
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    /// Presents the viewController that displays logs of ISS locations
    func presentLogs(_ viewModel: ISSViewModel) {
        navigationController.present(ISSLogsViewController(viewModel: viewModel), animated: true)
    }
}
