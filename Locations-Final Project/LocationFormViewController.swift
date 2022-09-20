//
//  ViewController.swift
//  locations
//
//  Created by Parwat Kunwar on 2022-09-19.
//

import UIKit

class LocationFormViewController: UIViewController {
    @IBOutlet weak var imgView: UIImageView!

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var info: UITextField!
    
    let imagePicker = UIImagePickerController()
    let dateFormatter = DateFormatter()
    var date: String = ""
    var locationCollectionViewCtrl: LocationCollectionViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dateFormatter.dateFormat = "MM/dd/yyyy"
        date = dateFormatter.string(from: datePicker.date)
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year {
            print("date", date)
            
            date = "\(month)/\(day)/\(year)"
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // Add a location
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        //let jpeg = imgView.image?.jpegData(compressionQuality: 0.75)
        
        let valitionErr = validateLocationInput();
        
        if (!valitionErr.isEmpty) {
            let alertController = getAlertController(valitionErr)
            
            return present(alertController, animated: true, completion: nil)
        } else {
            if let png = imgView.image?.pngData(){
                let name = name.text!
                let lat = latitude.text!
                let long = longitude.text!
                let date = date
                let info = info.text!
                
                DatabaseHelper.shared.saveLocationToCoreData(imgData: png, name, lat, long, info, date)

                
                let alertController = getAlertController("Location added.")
                present(alertController, animated: true, completion: nil)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    alertController.dismiss(animated: true)
                    
                    self.backToCollection()
                }
            }
        }
    }
    
    func backToCollection() {
        locationCollectionViewCtrl = storyboard?.instantiateViewController(withIdentifier: "LocationCollectionViewController") as? LocationCollectionViewController
        
        locationCollectionViewCtrl.modalPresentationStyle = .fullScreen
        self.present(locationCollectionViewCtrl, animated: true, completion: nil)
    }
    
    @IBAction func selectPhotos(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func validateLocationInput() -> String {
        // date is initialzed while screen renders/mounts.
        if (name.text!.isEmpty && latitude.text!.isEmpty && longitude.text!.isEmpty && info.text!.isEmpty) {
            return "Please enter location name, latitude, longitude, description and image.";
        }
        
        if (name.text!.isEmpty) {
            return "Please enter location name";
        }
        
        if (latitude.text!.isEmpty) {
            return "Please enter latitude";
        }
        
        if (longitude.text!.isEmpty) {
            return "Please enter longitude."
        }
        
        if (info.text!.isEmpty) {
            return "Please enter info."
        }
        
        if (latitude.text!.isEmpty || longitude.text!.isEmpty) {
            return "Invalid input entered in latitude or longitude";
        }
        
        if ((imgView.image?.pngData()) == nil) {
            return "Please select a photo."
        }
        
        return "";
    }
}

extension LocationFormViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let img = info[.originalImage] as? UIImage{
            imgView.image = img
        }
    }
}
