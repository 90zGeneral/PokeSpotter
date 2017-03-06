//
//  PokeDetailsVC.swift
//  PokeSpotter
//
//  Created by Roydon Jeffrey on 3/6/17.
//  Copyright © 2017 Italyte. All rights reserved.
//

import UIKit

class PokeDetailsVC: UIViewController {

    @IBOutlet weak var myString: UILabel!
    
    private var _stringy: String!
    
    var stringy: String {
        get {
            return _stringy
        }set {
            _stringy = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myString.text = stringy

    }

}
