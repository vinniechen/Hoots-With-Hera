//
//  HistoryViewController.swift
//  AthenaHacks
//
//  Created by Vinnie Chen on 2/24/18.
//  Copyright © 2018 Vinnie Chen. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var totalCountLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var words : [String] = []
    var counts : [Int] = []
    var totalCount = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        var i = 0
        for phrase in Qualifiers.words {
           words.append(phrase.key)
            counts.append(phrase.value)
            totalCount = totalCount + phrase.value
            totalCountLabel.text = "\(totalCount)"
            i = i + 1;
        }
        
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        
        let phrase = "\(words[indexPath.row]): \(counts[indexPath.row])"
        
        
        cell.phraseLabel.text = phrase
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
