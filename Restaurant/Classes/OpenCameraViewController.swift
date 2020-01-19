//
//  OpenCameraViewController.swift
//  Restaurant
//
//  Created by Apoorva on 18/01/20.
//  Copyright © 2020 AppsFoundation. All rights reserved.
//

import UIKit
import SwiftyJSON

class OpenCameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var qty: UITextField!
    
    var strDate: String?
    
   
    @IBAction func expiry(_ sender: UIDatePicker) {
        print(sender.date)
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .medium

        strDate = timeFormatter.string(from: sender.date)
    }
    
    
    @IBOutlet weak var ImageView: UIImageView!
    

    @IBOutlet weak var labelResults: UITextView!
    
   
    
    var items = [MenuItem]()
    
    
    
    
   // @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let session = URLSession.shared
    
    var selectedImage: UIImage!
    
    var googleAPIKey = "AIzaSyBc8W6b-lmQ5Jqgax8pUu8OPoEqw8FURUQ"
       var googleURL: URL {
           return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
       }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ImageView.image = selectedImage
        
        setupTextFields()
        
    
        
//        labelResults.delegate = self as! UITextViewDelegate
//        qty.delegate = self as! UITextFieldDelegate
        

        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        qty.resignFirstResponder()
//
//        return true
//    }
    
    func setupTextFields() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        qty.inputAccessoryView = toolbar
    }
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        let vc =  OurMenuViewController(nibName: "OurMenuViewController", bundle: nil)
        vc.inQty = Int(qty.text!)
        vc.inLabel = labelResults.text
        vc.inExpiry = strDate
        vc.inImage = selectedImage
        let newItem = MenuItem(name: labelResults.text, image: selectedImage, qty: Int(qty.text!)!, expiry: strDate!)
        vc.menuItems.append(newItem)
        //vc.savedBtn()
        
    }

}


extension OpenCameraViewController {
    
    
    
    
    
    func analyzeResults(_ dataToParse: Data) {
        
        // Update UI on the main thread
        DispatchQueue.main.async(execute: {
            
            
            // Use SwiftyJSON to parse results
            let json = JSON(dataToParse)
            let errorObj: JSON = json["error"]
            
            //self.spinner.stopAnimating()
            self.ImageView.isHidden = false
            self.labelResults.isHidden = false
           // self.faceResults.isHidden = false
           // self.faceResults.text = ""
            
            // Check for errors
            if (errorObj.dictionaryValue != [:]) {
                self.labelResults.text = "Error code \(errorObj["code"]): \(errorObj["message"])"
            } else {
                // Parse the response
                print(json)
                let responses: JSON = json["responses"][0]
                
//
                // Get label annotations
                let labelAnnotations: JSON = responses["labelAnnotations"]
                let numLabels: Int = labelAnnotations.count
                var labels: Array<String> = []
                if numLabels > 0 {
                    var labelResultsText:String = ""
                    if numLabels > 1 {
                       // for index in 0..<numLabels {
                        labels = [labelAnnotations[1]["description"].stringValue]
                          //  labels.append(label)
                        //}
                    }
                    for label in labels {
                        // if it's not the last item add a comma
                        if labels[labels.count - 1] != label {
                            labelResultsText += "\(label), "
                        } else {
                            labelResultsText += "\(label)"
                        }
                    }
                    self.labelResults.text = labelResultsText
                } else {
                    self.labelResults.text = "No labels found"
                }
            }
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Base64 encode the image and create the request
        let binaryImageData = base64EncodeImage(selectedImage)
        createRequest(with: binaryImageData)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let pickedImage = selectedImage {
//            ImageView.contentMode = .scaleAspectFit
//            ImageView.image = pickedImage // You could optionally display the image here by setting imageView.image = pickedImage
//            spinner.startAnimating()
//            //faceResults.isHidden = true
//            labelResults.isHidden = true
//
//            // Base64 encode the image and create the request
//            let binaryImageData = base64EncodeImage(pickedImage)
//            createRequest(with: binaryImageData)
//        }
//
//        dismiss(animated: true, completion: nil)
//    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}


/// Networking

extension OpenCameraViewController {
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata?.count > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func createRequest(with imageBase64: String) {
        // Create our request URL
        
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 2
                    ],
                    [
                        "type": "FACE_DETECTION",
                        "maxResults": 1
                    ]
                ]
            ]
        ]
        let jsonObject = JSON(jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        request.httpBody = data
        
        // Run the request on a background thread
        DispatchQueue.global().async { self.runRequestOnBackgroundThread(request) }
    }
    
    func runRequestOnBackgroundThread(_ request: URLRequest) {
        // run the request
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            self.analyzeResults(data)
        }
        
        task.resume()
    }
}


// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

//extension OpenCameraViewController: UITableViewDataSource {
//    
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: MenuItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "menuItemCell") as! MenuItemTableViewCell
//        let item = items[indexPath.row]
//        
//        //display data from MenuItems.plist
////        let dateFormatter = DateFormatter()
////        dateFormatter.dateStyle = .medium
////        let d = Date()
////        let eDate = dateFormatter.string(from: d)
//        
////        cell.itemImage.image =  UIImage(named: item.image)
////        cell.itemLabel.text =  item.name
////        cell.expiryLabel.text = lll
////        cell.qtyLabel.text = "100"
//        let url = URL.init(fileURLWithPath: "../Resources/images/tomato.png")
//
//        let imageData:NSData = NSData(contentsOf: url)!
//
//        guard let urlImage = UIImage(data: imageData as Data) else { return cell}
//
////        cell.imgTool.image = image
//        
//        
//        let tomato = MenuItem(name: "Tomato", image: urlImage, qty: 2, expiry: item.expiry)
//        
//        let url2 = URL.init(fileURLWithPath: "../Resources/images/bellpepper.jpeg")
//
//        let imageData2:NSData = NSData(contentsOf: url2)!
//
//        guard let urlImage2 = UIImage(data: imageData2 as Data) else { return cell }
//
//        
//        let bellpepper = MenuItem(name: "BellPepper", image: urlImage2, qty: 5, expiry: item.expiry)
//        
//        let url3 = URL.init(fileURLWithPath: "../Resources/images/potato.png")
//
//        let imageData3:NSData = NSData(contentsOf: url3)!
//
//        guard let urlImage3 = UIImage(data: imageData3 as Data) else { return cell }
//
//        let potato = MenuItem(name: "Potato", image: urlImage3, qty: 3, expiry: item.expiry)
//        
//        items.append(tomato)
//        items.append(potato)
//        items.append(bellpepper)
//
//        
//        cell.backgroundColor = UIColor.clear
//        
//        return cell
//    }
//
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
//    }
//}
//
