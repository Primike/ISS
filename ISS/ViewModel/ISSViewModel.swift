//
//  ISSViewModel.swift
//  ISS
//
//  Created by Prince Avecillas on 9/3/24.
//

import Foundation
import Combine
import CoreLocation

struct ISSProperties {
    let iss2DDistanceInMeters: Int
    let iss3DDistanceInMeters: Int
    let iss2DSpeed: Int
}

class ISSViewModel: ObservableObject {
    
    @Published private(set) var issCurrentLocation: CLLocationCoordinate2D?
    @Published private(set) var loggedLocations: [ISSModel] = []
    @Published private(set) var issProperties: ISSProperties?
    @Published private(set) var astronauts: [Astronaut]?
    private let locationManager = UserLocationManager()
    private let dataManager: ISSDataManaging
    private var cancellables = Set<AnyCancellable>()
    
    init(dataManager: ISSDataManaging) {
        self.dataManager = dataManager
        getAstronautData()
        getISSLocationData()
    }
    
    // MARK: - Fetching data for ISS
    
    /// Fetch data for people in the ISS
    private func getAstronautData() {
        dataManager.getISSData(ISSURLs.astronauts.rawValue)
            .retry(5)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Failed to fetch astronaut data: \(error)")
                }
            }, receiveValue: { [weak self] data in
                guard let self = self else { return }
                
                do {
                    let people = try JSONDecoder().decode(ISSPeople.self, from: data)
                    self.astronauts = people.people
                    print("Got Astronauts")
                } catch(let error) {
                    print("Astronaut data error: \(error)")
                    self.astronauts = nil
                }
            })
            .store(in: &cancellables)
    }

    /// Fetch data for the current location of the ISS every 5 seconds
    private func getISSLocationData() {
        Timer.publish(every: 5.0, on: .main, in: .common)
            .autoconnect()
            .prepend(Date())
            .flatMap { _ in
                self.dataManager.getISSData(ISSURLs.location.rawValue)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.handleCompletion(completion)
            }, receiveValue: { [weak self] data in
                self?.handleReceivedData(data)
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Handling the fetched data
    
    private func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .failure(let error):
            print("API fetch error: \(error)")
        case .finished:
            break
        }
    }

    private func handleReceivedData(_ data: Data) {
        do {
            let model = try JSONDecoder().decode(ISSModel.self, from: data)
            self.loggedLocations.append(model)
            if self.loggedLocations.count > 500 { self.loggedLocations.removeFirst() }
            
            self.calculateISSDetails(model)
        } catch {
            print("Decoding Error: \(error)")
        }
    }

    /// Creates ISSProperties to display
    private func calculateISSDetails(_ issModel: ISSModel) {
        guard let issLatitude = Double(issModel.iss_position.latitude),
              let issLongitude = Double(issModel.iss_position.longitude),
              let userCoordinates = locationManager.userCoordinates else {
            return
        }
        
        let issLocation = CLLocation(latitude: issLatitude, longitude: issLongitude)
        let userLocation = CLLocation(latitude: userCoordinates.latitude, longitude: userCoordinates.longitude)

        issCurrentLocation = issLocation.coordinate
        let iss2DDistanceInMeters = Int(userLocation.distance(from: issLocation))
        let iss3DDistanceInMeters = ISSMath.get3DDistanceToISS(issLocation.coordinate, userLocation.coordinate)
        
        // If there are 2 or more data points calculate the speed of ISS
        if loggedLocations.count >= 2 {
            guard let speed = ISSMath.calculateVelocityInMPH(issModel, loggedLocations[loggedLocations.count - 2]) else {
                return
            }
            
            let iss2DSpeed = Int(speed)
            
            issProperties = ISSProperties(iss2DDistanceInMeters: iss2DDistanceInMeters, iss3DDistanceInMeters: iss3DDistanceInMeters, iss2DSpeed: iss2DSpeed)
        }
    }
    
    // MARK: - ISS details text methods
    
    func getAstronautInfoCellText(for indexPath: IndexPath) -> (String, String) {
        guard let craft = astronauts?[indexPath.row].craft,
              let name = astronauts?[indexPath.row].name else {
            return ("Not Available", "Not Available")
        }
        
        return ("Name: \(name)", "Craft: \(craft)")
    }
    
    func getNumberOfAstronautsText(for section: Int) -> String {
        guard let astronauts = astronauts else {
            return "Astronauts On Board The ISS: Not Available"
        }
        
        let label = "Astronauts On Board The ISS: "
        return label + (astronauts.isEmpty ? "Not Available" : "\(astronauts.count)")
    }
    
    // MARK: - ISS logs text methods
    
    func getLogCellText(for indexPath: IndexPath) -> (String, String) {
        let latitudeText = "Latitude: \(loggedLocations[indexPath.row].iss_position.latitude)"
        let longitudeText = "Longitude: \(loggedLocations[indexPath.row].iss_position.longitude)"
        
        let timestamp = loggedLocations[indexPath.row].timestamp
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE HH:mm:ss"
        dateFormatter.locale = Locale.current

        return (dateFormatter.string(from: date), latitudeText + ",    " + longitudeText)
    }
}
