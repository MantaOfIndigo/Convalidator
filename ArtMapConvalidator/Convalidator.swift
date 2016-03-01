//
//  Convalidator.swift
//  ArtMapConvalidator
//
//  Created by Andrea Mantani on 22/02/16.
//  Copyright © 2016 Andrea Mantani. All rights reserved.
//

import UIKit

protocol Convalidator{
    func showNextItem(index : Int, items : [NSObject])
    func outOfIndex(index : Int, items : [NSObject])-> Bool
}
