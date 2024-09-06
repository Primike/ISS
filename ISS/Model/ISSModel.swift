//
//  ISSModel.swift
//  ISS
//
//  Created by Prince Avecillas on 9/3/24.
//

import Foundation

struct ISSModel: Decodable {
    let timestamp: TimeInterval
    let message: String
    let iss_position: ISSCoordinates
}

struct ISSCoordinates: Decodable {
    let longitude: String
    let latitude: String
}

struct ISSPeople: Decodable {
    let message: String
    let number: Int
    let people: [Astronaut]
}

struct Astronaut: Decodable {
    let craft: String
    let name: String
}
