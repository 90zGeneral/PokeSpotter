//
//  PokeCell.swift
//  PokeFacts
//
//  Created by Roydon Jeffrey on 1/12/17.
//  Copyright © 2017 Italyte. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var pokeImg: UIImageView!
    @IBOutlet weak var pokeLbl: UILabel!
    
    //Make the cells have rounded corners
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //Apply corner radius to the layer of the cells
        layer.cornerRadius = 9.0
    }
    
    //To configure each cell
    func configureCell(_ pokemon: Pokemon) {
        
        //Update the views in each cell
        pokeLbl.text = pokemon.name.capitalized
        pokeImg.image = UIImage(named: "\(pokemon.pokemonId)")
    }
    
}
