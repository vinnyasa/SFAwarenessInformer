/*********************************************************************
 ** Program name: SF Awareness Informer
 ** Author: Vinny Harris-Riviello
 ** Date: March 3, 2016
 ** Description: Struct to SFDictrictsService manage network calls.
 *********************************************************************/

import Foundation

struct SFDistrictService {
    
    var sfBaseURL: NSURL? = NSURL(string: "https://data.sfgov.org/resource/ritf-b9ki.json")
    
    func fetchSFIncidents(limit: Int, offset: Int, from: String, sfByDistrict: Rating.SFByDistrict?, delegate: NetworkDelegate, completion: (Rating?) -> Void) {
        
        let filters = "?$where=date%3E='\(from)'&$order=date%20DESC&$limit=\(limit)" + "&$offset=\(offset)"
        
        if let urlPath = NSURL(string: filters, relativeToURL: sfBaseURL) {
            let networkOperation = NetworkOperation(url: urlPath)
            networkOperation.delegate = delegate
            networkOperation.downloadJSONFromURL{
                (let JSONArray) in
                guard let sfIncidentsByDistrict = sfByDistrict else {
                    completion(Rating(sfIncidentsArray: JSONArray))
                    return
                }
                completion(Rating(sfIncidentsArray: JSONArray, sfByDistrict: sfIncidentsByDistrict))
            }
        }
    }
}

