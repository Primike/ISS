//
//  ISSViewController.swift
//  ISS
//
//  Created by Prince Avecillas on 9/3/24.
//

import Foundation
import UIKit

class ISSViewController: UIViewController {
    
    weak var coordinator: ISSCoordinator?
    let viewModel: ISSViewModel
    
    init(viewModel: ISSViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
}
