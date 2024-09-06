//
//  MockDataManager.swift
//  ISSTests
//
//  Created by Prince Avecillas on 9/5/24.
//

import Foundation
import Combine
@testable import ISS

class MockDataManager: ISSDataManaging {
    func getISSData(_ fileName: ISSURLs) -> AnyPublisher<Data, Error> {
        var localJson = ""
        
        switch fileName {
        case .location:
            localJson = "MockLocations"
        case .astronauts:
            localJson = "MockAstronauts"
        }
        
        guard let fileURL = Bundle.main.url(forResource: localJson, withExtension: "json") else {
            print("Failed to locate \(fileName).json in bundle")
            return Fail(error: URLError(.fileDoesNotExist)).eraseToAnyPublisher()
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            return Just(data)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
