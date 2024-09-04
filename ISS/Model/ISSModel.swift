//
//  ISSModel.swift
//  ISS
//
//  Created by Prince Avecillas on 9/3/24.
//

import Foundation

struct ISSCoordinates: Codable {
    let longitude: String
    let latitude: String
}

struct ISSModel: Codable {
    let timestamp: Int
    let message: String
    let iss_position: ISSCoordinates
}
