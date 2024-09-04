//
//  ISSViewModel.swift
//  ISS
//
//  Created by Prince Avecillas on 9/3/24.
//

import Foundation
import Combine

class ISSViewModel {
    
    let dataManager: ISSDataManager
    var cancellables = Set<AnyCancellable>()
    
    init(dataManager: ISSDataManager) {
        self.dataManager = dataManager
        getISSLocationData()  
    }
    
    private func getISSLocationData() {
        dataManager.getISSData(ISSURLs.location.rawValue)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished")
                case .failure(let error):
                    print("Error occurred: \(error)")
                }
            }, receiveValue: { data in
                print("Received data: \(data)")
            })
            .store(in: &cancellables)
    }
}
