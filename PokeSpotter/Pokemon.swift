//
//  Pokemon.swift
//  PokeSpotter
//
//  Created by Roydon Jeffrey on 2/23/17.
//  Copyright © 2017 Italyte. All rights reserved.
//

import Foundation
import Alamofire


class Pokemon {
    
    //Private properties
    fileprivate var _name: String!
    fileprivate var _pokemonId: Int!
    fileprivate var _description: String!
    fileprivate var _type: String!
    fileprivate var _defense: String!
    fileprivate var _height: String!
    fileprivate var _weight: String!
    fileprivate var _attack: String!
    fileprivate var _evolution: String!
    fileprivate var _evolutionName: String!
    fileprivate var _evolutionID: String!
    fileprivate var _evolutionLvl: String!
    fileprivate var _pokemonURL: String!
    var title: String?
    
    
    //Getters
    var name: String {
        if _name == nil {
            _name = ""
        }
        
        return _name
    }
    
    var pokemonId: Int {
        if _pokemonId == nil {
            _pokemonId = 0
        }
        
        return _pokemonId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        
        return _attack
    }
    
    var evolution: String {
        if _evolution == nil {
            _evolution = ""
        }
        
        return _evolution
    }
    
    var evolutionName: String {
        if _evolutionName == nil {
            _evolutionName = ""
        }
        
        return _evolutionName
    }
    
    var evolutionID: String {
        if _evolutionID == nil {
            _evolutionID = ""
        }
        
        return _evolutionID
    }
    
    var evolutionLvl: String {
        if _evolutionLvl == nil {
            _evolutionLvl = ""
        }
        
        return _evolutionLvl
    }
    
    var pokemonURL: String {
        if _pokemonURL == nil {
            _pokemonURL = ""
        }
        
        return _pokemonURL
    }
    
    //Initializer
    init(name: String, pokemonId: Int) {
        self._name = name
        self._pokemonId = pokemonId
        self.title = self._name
        
        
        //API URL based on the pokemon's ID number
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokemonId)"
    }
    
    //To make the network call to the api
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        
        //GET request to the pokemonURL
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            //To store the json object being returned
            if let dict = response.result.value! as? [String: Any] {
                
                //To get the weight of the pokemon
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                //To get the height of the pokemon
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                //To get the attack of the pokemon
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                //To get the weight of the pokemon
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                //To get the type of the pokemon
                if let typesArr = dict["types"] as? [[String: Any]] {
                    var type = ""
                    
                    //Loop over the array
                    for obj in typesArr {
                        if let name = obj["name"] as? String {
                            type += name + "/"
                        }
                    }
                    
                    //To remove the forward slash from the end of the string
                    if type.characters.last == "/" {
                        type.remove(at: type.index(before: type.endIndex))
                    }
                    
                    self._type = type.capitalized
                }
                
                //To get the description of the pokemon
                if let descArr = dict["descriptions"] as? [[String: Any]] {
                    if let descURL = descArr[0]["resource_uri"] as? String {
                        
                        //Make a full url using the base url and the provided part for the description
                        let fullURL = "\(URL_BASE)\(descURL)"
                        
                        //Second network request
                        Alamofire.request(fullURL).responseJSON(completionHandler: { (response) in
                            if let descDict = response.result.value as? [String: Any] {
                                if let description = descDict["description"] as? String {
                                    
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    
                                    print(newDescription)
                                    self._description = newDescription
                                }
                            }
                            completed()
                        })
                    }
                }
                
                //To get the evolution of the pokemon
                if let evolArr = dict["evolutions"] as? [[String: Any]] , evolArr.count > 0 {
                    if let evolTo = evolArr[0]["to"] as? String {
                        
                        //Exclude all evolutions with mega in its name
                        if evolTo.range(of: "mega") == nil {
                            self._evolutionName = evolTo
                            
                            if let uri = evolArr[0]["resource_uri"] as? String {
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let evoID = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._evolutionID = evoID
                                
                                if let lvlExist = evolArr[0]["level"] as? Int {
                                    self._evolutionLvl = "\(lvlExist)"
                                    
                                }else {
                                    self._evolutionLvl = "NONE"
                                }
                            }
                        }
                    }
                }
                
            }
            //Call the closure to complete
            completed()
        }
    }
}
