//
//  ViewController.swift
//  ArtMapConvalidator
//
//  Created by Andrea Mantani on 21/02/16.
//  Copyright © 2016 Andrea Mantani. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, Convalidator {

  
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtAuthor: UITextField!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var user: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var txtTag: UITextField!
    
    var index = 0
    var objects : [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        objects = Interactor().retrieveUploadToConfirm()
        print(objects?.count)
        showNextItem(index, items: objects!)

    }
    @IBAction func deny(sender: AnyObject) {
        if !outOfIndex(index, items: objects!){
            return
        }
        index++
        showNextItem(index, items: objects!)
    }
    @IBAction func approve(sender: AnyObject) {
        if !outOfIndex(index, items: objects!){
            return
        }
        Interactor().uploadNewArt(txtTitle.text!, author: txtAuthor.text!, year: txtYear.text!, visibility: txtState.text!, image : image.image!, latitude: lblLatitude.text!, longitude: lblLongitude.text!, tag : txtTag.text!, user: user.text!)
        index++
        showNextItem(index, items: objects!)
    }
    
    internal func outOfIndex(index: Int, items: [NSObject]) -> Bool {
        if index >= objects?.count{
            return false
        }
        return true
    }
    
    internal func showNextItem(index : Int, items : [NSObject]){
        print("viewcontr")
        print(index)
        if !outOfIndex(index, items: items){
            return
        }
        
        
        let objects = items as! [PFObject]
        
        if objects[index]["title"] != nil{
            self.txtTitle.text = objects[index]["title"] as? String
        }else{
            self.txtTitle.text = ""
        }
        if objects[index]["author"] != nil{
            self.txtAuthor.text = objects[index]["author"] as? String
        }else{
            self.txtAuthor.text = ""
        }
        if objects[index]["imageFile"] != nil{
            let imageToSet = objects[index]["imageFile"] as! PFFile
            do{
            if let imgToSet : NSData = try imageToSet.getData(){
                self.image.image = UIImage(data: imgToSet)
                }
            }catch{
                print("error image")
            }
        }else{
            self.image.image = UIImage()
        }
        if objects[index]["year"] != nil{
            self.txtYear.text = objects[index]["year"] as! String
        }else{
            self.txtYear.text = ""
        }
        if objects[index]["user"] != nil{
            self.user.text = objects[index]["user"] as! String
        }else{
            self.user.text = ""
        }
        if objects[index]["latitude"] != nil{
            self.lblLatitude.text = String(objects[index]["latitude"] as! Double)
        }else{
            self.lblLatitude.text = ""
        }
        if objects[index]["longitude"] != nil{
            self.lblLongitude.text = String(objects[index]["longitude"] as! Double)
        }else{
            self.lblLongitude.text = ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

