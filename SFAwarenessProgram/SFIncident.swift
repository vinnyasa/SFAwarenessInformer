/*********************************************************************
 ** Program name: SF Awareness Informer
 ** Author: Vinny Harris-Riviello
 ** Date: March 3, 2016
 ** Description: struct to represent the data about incidents in SF.
 *********************************************************************/

import Foundation
import MapKit

struct SFIncident {
    let district: District?
    let offense: String?
    let location: CLLocation?
    let time: String?
    let dayOfWeek: String?
    var date: String?
    static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter
    }()
    
    init(sfIncidentDictionary: [String: AnyObject]) {
        if let districtName = sfIncidentDictionary["pddistrict"] as? String{
            district = District(rawValue: districtName)
        } else { district = nil }
        if let offense = sfIncidentDictionary["category"] as? String {
            self.offense = offense
        } else { offense = nil }
        if let locationDictionary = sfIncidentDictionary["location"], latitud = locationDictionary["latitude"] as? String, longitud = locationDictionary["longitude"] as? String, latitude = Double(latitud), longitude = Double(longitud) {
            location = CLLocation(latitude: Double(latitude), longitude: Double(longitude))
        } else { location = nil }
        
        if let time = sfIncidentDictionary["time"] as? String {
            self.time = time
        } else { time = nil }
        
        if let dayOfWeek = sfIncidentDictionary["dayofweek"] as? String {
            self.dayOfWeek = dayOfWeek
        } else { dayOfWeek = nil }
        
        if let timeStamp = sfIncidentDictionary["date"] as? String {
            if let unix = Double(timeStamp) {
                let date = NSDate(timeIntervalSince1970: unix)
                self.date = SFIncident.dateFormatter.stringFromDate(date)
            } else { date = nil }
        }
    }
}
