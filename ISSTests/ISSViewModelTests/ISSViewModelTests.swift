//
//  ISSViewModelTests.swift
//  ISSTests
//
//  Created by Prince Avecillas on 9/5/24.
//

import XCTest
@testable import ISS
import CoreLocation

final class ISSViewModelTests: XCTestCase {

    var sut: ISSViewModel!

    override func setUp() {
        super.setUp()
        sut = ISSViewModel(dataManager: MockDataManager())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testAstronautFetch() {
        guard let astronauts = sut.astronauts else { return }
        XCTAssert(astronauts[0].name == "Oleg Kononenko")
        XCTAssert(astronauts.count == 12)
    }
    
    func testISSLocationAfterFetch() {
        guard let latitude = sut.issCurrentLocation?.latitude,
              let longitude = sut.issCurrentLocation?.longitude else {
            return
        }
        
        let mockLatitude = 30.1375, mockLongitude = 51.8391
        
        XCTAssert(latitude == mockLatitude)
        XCTAssert(longitude == mockLongitude)
    }
    
    func testISSPropertiesAfterFetch() {
        guard let properties = sut.issProperties else { return }
        
        XCTAssertEqual(properties.iss2DSpeed, 0)
    }
    
    func testGetAstronautInfoCellText() {
        guard let astronauts = sut.astronauts else { return }

        let mockName = "Name: Oleg Kononenko"
        let mockCraft = "Craft: ISS"
        
        XCTAssertEqual(mockName, sut.getAstronautInfoCellText(for: IndexPath(index: 0)).0)
        XCTAssertEqual(mockCraft, sut.getAstronautInfoCellText(for: IndexPath(index: 0)).1)
    }
}
