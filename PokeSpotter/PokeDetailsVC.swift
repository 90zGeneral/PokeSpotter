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
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokemonIDLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var currentEvolutionImg: UIImageView!
    @IBOutlet weak var nextEvolutionImg: UIImageView!
    @IBOutlet weak var evolutionLbl: UILabel!
    @IBOutlet weak var nowLbl: UILabel!
    @IBOutlet weak var laterLbl: UILabel!
    @IBOutlet weak var evolStackView: UIStackView!
    
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
            pokemonIDLbl.text = "\(pokemon.pokemonId)"

            let img = UIImage(named: "\(pokemon.pokemonId)")
            mainImg.image = img
            
            //To make API network call
            pokemon.downloadPokemonDetails {
                
                //Update UI
                self.updateUI()
            }
            
        }else {
            pokeName.text = pokemonAnn.pokemonName.capitalized
            pokemonIDLbl.text = "\(pokemonAnn.pokemonID)"
            
            let img = UIImage(named: "\(pokemonAnn.pokemonID)")
            mainImg.image = img
            
            //To make API network call
            pokemon.downloadPokemonDetails {
                
                //Update UI
                self.updateUI()
            }
        }
        
    }
    
    //Update the UI
    func updateUI() {
        weightLbl.text = pokemon.weight
        heightLbl.text = pokemon.height
        baseAttackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        
        if pokemon.evolutionID == "" {
            evolutionLbl.text = "NO POKEMON EVOLUTION"
            evolutionLbl.textColor = UIColor.black
            nextEvolutionImg.isHidden = true
            laterLbl.isHidden = true
            evolStackView.isHidden = true
            
        }else {
            evolStackView.isHidden = false
            nowLbl.isHidden = false
            laterLbl.isHidden = false
            currentEvolutionImg.isHidden = false
            currentEvolutionImg.image = UIImage(named: "\(pokemon.pokemonId)")
            nextEvolutionImg.isHidden = false
            nextEvolutionImg.image = UIImage(named: pokemon.evolutionID)
            evolutionLbl.text = "Next Evolution: \(pokemon.evolutionName) - LVL: \(pokemon.evolutionLvl)"
        }
    }

    
    //To go back to the mainVC
    @IBAction func goBack(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }

}
