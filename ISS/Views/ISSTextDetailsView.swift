//
//  ISSTextDetailsView.swift
//  ISS
//
//  Created by Prince Avecillas on 9/5/24.
//

import Foundation
import UIKit
import Combine

class ISSTextDetailsView: UIView {
    
    private let viewModel: ISSViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: ISSViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        layout()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    lazy var iss2DLocation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.text = "Not Available"
        return label
    }()
    
    lazy var iss3DLocation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.text = "Not Available"
        return label
    }()
    
    lazy var iss2DSpeed: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.text = "Not Available"
        return label
    }()
    
    lazy var showLogsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show Location Logs", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 8
        return button
    }()
    
    private func setupBindings() {
        viewModel.$issProperties
            .receive(on: DispatchQueue.main)
            .sink { [weak self] properties in
                guard let self = self else { return }
                
                guard let properties = properties else {
                    self.iss2DLocation.attributedText = LabelFormatter.createAttributedText(boldText: "ISS Shadow: ", regularText: "Not Available")
                    self.iss3DLocation.attributedText = LabelFormatter.createAttributedText(boldText: "ISS Distance: ", regularText: "Not Available")
                    self.iss2DSpeed.attributedText = LabelFormatter.createAttributedText(boldText: "ISS Speed: ", regularText: "Not Available")
                    return
                }
                
                // Update 2D distance label with bold text
                if let converted2D = UnitConversion.metersToMiles(properties.iss2DDistanceInMeters) {
                    let miles2D = String(Int(converted2D))
                    self.iss2DLocation.attributedText = LabelFormatter.createAttributedText(boldText: "ISS Shadow: ", regularText: "\(miles2D) miles away")
                }
                
                // Update 3D distance label with bold text
                if let converted3D = UnitConversion.metersToMiles(properties.iss3DDistanceInMeters) {
                    let miles3D = String(Int(converted3D))
                    self.iss3DLocation.attributedText = LabelFormatter.createAttributedText(boldText: "ISS Distance: ", regularText: "\(miles3D) miles away in space")
                }
                
                // Update speed label with bold text
                self.iss2DSpeed.attributedText = LabelFormatter.createAttributedText(boldText: "ISS Speed: ", regularText: "\(properties.iss2DSpeed) Miles Per Hour")
            }
            .store(in: &cancellables)
    }

    private func layout() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        stackView.addArrangedSubview(iss2DLocation)
        stackView.addArrangedSubview(iss3DLocation)
        stackView.addArrangedSubview(iss2DSpeed)
        stackView.addArrangedSubview(showLogsButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
