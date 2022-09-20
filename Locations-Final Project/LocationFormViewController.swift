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
    @IBOutlet weak var date: UITextField!
    
    let imagePicker = UIImagePickerController()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dateFormatter.dateFormat = "MM/dd/yyyy"
        date?.text = dateFormatter.string(from: datePicker.date)
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year {
            print("\(day) \(month) \(year)")
            print("date", date)
            
            date?.text = "\(month)/\(day)/\(year)"
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func btnSaveClicked(_ sender: UIButton) {
        //let jpeg = imgView.image?.jpegData(compressionQuality: 0.75)
        
        if let png = imgView.image?.pngData(){
            let n = name.text!
            let lat = latitude.text!
            let long = longitude.text!
            
            DatabaseHelper.shared.saveImageToCoreData(imgData: png, n, lat, long)
        }
    }
    
    @IBAction func selectPhotos(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        present(vc, animated: true)
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
