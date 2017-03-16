//
//  PokeDetailsVC.swift
//  PokeSpotter
//
//  Created by Roydon Jeffrey on 3/6/17.
//  Copyright © 2017 Italyte. All rights reserved.
//

import UIKit

class PokeDetailsVC: UIViewController {

    //Outlets
    @IBOutlet weak var pokeName: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    
    //Variables of type PokeAnnotation and Pokemon
    var pokemonAnn: PokeAnnotation!
    var pokemon: Pokemon!
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Check where the segue is coming from
        if pokemon != nil {
        //Assignment
        pokeName.text = pokemon.name.capitalized

        let img = UIImage(named: "\(pokemon.pokemonId)")
        mainImg.image = img
            
        }else {
            pokeName.text = pokemonAnn.pokemonName.uppercased()
            
            let img = UIImage(named: "\(pokemonAnn.pokemonID)")
            mainImg.image = img
        }
        
    }
    
    //To go back to the mainVC
    @IBAction func goBack(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }

}
