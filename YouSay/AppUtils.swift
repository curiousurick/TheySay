//
//  AppUtils.swift
//  YouSay
//
//  Created by George Urick on 4/25/15.
//  Copyright (c) 2015 GameThrift. All rights reserved.
//

import UIKit

class AppUtils: NSObject {
    
    
    class func showAlert(title: String, message: String) {
        var alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
   
}
