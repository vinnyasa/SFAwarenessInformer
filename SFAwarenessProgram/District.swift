/*********************************************************************
 ** Program name: SF Awareness Informer 
 ** Author: Vinny Harris-Riviello
 ** Date: March 3, 2016
 ** Description: Enum District to manage name of districts 
 *********************************************************************/


import Foundation
import MapKit

enum District: String {
    case Bayview = "BAYVIEW"
    case Central = "CENTRAL"
    case Ingleside = "INGLESIDE"
    case Mission = "MISSION"
    case Northern = "NORTHERN"
    case Park = "PARK"
    case Richmond = "RICHMOND"
    case Southern = "SOUTHERN"
    case Taraval = "TARAVAL"
    case Tenderloin = "TENDERLOIN"
    
    
    func index() -> Int {
        switch self {
        case .Bayview:
            return 0
        case .Central:
            return 1
        case .Ingleside:
            return 2
        case .Mission:
            return 3
        case .Northern:
            return 4
        case .Park:
            return 5
        case .Richmond:
            return 6
        case .Southern:
            return 7
        case .Taraval:
            return 8
        case .Tenderloin:
            return 9
        }
    }
    
    func clLocation() -> CLLocation {
        switch self {
        case .Bayview:
            return CLLocation(latitude: 37.7297897, longitude: -122.3979338)
        case .Central:
            return CLLocation(latitude: 37.7987385, longitude: -122.4121168)
        case .Ingleside:
            return CLLocation(latitude: 37.7247533, longitude: -122.4484867)
        case .Mission:
            return CLLocation(latitude: 37.7628977, longitude: -122.4242374)
        case .Northern:
            return CLLocation(latitude: 37.78019, longitude: -122.4346339)
        case .Park:
            return CLLocation(latitude: 37.7677729, longitude: -122.4573844)
        case .Richmond:
            return CLLocation(latitude: 37.7800021, longitude: -122.4665056)
        case .Southern:
            return CLLocation(latitude: 37.7642589, longitude: -122.4459439)
        case .Taraval:
            return CLLocation(latitude: 37.7437422, longitude: -122.4836652)
        case .Tenderloin:
            return CLLocation(latitude: 37.7836345, longitude: -122.4150925)
        }

    
    }
}

struct DistrictSet {
    let districts: Set<String> = [ "BAYVIEW", "CENTRAL", "INGLESIDE", "MISSION", "NORTHERN", "PARK", "RICHMOND", "SOUTHERN", "TARAVAL", "TENDERLOIN"]
    
}
