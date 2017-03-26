//
//  SearchVC.swift
//  PokeFacts
//
//  Created by Roydon Jeffrey on 1/12/17.
//  Copyright © 2017 Italyte. All rights reserved.
//

import UIKit
import AVFoundation

//Global array of Pokemons
var pokemons = [Pokemon]()

class SearchVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Filtered array of Pokemon for the search bar AND the current status of search
    var filteredPokemons = [Pokemon]()
    var inSearchMode = false
    
    //Music player initialized
    var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        
        //Call function
        audioSetup()
        
        //Change the search button text in the keyboard to say "Done"
        searchBar.returnKeyType = UIReturnKeyType.done
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //To prevent duplicate insertions into the array
        if pokemons.count < 1 {
            
            //Call function
            parsePokemonCSV()
            print(pokemons.count)
            
        }else {
            
            print(pokemons.count)
        }
    }
    
    //Set up the audio player
    func audioSetup() {
        
        //Path to the audio file
        let audioPath = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        //Error handling
        do {
            
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: audioPath)!)
            musicPlayer.prepareToPlay()
            
            //Loop the song continuously
            musicPlayer.numberOfLoops = -1
            
            //Begin playing
            musicPlayer.play()
            
        }catch {
            print(error.localizedDescription)
        }
    }
    
    //Parsing the pokemon csv file
    func parsePokemonCSV() {
        
        //Path to the pokemon.csv file
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        //Error handling
        do {
            //New instance of CSV class
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print(rows)
            
            //Loop over the array of dictionaries returned from rows
            for row in rows {
                
                //Grab the name and id of each pokemon in the rows array
                let pokeName = row["identifier"]!
                let pokeId = Int(row["id"]!)!
                let revertId = Int(row["revert_id"]!)!
                
                //Pass the name and id into a new instance of the Pokemon class
                let eachPoke = Pokemon(name: pokeName, pokemonId: pokeId, pokeRevertId: revertId)
                
                //Append each new instance of Pokemon class to the pokemons array
                pokemons.append(eachPoke)
            }
            
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //To determine with array will hold the cell count
        if inSearchMode {
            return filteredPokemons.count
        }else {
            return pokemons.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            let cellPokemon: Pokemon!
            
            //To determine which array will populate the cells
            if inSearchMode {
                cellPokemon = filteredPokemons[indexPath.row]
                cell.configureCell(cellPokemon)
                
            }else {
                cellPokemon = pokemons[indexPath.row]
                cell.configureCell(cellPokemon)
            }
            
            return cell
            
        }else {
            
            return UICollectionViewCell()
        }
    }
    
    //A fixed height and width for each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Segue should perform regardless of search mode state
        var poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemons[indexPath.row]
            
        }else {
            poke = pokemons[indexPath.row]
        }
        
        //Perform the segue based on the selected pokemon
        performSegue(withIdentifier: "PokeCell", sender: poke)
        
    }
    
    //Prepare to make the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PokeDetailsVC {
            if let poke = sender as? Pokemon {
                destination.pokemon = poke
            }
        }
    }
    
    //To pause or play audio
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            
            //To make music button transparent
            sender.alpha = 0.4
            
        }else {
            musicPlayer.play()
            
            //To make music button opaque
            sender.alpha = 1.0
        }
    }
    
    //This method runs each time the search bar text changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //To determine search bar current status AND reload the collection view
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
            
        }else {
            inSearchMode = true
            
            //Convert the search bar text to lowercase letters
            let lower = searchBar.text!.lowercased()
            
            //Assign the pokemons array to the filtered array after it's been filtered with pokemon names containing the search bar text
            filteredPokemons = pokemons.filter({($0.name.range(of: lower) != nil)})
            
            //Reload collection View
            collection.reloadData()
            
        }
        
    }
    
    //Remove keyboard when Done button press
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    //Remove the keyboard when user taps anywhere at the top of the screen where the Title is.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //Remove keyboard when the cancel button is tapped
    @IBAction func cancel(_ sender: UIButton) {
        searchBar.resignFirstResponder()
        
    }
    
    //To go back to the mainVC
    @IBAction func goBackToMap(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

