//
//  StatsViewController.swift
//  AthenaHacks
//
//  Created by Vinnie Chen on 2/25/18.
//  Copyright © 2018 Vinnie Chen. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    
    var speechText: String?
    var qualifiers : [String] = []
    var qualifierCount: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignQualifiers()
        checkQualifiers()
    }
    
    func assignQualifiers() {
        qualifiers.append("just")
        qualifiers.append("I think")
        
    }
    
    func checkQualifiers() {
        for phrase in qualifiers {
            if speechText!.contains(phrase) {
                print("contains \(phrase)")
            }
        }
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
