//
//  AutoZoneSearchResultsViewController.swift
//  VehiclePartsDetectionUsingAR
//
//  Created by Venkata Pranathi Immaneni on 3/15/21.
//

import UIKit
import MapKit

class AutoZoneSearchResultsViewController: UIViewController {

    @IBOutlet weak var resultsTableView: UITableView!
    var nearestLocations: [MKMapItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Nearest Auto Stores"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getNearestLocationItems()
    }
    
    func getNearestLocationItems() {
        let locationRequest =  MKLocalSearch.Request()
        locationRequest.naturalLanguageQuery = "Auto"
//        locationRequest.region = mapView.region
        let searchRequest = MKLocalSearch(request: locationRequest)
        searchRequest.start { (results, _) in
            if let res = results {
                self.nearestLocations = res.mapItems
                DispatchQueue.main.async {
                    self.resultsTableView.reloadData()
                }
            } else {
               print("Error")
                return
            }
        }
    }
    
    func getAddressOfStore(placemark:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let fstSeperator = (placemark.subThoroughfare != nil && placemark.thoroughfare != nil) ? " " : ""
        // comma in between street and city and state
        let commaSeparator = (placemark.subThoroughfare != nil || placemark.thoroughfare != nil) && (placemark.subAdministrativeArea != nil || placemark.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secSeperator = (placemark.subAdministrativeArea != nil && placemark.administrativeArea != nil) ? " " : ""
        let finalAddress = String(
            format:"%@%@%@%@%@%@%@",
            // StreetNum
            placemark.subThoroughfare ?? "",
            fstSeperator,
            // Name of the street
            placemark.thoroughfare ?? "",
            commaSeparator,
            // city
            placemark.locality ?? "",
            secSeperator,
            // state
            placemark.administrativeArea ?? ""
        )
        return finalAddress
    }

}

extension AutoZoneSearchResultsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nearestLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationDetailsTableViewCell") as? LocationDetailsTableViewCell
        cell?.title.text = self.nearestLocations[indexPath.row].placemark.name
        cell?.desc.text = self.getAddressOfStore(placemark: self.nearestLocations[indexPath.row].placemark)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let findStoresVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FindNearByStoresViewController") as? FindNearByStoresViewController
        findStoresVC?.storePlaceMark = self.nearestLocations[indexPath.row].placemark
        self.navigationController?.pushViewController(findStoresVC!, animated: true)
        
    }
    
}
