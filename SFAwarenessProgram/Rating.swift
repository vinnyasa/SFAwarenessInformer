//
//  Ranking.swift
//  SFAwarenessProgram
//
//  Created by Ahyathreah Effi-yah on 3/4/16.
//  Copyright © 2016 TrhUArrayLUV. All rights reserved.
//

import Foundation

class Rating {
    var rankedAnnotations: [SFAnnotation] = []
    let districts =  DistrictSet().districts
    var sfByDistrict: SFByDistrict
    let sfColor = SFColor()
    
    init (sfIncidentsArray: [[String: AnyObject]]?) {
        self.sfByDistrict = SFByDistrict()
        let sfIncidents = sfIncidentsFromJson(sfIncidentsArray)
        self.rankedAnnotations = annotationsFromSFIncidents(sfIncidents)
    }

    init (sfIncidentsArray: [[String: AnyObject]]?, sfByDistrict: SFByDistrict) {
        self.sfByDistrict = SFByDistrict(incidents: sfByDistrict.incidents, pddWithIncident: sfByDistrict.districtsWithIncident)
        let sfIncidents = sfIncidentsFromJson(sfIncidentsArray)
        self.rankedAnnotations = annotationsFromSFIncidents(sfIncidents)
        
    }
    
    struct SFByDistrict {
        var incidents: [[SFIncident]]
        var districtsWithIncident = Set<String>()
        init() {
            incidents = [[SFIncident]](count: 10, repeatedValue: [SFIncident]())
        }
        init(incidents: [[SFIncident]], pddWithIncident: Set<String>) {
            self.incidents = incidents
            self.districtsWithIncident = pddWithIncident
        }
        
        mutating func append(sfIncidents: [SFIncident]) -> [[SFIncident]]  {
            for incident in sfIncidents {
                if let index = incident.district?.index(), let name = incident.district?.rawValue {
                    incidents[index].append(incident)
                    districtsWithIncident.insert(name)
                }
            }
            return incidents
        }
    }
    
    func annotationsFromSFIncidents(sfIncidents: [SFIncident]) -> [SFAnnotation]  {
        
        let incidentsByDistrict = sfByDistrict.append(sfIncidents)
        var sorted = sortByCrimeCount(incidentsByDistrict)
        sorted.removeRange((sfByDistrict.districtsWithIncident.count)..<districts.count)
        let annotations = toAnnotation(sorted)
        return annotations
    }
    
    func sortByCrimeCount(sfIncidents: [[SFIncident]]) -> [[SFIncident]] {
        return sfIncidents.sort {sf1, sf2 in sf1.count > sf2.count}
    }
    
    func toAnnotation(districtedIncidents: [[SFIncident]]) -> [SFAnnotation] {
        var sfAnnotations = [SFAnnotation]()
        var index = 0
        for district in districtedIncidents {
            let count = district.count
            let color = index <= 6 ? sfColor.colorsArray[index] : sfColor.lowColor
            
            for incident in district {
                if let coordinate = incident.location?.coordinate, let name = incident.district?.rawValue.lowercaseString {
                    let annotation = SFAnnotation(coordinate: coordinate, district: name, incidentCount: count, color: color, type: .Incident)
                    sfAnnotations.append(annotation)
                }
            }
            // ++ will be deprecated for Swift 3.0 so using += 
            index += 1
        }
        //assing districts crime-free
        if let crimeFreeDistricts = crimelessDistricts(districts) {
            for district in crimeFreeDistricts {
                let annotation = SFAnnotation(coordinate: district.clLocation().coordinate, district: district.rawValue.lowercaseString, incidentCount: 0, color: sfColor.lowColor, type: .DistrictCenter)
                sfAnnotations.append(annotation)
            }
        }
        return sfAnnotations
    }
    
    func sfIncidentsFromJson(sfIncidentsArray: [[String: AnyObject]]?) -> [SFIncident] {
        var sfIncidents = [SFIncident]()
        if let sfArray = sfIncidentsArray {
            for incident in sfArray {
                let sfIncident = SFIncident(sfIncidentDictionary: incident)
                sfIncidents.append(sfIncident)
            }
        }
        return sfIncidents
    }
    
    func crimelessDistricts(var districts: Set<String>) -> [District]? {
        
        for district in sfByDistrict.districtsWithIncident {
            districts.remove(district)
        }
        var crimelessArray = [District]()
        guard !districts.isEmpty else {
            return nil
        }
        for district in districts {
            if let crimeFreeDistrict = District(rawValue: district) {
                crimelessArray.append(crimeFreeDistrict)
            }
        }
        return crimelessArray
    }
}