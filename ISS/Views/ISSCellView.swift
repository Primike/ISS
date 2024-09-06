//
//  ISSCellView.swift
//  ISS
//
//  Created by Prince Avecillas on 9/5/24.
//

import Foundation
import UIKit

class ISSCellView: UITableViewCell {
    
    static let reuseIdentifier = "ISSCellView"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layout()
    }

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    lazy var text1Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.text = "Not Available"
        return label
    }()
    
    lazy var text2Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.text = "Not Available"
        return label
    }()

    /// Configues the cell with 2 labels
    func configureCell(_ text: (top: String, bottom: String)) {
        layout()
        
        text1Label.text = text.top
        text2Label.text = text.bottom
    }
    
    private func layout() {
        addSubview(stackView)
        stackView.addArrangedSubview(text1Label)
        stackView.addArrangedSubview(text2Label)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16)
        ])
    }
}
