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
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        checkQualifiers()
 
    }
    
    func checkQualifiers() {
        for phrase in Qualifiers.words {
            if speechText!.contains(phrase) {
                let s = speechText
                let tok =  s!.components(separatedBy:phrase)
                print("contains \(phrase)")
                qualifierCount[phrase] = tok.count-1
            }
        }
        for stats in qualifierCount {
            strings.append("\(stats.key): \(stats.value)")
        }
        
        self.tableView.reloadData()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
