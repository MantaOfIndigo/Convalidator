//
//  Marker.swift
//  ArtMapConvalidator
//
//  Created by Andrea Mantani on 21/02/16.
//  Copyright © 2016 Andrea Mantani. All rights reserved.
//

import UIKit
import GoogleMaps
import Parse

class Marker: NSObject, UIActivityItemSource {
    
    private var marker : GMSMarker
    private var id : Int = Int()
    private var image : UIImage
    private var user : User
    private var art : Art
    
    override init(){
        self.marker = GMSMarker()
        self.image = UIImage()
        self.art = Art(title: "", author: "", year: 0)!
        self.user = User()
        
        super.init()
    }
    init(position: CLLocationCoordinate2D, title: String, author: String, year: Int, visibility: Int){
        
        self.marker = GMSMarker()
        self.marker.icon = UIImage(named: "marker")
        self.marker.position = position
        //self.marker.appearAnimation = kGMSMarkerAnimationPop
        self.marker.infoWindowAnchor = CGPointMake(0.44, 0.45);
        
        self.image = UIImage()
        self.user = User()
        self.art = Art(title: title, author: author, year: year, status: visibility)!
        
        
    }
    init(position: CLLocationCoordinate2D, id: Int){
        
        self.marker = GMSMarker()
        self.marker.icon = UIImage(named: "marker")
        self.marker.position = position
        //self.marker.appearAnimation =
        self.marker.infoWindowAnchor = CGPointMake(0.44, 0.45);
        
        self.image = UIImage()
        self.id = id
        self.art = Art()
        self.user = User()
        
        
    }
    
    init(position: CLLocationCoordinate2D, user: User){
        self.marker = GMSMarker()
        self.marker.icon = UIImage(named: "marker")
        self.marker.position = position
        //self.marker.appearAnimation = kGMSMarkerAnimationPop
        self.marker.infoWindowAnchor = CGPointMake(0.44, 0.45);
        
        self.image = UIImage()
        self.art = Art()
        self.user = user
    }
    func setImage(value: UIImage){
        self.image = value
    }
    func setInfoFromRecord(value: PFObject){
        self.art = Art(object: value)!
    }
    func setUser(user: User){
        self.user = user
    }
    func setArt(value: Art){
        self.art = value
    }
    func getMarker() -> GMSMarker{
        return self.marker
    }
    /*func getId() -> Int{
    return self.id
    
    }*/
    func getImage() -> UIImage{
        return self.image
    }
    func getId() -> Int{
        return self.id
    }
    func getArt() -> Art{
        return self.art
        
    }
    func getUser() -> User{
        return self.user
    }
    
    func activityViewControllerPlaceholderItem(activityViewController: UIActivityViewController) -> AnyObject {
        if self.getArt().getAuthor() == ""{
            
            return "Author: Unknown \n\nCondiviso con ArtMap! - versione iOS"
        }
        
        return "Author: " + self.getArt().getAuthor() + " \n\nCondiviso con ArtMap! - versione iOS"
    }
    func activityViewController(activityViewController: UIActivityViewController, itemForActivityType activityType: String) -> AnyObject? {
        if activityType == UIActivityTypePostToFacebook{
            activityViewController.title = "Shared with ArtMap!"
            
            return self.getImage()
        }
        
        return ""
    }
    
    func activityViewController(activityViewController: UIActivityViewController, subjectForActivityType activityType: String?) -> String {
        if self.getArt().getAuthor() == ""{
            
            return "Author: Unknown \n\nCondiviso con ArtMap! - versione iOS"
        }
        
        return "Author: " + self.getArt().getAuthor() + " \n\nCondiviso con ArtMap! - versione iOS"
    }
    
    
}
