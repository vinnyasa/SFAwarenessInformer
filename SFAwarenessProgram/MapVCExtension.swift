/*********************************************************************
 ** Program name: SF Awareness Informer
 ** Author: Vinny Harris-Riviello
 ** Date: March 5, 2016
 ** Description: extension to MapViewController to network errors and
 ** add delegate methods.
 *********************************************************************/

import Foundation
import MapKit

extension SFMapViewController: MKMapViewDelegate, NetworkDelegate {
    
    // MARK: - NetworkwDelegateMethod
    func catchNetworkError(errorType: ErrorType) {
        //handle gracefully ex: show alert, this is an example of catching an errorType thru delegation
    }
    
    // MARK: - MapViewDelegateMethods
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? SFAnnotation else { return nil }
        let identifier = "colorPin"
        let pinAnnotationView: MKPinAnnotationView
        //check reusable
        if let dqView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
            dqView.annotation = annotation
            pinAnnotationView = dqView
        } else {
            pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pinAnnotationView.animatesDrop = true
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.calloutOffset = CGPoint(x: -8, y: 8)
        }
        //assign color
        if let color = annotation.color {
            pinAnnotationView.pinTintColor = color
        }
        return pinAnnotationView
    }
    
    //MARK: Date
    // now returning: 2015-12-01, would have to adjust to dataBase functionality. This method was built thinking that in a real app, would have to just go back to begging of month or so, but if it was going to be a static date, then would have done this method differently. Also since using formatters once calculated the return value is assign to a stored property, thus only calculating fromDate once.
    func calculateFromDate() -> String {
        let today = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month], fromDate: today)
        let begginingOfMonth = calendar.dateFromComponents(components)!
        // compensate 3 months back
        let comps3Back = NSDateComponents()
        comps3Back.month = -3
        let threeMonthsBack = calendar.dateByAddingComponents(comps3Back, toDate: begginingOfMonth, options: [])!
        let threeMonthsBackString = dateFormatter.stringFromDate(threeMonthsBack)
        // should only be calculated once.
        fromDate = threeMonthsBackString
        return threeMonthsBackString
    }
}
