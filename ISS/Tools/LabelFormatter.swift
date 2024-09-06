//
//  LabelFormatter.swift
//  ISS
//
//  Created by Prince Avecillas on 9/5/24.
//

import Foundation
import UIKit

struct LabelFormatter {
    static func createAttributedText(boldText: String, regularText: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(
            string: boldText,
            attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)]
        )
        
        attributedString.append(NSAttributedString(
            string: regularText,
            attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        ))
        
        return attributedString
    }
}
