//
//  ReportConvalidatorViewController.swift
//  ArtMapConvalidator
//
//  Created by Andrea Mantani on 21/02/16.
//  Copyright © 2016 Andrea Mantani. All rights reserved.
//

import UIKit
import Parse

class ReportConvalidatorViewController : UIViewController, Convalidator{
    
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtAuthor: UITextField!
    @IBOutlet weak var txtyear: UITextField!
    @IBOutlet weak var txtState: UITextField!
    
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var txtArtistInformation: UITextView!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var objects : [PFObject]?
    var index = 0
    
    @IBAction func exit(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func showNext(sender: AnyObject) {
        if objects?.count == 0{
            return
        }
        
        index++
        
        if !outOfIndex(index, items: objects!){
            index--
            return
        }
        
        showNextItem(index, items: objects!)
    }
    @IBAction func Checked(sender: AnyObject) {
        if objects?.count == 0{
            return
        }
        Interactor().updateReportModerated(objects![index].objectId!)
        let user = Interactor().retrieveUserInformation(objects![index]["username"] as! String)
        Interactor().updateUserInformation(0, checkIns: 0, reports: 1, user: user!)
        objects?.removeAtIndex(index)
        showNextItem(index, items: objects!)
        
    }
    
    @IBAction func showPrev(sender: AnyObject) {
        
        if objects?.count == 0{
            return
        }
        
        index--
        
        if !outOfIndex(index, items: objects!){
            index++
            return
        }
        showNextItem(index, items: objects!)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objects = Interactor().retrieveReportToConfirm()
        print(objects?.count)
        showNextItem(index, items: objects!)
    }
    
    internal func outOfIndex(index: Int, items: [NSObject]) -> Bool {
        if index >= objects?.count{
            return false
        }
        if index < 0{
            return false
        }
        return true
    }
    internal func showNextItem(index : Int, items : [NSObject]){
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
        
        if objects[index]["artId"] != nil{
            print(objects[index]["artId"] )
            let imageRetrieved = Interactor().retrieveArtInformation(objects[index]["artId"] as! Int)
            
            if imageRetrieved != nil{
                let imageToSet = imageRetrieved!["image"] as! PFFile
                do{
                    if let imgToSet : NSData = try imageToSet.getData(){
                        self.image.image = UIImage(data: imgToSet)
                    }
                }catch{
                    print("error image")
                }
            }else{
                //Alert
            }
        }else{
            self.image.image = UIImage()
        }
        
        if objects[index]["year"] != nil{
            self.txtyear.text = objects[index]["year"] as? String
        }else{
            self.txtyear.text = ""
        }
        if objects[index]["username"] != nil{
            self.user.text = objects[index]["username"] as? String
        }else{
            self.user.text = ""
        }
        if objects[index]["latitude"] != nil{
            self.latitude.text = String(objects[index]["latitude"] as! Double)
        }else{
            self.latitude.text = ""
        }
        if objects[index]["longitude"] != nil{
            self.longitude.text = String(objects[index]["longitude"] as! Double)
        }else{
            self.longitude.text = ""
        }
        if objects[index]["artistInformation"] != nil{
            self.txtArtistInformation.text = objects[index]["artistInformation"] as? String
        }else{
            self.txtArtistInformation.text = ""
        }

    }
}
