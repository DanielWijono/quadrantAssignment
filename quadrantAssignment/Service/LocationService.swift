//
//  LocationService.swift
//  quadrantAssignment
//
//  Created by Daniel Wijono on 15/04/22.
//

import Foundation
import MapKit

protocol LocationServiceProtocol: AnyObject {
    func getLatitude() -> Double
    func getLongitude() -> Double
    func requestLocation()
}

class LocationProvider: NSObject, LocationServiceProtocol, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var location: CLLocation?

    override init () {
        super.init()
        locationManager.delegate = self

        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
            guard let currentLocation = locationManager.location else { return }
            location = currentLocation
        default:
            locationManager.requestAlwaysAuthorization()
            locationManager.requestLocation()
        }
    }

    func getLatitude() -> Double {
        return location?.coordinate.latitude ?? .zero
    }

    func getLongitude() -> Double {
        return location?.coordinate.longitude ?? .zero
    }

    func requestLocation() {
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        location = latestLocation
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error)
    }

}

class LocationService {
    static let shared: LocationServiceProtocol = LocationProvider()
}
