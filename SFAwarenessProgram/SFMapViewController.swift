//
//  SFMapViewController.swift
//  SFAwarenessProgram
//
//  Created by Ahyathreah Effi-yah(Vinny Harris-Riviello) on 3/3/16.
//  Copyright © 2016 TrhUArrayLUV. All rights reserved.
// Currently using Swift 2.1

import UIKit
import MapKit

class SFMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView?
    let sanFrancisco = CLLocation(latitude: 37.77, longitude: -122.44)
    var sfAnnotations = [SFAnnotation]() {
        didSet {
            updateMap(sfAnnotations)
        }
    }
    var sfByDistrict: Rating.SFByDistrict?
    var offset = 0
    let limit = 48
    var fromDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setUpMap(sanFrancisco)
        updateSF()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adjustOffset(inout offset: Int, by: Int) {
        offset += by
    }
    
    func setUpMap(location: CLLocation) {
        if let map = mapView {
            let radius = 16777.0
            let region = MKCoordinateRegionMakeWithDistance(location.coordinate, radius, radius)
            map.setRegion(region, animated: true)
        }
    }
    
    func configureView() {
        //let systemFont = UIFont.systemFontOfSize(16.0, weight: UIFontWeightLight)
        let systemFont = UIFont.systemFontOfSize(16.0)
        let blue = SFColor().sfBlue
        let navBarAttributesDictionary: [String: AnyObject] = [
            NSForegroundColorAttributeName: blue,
            NSFontAttributeName: systemFont
        ]
        navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        navigationController?.navigationBar.tintColor = blue
        self.title = "SF Awareness Program"
    }
    
    func updateMap(sfAnnotations: [SFAnnotation]) {
        if let old = mapView?.annotations {
            mapView?.removeAnnotations(old)
        }
        mapView?.addAnnotations(sfAnnotations)
    }
    
    func updateSF() {
        let from = fromDate ?? calculateFromDate()
        updateSFDistricts(offset, limit: limit, from: from)
        adjustOffset(&offset, by: limit)
    }
    
    @IBAction func moreButtonPressed(sender: UIBarButtonItem) {
        updateSF()
    }
    
    func updateSFDistricts(offset: Int, limit: Int, from: String) {
        let districtService = SFDistrictService()
        districtService.fetchSFIncidents(limit, offset: offset, from: from, sfByDistrict: sfByDistrict, delegate: self) {
            (let rating) in
            if let sfAnnotations = rating?.rankedAnnotations, let sfByDistrict = rating?.sfByDistrict {
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.sfAnnotations = sfAnnotations
                    self.sfByDistrict = sfByDistrict
                }
            }
        }
    }
}
