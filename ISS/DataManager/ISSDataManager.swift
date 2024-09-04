//
//  ISSDataManager.swift
//  ISS
//
//  Created by Prince Avecillas on 9/3/24.
//

import Foundation
import Combine

class ISSDataManager {
    
    func getISSData(_ url: String) -> AnyPublisher<Data, Error> {
        guard let url = URL(string: url) else {
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
