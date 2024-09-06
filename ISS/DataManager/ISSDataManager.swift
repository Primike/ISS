//
//  ISSDataManager.swift
//  ISS
//
//  Created by Prince Avecillas on 9/3/24.
//

import Foundation
import Combine

protocol ISSDataManaging {
    func getISSData(_ url: ISSURLs) -> AnyPublisher<Data, Error>
}

class ISSDataManager: ISSDataManaging {
    
    func getISSData(_ url: ISSURLs) -> AnyPublisher<Data, Error> {
        guard let url = URL(string: url.rawValue) else {
            print("Failed to make URL")
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Invalid response")
                    throw URLError(.badServerResponse)
                }

                return data
            }
            .eraseToAnyPublisher()
    }
}
