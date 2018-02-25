//
//  StatsViewController.swift
//  AthenaHacks
//
//  Created by Vinnie Chen on 2/25/18.
//  Copyright © 2018 Vinnie Chen. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var speechText: String?

    var qualifierCount: [String : Int] = [:]
    var strings: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        checkQualifiers()
        addToHistory()
 
    }
    
    func checkQualifiers() {
        for phrase in Qualifiers.words.keys {
            if speechText!.contains(phrase) {
                
                print("contains \(phrase)")
                if let count = qualifierCount[phrase] {
                    qualifierCount.updateValue(count+1, forKey: phrase)
                    print("\(phrase): \(count)")
                } else {
                    qualifierCount[phrase] = 1
                }
            }
        }
        // convert it to a string to be able to display in textView
        for stats in qualifierCount {
            strings.append("\(stats.key): \(stats.value)")
        }
        
        self.tableView.reloadData()
    }
    
    func addToHistory() {
        for phrase in qualifierCount.keys {
            Qualifiers.words[phrase] = Qualifiers.words[phrase]! + qualifierCount[phrase]!
        }
        print(Qualifiers.words)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return qualifierCount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatsCell", for: indexPath) as! StatsCell
        
        let phrase = strings[indexPath.row]

        cell.statsLabel.text = phrase
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(40)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true) {}
    }
    

}
