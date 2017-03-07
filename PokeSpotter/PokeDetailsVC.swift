//
//  PokeDetailsVC.swift
//  PokeSpotter
//
//  Created by Roydon Jeffrey on 3/6/17.
//  Copyright © 2017 Italyte. All rights reserved.
//

import UIKit

class PokeDetailsVC: UIViewController {
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myString.text = stringy
        
    }

    //Outlets
    @IBOutlet weak var myString: UILabel!
    
    private var _stringy: String!
    
    //Getter
    var stringy: String {
        get {
            return _stringy
        }set {
            _stringy = newValue
        }
    }
    
    //To go back to the mainVC
    @IBAction func goBack(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }

}
