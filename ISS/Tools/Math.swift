//
//  Math.swift
//  ISS
//
//  Created by Prince Avecillas on 9/4/24.
//

import Foundation
import CoreLocation

struct ISSMath {
    
    static let earthRadiusInMeters: CLLocationDistance = 6_378_137
    static let issHeightInMeters = 402_336

    /// Calculates the secant between two coordinates on earth
    static func getSecantOfEarthBetweenTwoPointsInMeters(_ point1: CLLocationCoordinate2D, _ point2: CLLocationCoordinate2D) -> Int {
                
        // Convert latitudes and longitudes to radians
        let latRadians1 = point1.latitude * .pi / 180
        let longRadians1 = point1.longitude * .pi / 180
        let latRadians2 = point2.latitude * .pi / 180
        let longRadians2 = point2.longitude * .pi / 180
        
        // Convert to cartesian
        let x1 = earthRadiusInMeters * cos(latRadians1) * cos(longRadians1)
        let y1 = earthRadiusInMeters * cos(latRadians1) * sin(longRadians1)
        let z1 = earthRadiusInMeters * sin(latRadians1)

        let x2 = earthRadiusInMeters * cos(latRadians2) * cos(longRadians2)
        let y2 = earthRadiusInMeters * cos(latRadians2) * sin(longRadians2)
        let z2 = earthRadiusInMeters * sin(latRadians2)
        
        // Calculate the secant
        let secant = sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1) + (z2 - z1) * (z2 - z1))

        return Int(secant)
    }
        
    /// Calculates distance to object in space using its shadow coordinate position on earth
    /// and height in meters
    static func get3DDistanceToISS(_ point: CLLocationCoordinate2D, _ objectCoordinates: CLLocationCoordinate2D) -> Int {
        let secant = Self.getSecantOfEarthBetweenTwoPointsInMeters(point, objectCoordinates)
        
        let distance = sqrt(pow(Double(secant), 2) + pow(Double(issHeightInMeters), 2))
        return Int(distance)
    }
    
    /// Calculates velocity of the ISS based on 2 data points
    static func calculateVelocityInMPH(_ model1: ISSModel, _ model2: ISSModel) -> Double? {
        guard let latitude1 = Double(model1.iss_position.latitude),
              let longitude1 = Double(model1.iss_position.longitude),
              let latitude2 = Double(model2.iss_position.latitude),
              let longitude2 = Double(model2.iss_position.longitude) else {
            print("Invalid coordinates")
            return nil
        }

        let location1 = CLLocation(latitude: latitude1, longitude: longitude1)
        let location2 = CLLocation(latitude: latitude2, longitude: longitude2)
        let distance = location1.distance(from: location2)
        let isModel1Earlier = model1.timestamp < model2.timestamp
        
        let startTimestamp = isModel1Earlier ? model1.timestamp : model2.timestamp
        let endTimestamp = isModel1Earlier ? model2.timestamp : model1.timestamp
        
        let timeDifference = endTimestamp - startTimestamp
        
        guard timeDifference > 0 else {
            print("Invalid time difference")
            return nil
        }
        
        let speedInMetersPerSecond = distance / timeDifference
        let speedInMilesPerHour = speedInMetersPerSecond * 2.23694
        
        return speedInMilesPerHour
    }
}

struct UnitConversion {
    
    /// Converts meters to miles
    static func metersToMiles<T: Numeric>(_ meters: T) -> Double? {
        if let metersAsInteger = meters as? (any BinaryInteger) {
            return Double(metersAsInteger) / 1609.34
        } else if let metersAsFloatingPoint = meters as? (any BinaryFloatingPoint) {
            return Double(metersAsFloatingPoint) / 1609.34
        } else {
            return nil
        }
    }
}
