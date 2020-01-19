//
//  OurMenuViewController.swift
//  Restaurant
//
//  Created by AppsFoundation on 8/28/15.
//  Copyright © 2015 AppsFoundation. All rights reserved.
//

import UIKit


class OurMenuViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
   
    
    @IBOutlet weak var minus: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var image: UIImage?
    
    var inQty: Int!
    var inExpiry: String!
    var inLabel: String!
    var inImage: UIImage!
    
    
    var menuItems: [MenuItem] = []
    
    
    @IBOutlet weak var addItem: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        menuItems = MenuItemsManager.sharedManager.loadData()
//        let url = URL.init(fileURLWithPath: "./Restaurant/Resources/images/tomato.png")
//        let imageData:NSData = NSData(contentsOf: url)!
        let urlImage = UIImage(named: "tomato")!
        let tomato = MenuItem(name: "Tomato", image: urlImage, qty: 2, expiry: "2020-01-27")
        
//        let url2 = URL.init(fileURLWithPath: "./Resources/images/bellpepper.jpg")
//        let imageData2:NSData = NSData(contentsOf: url2)!
        let urlImage2 = UIImage(named: "bellpepper")!
        let bellpepper = MenuItem(name: "BellPepper", image: urlImage2, qty: 5, expiry: "2020-01-27")
//
//        let url3 = URL.init(fileURLWithPath: "./Resources/images/potato.jpg")
//        let imageData3:NSData = NSData(contentsOf: url3)!
        let urlImage3 = UIImage(named: "potato")!
        let potato = MenuItem(name: "Potato", image: urlImage3, qty: 3, expiry: "2020-01-27")
        
        menuItems.append(tomato)
        menuItems.append(potato)
        menuItems.append(bellpepper)
        
//        if (inQty != nil) {
//            let newItem = MenuItem(name: inLabel, image: inImage, qty: inQty, expiry: inExpiry)
//            menuItems.append(newItem)
//            tableView.reloadData()
//        }
        
        setupTextFields()
    }
//    func savedBtn() {
//        self.tableView.reloadData()
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func OpenCamera(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            //self.present(imagePicker, animated: true, completion: nil)
        self.present(imagePicker, animated: true, completion: nil)/*{
                self.performSegue(withIdentifier: "Photo", sender: self)
            print("in here4")
            }*/
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        /*guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }*/
        
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
//        guard (info[UIImagePickerControllerEditedImage] as? UIImage) != nil else {
//            print("Error: \(info)")
//            return
//        }
        dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "AddItem", sender: self)
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let destinationVC = segue.destination as! OpenCameraViewController
            //if let image = selectedImage {
            destinationVC.selectedImage = image
           // }
        }
    }
    
    func setupTextFields() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        searchBar.inputAccessoryView = toolbar
    }
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    
    
}

 

// MARK: - UITableViewDataSource
//extension OurMenuViewController: UITableViewDataSource {
//
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: MenuItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "menuItemCell") as! MenuItemTableViewCell
//        let item = menuItems[indexPath.row]
//
//        //display data from MenuItems.plist
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        let d = Date()
//        let lll = dateFormatter.string(from: d)
//
//        cell.itemImage.image =  UIImage(named: item.image)
//        cell.itemLabel.text =  item.name
//        cell.expiryLabel.text = lll
//        cell.qtyLabel.text = "100"
//
//
//        cell.backgroundColor = UIColor.clear
//
//        return cell
//    }
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return menuItems.count
//    }
//}



extension OurMenuViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MenuItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "menuItemCell") as! MenuItemTableViewCell
        
        let item = menuItems[indexPath.row]
        
        //display data from MenuItems.plist
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        let d = Date()
//        let eDate = dateFormatter.string(from: d)
        
//        cell.itemImage.image =  UIImage(named: item.image)
//        cell.itemLabel.text =  item.name
//        cell.expiryLabel.text = lll
//        cell.qtyLabel.text = "100"
        
        
        //for i in 0..<menuItems.count{
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateStyle = .medium
//            let d = Date()
//            let eDate = dateFormatter.string(from: d)
            cell.itemLabel.text = item.name
            cell.itemImage.image = item.image
            cell.expiryLabel.text = item.expiry
            cell.qtyLabel.text = String(item.qty)
            
      //  }
        
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }

    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
}

extension Date
{
    func toString( dateFormat format  : Date ) -> String
    {
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = format
        return dateFormatter.string(from: format)
    }
}


