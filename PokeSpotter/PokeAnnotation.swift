//
//  PokeAnnotation.swift
//  PokeSpotter
//
//  Created by Roydon Jeffrey on 2/15/17.
//  Copyright © 2017 Italyte. All rights reserved.
//

import Foundation
import MapKit


class PokeAnnotation: NSObject, MKAnnotation {
    public var coordinate = CLLocationCoordinate2D()
    var pokemonID: Int  //This cannot be optional. It must only hold an integer.
    var pokemonName: String
    var title: String?
    var pokeDetailsVC = PokeDetailsVC()
    
    init(coordinate: CLLocationCoordinate2D, pokemonID: Int) {
        self.coordinate = coordinate
        self.pokemonID = pokemonID
        let pokemonNow = pokemons[pokemonID - 1]
        self.pokemonName = pokemonNow.name.capitalized
        self.title = self.pokemonName
        
        pokeDetailsVC.pokemon = pokemonNow
    }
}
