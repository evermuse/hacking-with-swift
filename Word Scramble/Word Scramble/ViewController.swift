//
//  ViewController.swift
//  Word Scramble
//
//  Created by Bryan Alexander on 11/12/16.
//  Copyright © 2016 Sarva. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt") {
            
            if let startWords = try? String(contentsOfFile: startWordsPath) {
                
                allWords = startWords.components(separatedBy: "\n")
                
            } else {
                
                allWords = ["silkworm"]
                
            }
        }
        
        startGame()
        
    }
    
    func startGame() {
        
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords) as! [String]
        title = allWords[0]
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usedWords.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
        
    }
    
    func promptForAnswer() {
        
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert) // creates alert popover
        ac.addTextField()                                                       // adds editable text input field to the alert
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {    // trailing closure syntax
            
            [unowned self, ac] (action: UIAlertAction!) in // pg 334 in Hacking with Swift
            
            let answer = ac.textFields![0]
            self.submit(answer: answer.text!)
            
        }
        
        ac.addAction(submitAction)  // adds a UIAlertAction to a UIAlertController
        
        present(ac, animated: true)
    
    }
    
    func submit(answer: String) {
        
        let lowerAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        if isPossible(word: lowerAnswer) {
            
            if isOriginal(word: lowerAnswer) {
                
                if isReal(word: lowerAnswer) {
                    
                    usedWords.insert(answer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                    
                } else {
                    
                    errorTitle = "Word not recognised"
                    errorMessage = "You can't just make words up! ;)"
                    
                }
            
            } else {
                
                errorTitle = "Word used already"
                errorMessage = "You've got to come original!"
                
            }
            
        } else {
            
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from '\(title!.lowercased())'!"
            
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        
    }
    
    func isPossible(word: String) -> Bool {
        
        var tempWord = title!.lowercased()
        
        for letter in word.characters {
            
            if let positive = tempWord.range(of: String(letter)) {
                
                tempWord.remove(at: positive.lowerBound)
                
            } else {
                
                return false
                
            }
            
        }
        
        return true
        
    }
    
    func isOriginal(word: String) -> Bool {
        
        return !usedWords.contains(word)
        
    }
    
    func isReal(word: String) -> Bool {
        
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

