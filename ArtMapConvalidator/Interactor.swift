//
//  Interactor.swift
//  ArtMapConvalidator
//
//  Created by Andrea Mantani on 21/02/16.
//  Copyright © 2016 Andrea Mantani. All rights reserved.
//

import UIKit
import Parse

class Interactor : UIViewController{
    
    /*func retrieveUserList(controller: UserController) -> UserController{
        let query = PFQuery(className:"_User")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                print("Successfully retrieved \(objects!.count) users.")
                if let objects = objects as [PFObject]? {
                    for object in objects {
                        controller.createList(object)
                    }
                }
                
            }
        }
        
        return controller
        
    }

    func retrieveUserObject(user: String) -> PFObject{
        let query = PFQuery(className:"_User")
        query.whereKey("username", equalTo: user as AnyObject)
        var returnUser = PFObject(className: "_User")
        do{
            if let tmp : NSArray = try query.findObjects(){
                for usr in tmp{
                    returnUser = usr as! PFObject
                }
            }else{
                print("No such items")
            }
        }catch{
            print("Queery Error")
        }
        
        return returnUser
    }
    
    func retrieveUserRecord(user: String) -> User{
        let query = PFQuery(className:"_User")
        query.whereKey("username", equalTo: user as AnyObject)
        var returnUser = User()
        do{
            if let tmp : NSArray = try query.findObjects(){
                for usr in tmp{
                    returnUser = User(object: usr as! PFObject)
                }
            }else{
                print("No such items")
            }
        }catch{
            print("Queery Error")
        }
        
        return returnUser
    }

    func retriveDBMarkerImage(marker: Marker) -> UIImage{
        return retriveDBMarkerInfo(marker).getImage()
    }
    func retrieveArtistInformation(artistName : String) -> String{
        let query = PFQuery(className: "Artist")
        query.whereKey("artistName", containsString: artistName)
        
        var myInformation = ""
        
        do{
            if var tmp : Array = try query.findObjects(){
                myInformation = tmp[0]["artistInformation"] as! String
            }
        }catch{
            return "NOSUCHITEMS"
        }
        
        return myInformation
        
    }
    
    func retrieveArtistMappingOccurencies(artistName : String) -> Int{
        let query = PFQuery(className: "MainDB")
        query.whereKey("author", containsString: artistName)
        
        var occurencies = 0
        
        do{
            if var tmp : Array = try query.findObjects(){
                
                let size = tmp.count
                
                for index in 0...size - 1{
                    let control = tmp[index]["author"] as! String
                    if artistName.capitalizedString != control.capitalizedString {
                        tmp.removeAtIndex(index)
                    }
                }
                
                occurencies = tmp.count
            }
            
            
        }catch{
            print("No such items")
        }
        
        return occurencies
    }
    */
    
    func retrieveArtInformation(artId : Int) -> PFObject?{
        let query = PFQuery(className: "MainDB")
        query.whereKey("artId", equalTo: artId)
        
        do{
            if let result : PFObject = try query.getFirstObject(){
                print(result["artId"]!)
                print("inteee")
                return result
            }
        }catch{
            print("error query")
        }
        
        return nil
    }
    func retrieveReportToConfirm() -> [PFObject]{
        let query = PFQuery(className: "Report")
        
        query.whereKey("moderated", notEqualTo: 1)
        
        let returnList = [PFObject]()
        
        do{
            if let result : [PFObject] = try query.findObjects(){
                return result
            }
        }catch{
            print("error query")
        }
        
        return returnList
    }
    func retrieveUploadToConfirm() -> [PFObject]{
        let query = PFQuery(className: "UploadedImage")
        
        var returnList = [PFObject]()
        
        query.whereKey("moderated", notEqualTo: 1)
        do {
            if let result : [PFObject] = try query.findObjects(){
                
                for item in result{
                    if item["user"] != nil{
                        returnList.append(item)
                    }
                }
                return returnList
            }
        }catch{
            print("error query")
        }
        
        return returnList
    }
    
    func retrieveUserInformation(username : String)-> PFObject?{
        let query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: username)
        
        do{
            if let result : PFObject = try query.getFirstObject(){
                if result["username"] != nil{
                    print(result["username"])
                    return result
                }
            }
        }catch{
            print("error query")
        }
        
        return nil
    }
    
    func uploadNewArt(title: String, author: String, year: String, visibility: String, image : UIImage, latitude: String, longitude: String, tag : String, user: String){
    
    }
    
    func updateReportModerated(reportId : String){
        let query = PFQuery(className: "Report")
        query.whereKey("objectId", equalTo: reportId)
        
        query.getFirstObjectInBackgroundWithBlock { (object : PFObject?, error :  NSError?) -> Void in
            if error == nil{
                object!["moderated"] = 1
                object?.saveInBackground()
            }
        }
    }
    
    func updateUserInformation(publishedPhotos : Int, checkIns : Int, reports : Int, user : PFObject){
        
        if user.objectId == nil{
            return
        }
        
        let query = PFQuery(className: "_User")

        query.whereKey("objectId", equalTo: user.objectId!)
        
        do{
            if user["password"] == nil{
               PFUser.logInWithAuthTypeInBackground("admin", authData: user["authData"] as! [String : String])
            }
        }catch{
            print("error login")
            return
        }
        
        
        query.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            if error == nil && object != nil{
            
                if(publishedPhotos != 0){
                    object!.incrementKey("publishedPhotos")
                }
                if checkIns != 0{
                    object!.incrementKey("checkins")
                }
                if reports != 0{
                    object!.incrementKey("reports")
                }
                
                object?.saveEventually({ (success : Bool, error: NSError?) -> Void in
                    if success{
                        PFUser.logOut()
                    }
                })
            }
        }
        
    }
    
    /*let currenteUser : PFObject = PFUser.currentUser()!
    
    if currenteUser["username"] == nil{
    return
    }
    
    let query = PFQuery(className: "_User")
    query.whereKey("objectId", equalTo: currenteUser.objectId!)
    
    query.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
    if error == nil && object != nil{
    if(publishedPhotos != 0){
    object!.incrementKey("publishedPhotos")
    }
    if checkIns != 0{
    object!.incrementKey("checkIns")
    }
    if reports != 0{
    object!.incrementKey("reports")
    }
    
    object?.saveInBackground()
    }
    }
    
    }*/

    /*
    func retriveDBMarkerInfo(marker: Marker) -> Marker{
        let query = PFQuery(className:"MainDB")
        var mrkImageFile : PFFile
        query.whereKey("artId", equalTo: marker.getId() as AnyObject)
        do{
            if let tmp : NSArray = try query.findObjects(){
                for mkr in tmp{
                    marker.setInfoFromRecord(mkr as! PFObject)
                    mrkImageFile = mkr["image"] as! PFFile
                    if let img : NSData = try mrkImageFile.getData(){
                        marker.setImage(UIImage(data: img)!)
                    }
                    
                }
            }
        }catch{
            print("Query Error")
        }
        
        return marker
        
    }
    
    func retrieveLogin(email: String, password: String)throws -> Bool{
        let query = PFQuery(className: "_User")
        query.whereKey("email", equalTo: email as AnyObject)
        do{
            if let c : NSArray = try query.findObjects(){
                if c.count == 0 {
                    NSUserDefaults.standardUserDefaults().setObject("NOSUCHUSER", forKey: "username")
                    return false
                }else{
                    for user in c{
                        if user["username"] != nil {
                            do{
                                try PFUser.logInWithUsername(user["username"] as! String, password: password)
                            } catch{
                                print("LogIn failure")
                                return false
                            }
                        }else{
                            PFUser.logOut()
                        }
                        
                    }
                }
            }
        }catch{
            print("Queery Error")
            return false
        }
        
        return true
    }
    func uploadNewArtistReport(artistInformation: String){
        if artistInformation != ""{
            let newRecord = PFObject(className: "Report")
            
            newRecord["username"] = PFUser.currentUser()!["username"] as! String
            newRecord["artistInformation"] = artistInformation
            
            updateUserInformation(0, checkIns: 0, reports: 1)
            
            newRecord.saveInBackground()
        }
    }
    func uploadNewReport(id: Int, position: CLLocationCoordinate2D, art: Art, visibility: String, geoAccuracy: CLLocationAccuracy, isInPosition: Bool){
        
        let newRecord = PFObject(className: "Report")
        
        newRecord["artId"] = id
        newRecord["author"] = art.getAuthor()
        newRecord["geoAccuracy"] = geoAccuracy
        if isInPosition{
            newRecord["isInPosition"] = "Yes"
        }else{
            newRecord["isInPosition"] = "No"
        }
        newRecord["latitude"] = position.latitude
        newRecord["longitude"] = position.longitude
        newRecord["status"] = visibility
        newRecord["title"] = art.getTitle()
        newRecord["username"] = PFUser.currentUser()!["username"] as! String
        newRecord["year"] = String(art.getYear())
        
        updateUserInformation(0, checkIns: 0, reports: 1)
        
        newRecord.saveInBackgroundWithBlock{
            (success: Bool, error: NSError?) -> Void in
            if let error = error {
                _=error.userInfo["error"] as? NSString
            }
        }
        
    }
    
    
    func uploadNewUser(user: User, password : String){
        let usr = PFUser()
        usr.username = user.getUsername()
        usr.password = password
        usr["checkCounter"] = 0
        usr["checkIns"] = 0
        usr.email = user.getEmail()
        usr["phone"] =  "000000000"//non implementato
        usr["publishedPhotos"] = 0
        usr["reports"] = 0
        usr["votes"] = 0
        
        usr.signUpInBackgroundWithBlock{
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error{
                _ = error.userInfo["error"] as? NSString
            }
        }
    }
    func uploadNewFBUser(user: User){
        let usr = PFUser()
        usr.username = user.getUsername()
        usr.password = ""
        usr["checkCounter"] = 0
        usr["checkIns"] = 0
        usr.email = user.getEmail()
        usr["phone"] =  "000000000"//non implementato
        usr["publishedPhotos"] = 0
        usr["reports"] = 0
        usr["votes"] = 0
        
        do{
            try usr.signUp()
        }catch{
            print("error signup")
        }
    }
    
    
    func uploadArt(username: String, location: CLLocationCoordinate2D, image: UIImage?, accuracy: Int, art: Art){
        
        let newRecord = PFObject(className: "Prova")
        newRecord["author"] = art.getAuthor()
        newRecord["geoAccuracy"] = accuracy
        newRecord["imageFile"] = PFFile(
            data: UIImageJPEGRepresentation(image!, 0.1)!)
        //newRecord["imageId"] = imageId
        newRecord["latitude"] = location.latitude
        newRecord["longitude"] = location.longitude
        newRecord["title"] = art.getTitle()
        newRecord["username"] = username
        newRecord["year"] = String(art.getYear())
        
        updateUserInformation(1, checkIns: 0, reports: 0)
        
        newRecord.saveInBackgroundWithBlock{
            (success: Bool, error: NSError?) -> Void in
            if let error = error {
                _=error.userInfo["error"] as? NSString
            }
        }
        
        
    }
    
    func updateUserInformation(publishedPhotos : Int, checkIns : Int, reports : Int){
        let currenteUser : PFObject = PFUser.currentUser()!
        
        if currenteUser["username"] == nil{
            return
        }
        
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: currenteUser.objectId!)
        
        query.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            if error == nil && object != nil{
                if(publishedPhotos != 0){
                    object!.incrementKey("publishedPhotos")
                }
                if checkIns != 0{
                    object!.incrementKey("checkIns")
                }
                if reports != 0{
                    object!.incrementKey("reports")
                }
                
                object?.saveInBackground()
            }
        }
        
    }*/
}

