//
//  LocationManager.swift
//  SchoolApp
//
//  Created by Prince Avecillas on 9/5/24.
//

import CoreLocation
import Combine

class UserLocationManager: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    @Published var userCoordinates: CLLocationCoordinate2D?
    @Published var isLocationServicesDisabled = false 
    var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func checkLocationAuthorization() {
        let status = locationManager.authorizationStatus
        switch status {
        case .denied, .restricted:
            isLocationServicesDisabled = true
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            isLocationServicesDisabled = false
        @unknown default:
            isLocationServicesDisabled = true
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        print("Success: \(location)")
        self.userCoordinates = location.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with error: \(error)")
        checkLocationAuthorization()
    }
}
