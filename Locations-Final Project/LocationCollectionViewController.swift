//
//  LocationCollectionViewController.swift
//  Locations-Final Project
//
//  Created by Parwat Kunwar on 2022-09-19.
//

import UIKit

class LocationCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var locations = [Location]();
    var locationFormViewController: LocationFormViewController!
    var mapViewController: MapViewController!
    var locationCollectionViewCtrl: LocationCollectionViewController!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        loadLocationsData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadLocationsData(){
        locations = DatabaseHelper.shared.getLocationsFromCoreData()
    }
    
    @IBAction func deleteLocation(_ sender: UIButton) {

        var superview = sender.superview
        while let view = superview, !(view is UICollectionViewCell) {
            superview = view.superview
        }
        guard let cell = superview as? UICollectionViewCell else {
            print("button is not contained in a table view cell")
            return
        }
        guard let indexPath = collectionView.indexPath(for: cell) else {
            print("failed to get index path for cell containing button")
            return
        }
        // We've got the index path for the cell that contains the button, now do something with it.
        
            DatabaseHelper.shared.deleteLocationData(index: indexPath.row)
        
        let alertController = getAlertController("Location Deleted...")
        present(alertController, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            alertController.dismiss(animated: true)
            
            self.reloadCollectionView()
        }
    }
    
    func reloadCollectionView() {
        locationCollectionViewCtrl = storyboard?.instantiateViewController(withIdentifier: "LocationCollectionViewController") as? LocationCollectionViewController
        
        locationCollectionViewCtrl.modalPresentationStyle = .fullScreen
        self.present(locationCollectionViewCtrl, animated: false, completion: nil)
    }
    
    @IBAction func openLocationForm(_ sender: Any) {
        locationFormViewController = storyboard?.instantiateViewController(withIdentifier: "LocationFormViewController") as? LocationFormViewController
        
        locationFormViewController.modalPresentationStyle = .fullScreen
        self.present(locationFormViewController, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell

        cell.locationName?.text = locations[indexPath.row].name
        cell.locationDescription?.text = locations[indexPath.row].info
        cell.locationVisitedDate?.text = locations[indexPath.row].date
        
        if let imgData = locations[indexPath.row].photo {
            cell.locationImage?.image = UIImage(data: imgData)
        }
        
        //This creates the shadows and modifies the cards a little bit
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToMapView(indexPath.item)
    }
    
    func navigateToMapView(_ index: Int) {
        mapViewController = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
        
        mapViewController.modalPresentationStyle = .fullScreen
        mapViewController.locationIndex = index
        self.present(mapViewController, animated: true, completion: nil)
    }
}

