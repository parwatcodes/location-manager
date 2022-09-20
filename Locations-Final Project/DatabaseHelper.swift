//
//  DatabaseHelper.swift
//  locations
//
//  Created by Parwat Kunwar on 2022-09-19.
//

import Foundation
import UIKit
import CoreData

class DatabaseHelper{
    
    static let shared = DatabaseHelper()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // method to add location data into coreData.
    func saveLocationToCoreData(imgData: Data, _ name: String, _ lat: String, _ long: String, _ info: String, _ date: String)
    {
        let location = NSEntityDescription.insertNewObject(forEntityName: "Location", into: context) as! Location
        location.photo = imgData
        location.name = name
        location.latitude = lat
        location.longitude = long
        location.info = info
        location.date = date
        
        do {
            try context.save()
        } catch{
            print("Error saving location data.")
        }
    }
    
    // Method to fetch all locations record from coreData.
    func getLocationsFromCoreData() -> [Location] {
        var locations = [Location]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        
        do {
            locations = try context.fetch(fetchRequest) as! [Location]
        } catch {
            print("Error getting locations.")
        }
        
        return locations
    }
    
    // Method to fetch a location from coreData bty index id.
    func getLocationFromCoreData(index: Int) -> Location {
        var arrLocation = [Location]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        
        do {
            arrLocation = try context.fetch(fetchRequest) as! [Location]
            
        } catch {
            print("Error getting location.")
        }
        
        return arrLocation[index]
    }
    
    func deleteLocationData(index : Int) {
    
        do {
            var location = getLocationFromCoreData(index: index) as Location
            
            if (location.name != nil) {
                context.delete(location)
                try context.save()
            } else {
                print("Failed to delete")
            }
        } catch{
            print("Failed to delete")
        }
    }
}
