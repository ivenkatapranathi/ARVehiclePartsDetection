//
//  VehicleInformationReader.swift
//  VehiclePartsDetectionUsingAR
//
//  Created by Venkata Pranathi Immaneni on 3/10/21.
//

import Foundation

class VehicleInformationReader {
    
    internal static var SharedInst = VehicleInformationReader()
    internal var partsData: [String: AnyObject] = [String: AnyObject]()
    //Anyobject is of type: String: Anyobject

    init() {
        self.vehicleInfoDataGetJSON()
    }
    
    func vehicleInfoDataGetJSON() {
        if let vehicleInfoJsonpath = Bundle.main.path(forResource: "VehicleInfo", ofType: "json") {
            do {
                let vehicleInfojsondata = try Data(contentsOf: URL(fileURLWithPath: vehicleInfoJsonpath), options: .mappedIfSafe)
                let vehicleInfojsonResult = try JSONSerialization.jsonObject(with: vehicleInfojsondata, options: .mutableLeaves)
                if let vehicleInfojsonresult = vehicleInfojsonResult as? [String: AnyObject] {
                      self.partsData = vehicleInfojsonresult
                }
            } catch {
                print(error)
            }
        }
    }
    
    func getPartInfo(partName: String) -> [String: String]? {
        let singlePartInfo = self.partsData[partName] as? [String: String]
        return singlePartInfo
    }
}
