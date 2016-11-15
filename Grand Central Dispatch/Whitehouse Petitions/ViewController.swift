//
//  ViewController.swift
//  Whitehouse Petitions
//
//  Created by Bryan Alexander on 11/14/16.
//  Copyright © 2016 Sarva. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
        
    }
    
    func fetchJSON() {
    
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            
        } else {
            
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        
        // DispatchQueue.global(qos: .userInitiated).async {  // 1st GSC - moves the download to another thread the .userInitiated queue
        //   [unowned self] in
            
            if let url = URL(string: urlString) {
                
                if let data = try? Data(contentsOf: url) {
                    
                    let json = JSON(data: data)
                    
                    if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                        
                        self.parse(json: json)
                        return              // instead of putting in many else statements simply have a return here if successful and show error if not
                        
                    }
                }
            }
         
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
            
    }
    
    
    func parse(json: JSON) {
        
        for result in json["results"].arrayValue {
            
            let title = result["title"].stringValue
            let body = result["body"].stringValue
            let sigs = result["signatureCount"].stringValue
            let obj = ["title": title, "body": body, "sigs": sigs]
            petitions.append(obj)
            
        }
        
//        DispatchQueue.main.async {                            // made code better and worse so replaced by below
//        
//            [unowned self] in self.tableView.reloadData()
//            
//        }
        
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return petitions.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition["title"]
        cell.detailTextLabel?.text = petition["body"]
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func showError() {
        
//        DispatchQueue.main.async {                                // first GCS code - better below
//            
//            [unowned self] in
//            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            self.present(ac, animated: true)
//            
//        }
        
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

