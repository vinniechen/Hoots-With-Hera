//
//  SettingsViewController.swift
//  AthenaHacks
//
//  Created by Vinnie Chen on 2/24/18.
//  Copyright © 2018 Vinnie Chen. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var myQualifiers: UITextView!
    @IBOutlet weak var addButton: UIButton!
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    @IBOutlet weak var wordField: UITextField!
    let gradientOne = UIColor(red: 108/255, green: 174/255, blue: 234/255, alpha: 1).cgColor
    let gradientTwo = UIColor(red: 255/255, green: 151/255, blue: 145/255, alpha: 1).cgColor
    let gradientThree = UIColor(red: 245/255, green: 193/255, blue: 209/255, alpha: 1).cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

//        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
//        tapGesture.cancelsTouchesInView = true
//        wordField.addGestureRecognizer(tapGesture)


        
        addButton.layer.cornerRadius = addButton.frame.height/2
        addButton.clipsToBounds = true
        // Do any additional setup after loading the view.
        var qual = ""
        for word in Qualifiers.words.keys {
            qual = "\(qual) \(word),"
        }
        
    }
//    func hideKeyboard() {
//        wordField.endEditing(true)
//    }

    override public func viewDidAppear(_ animated: Bool) {
        var qual = ""
        for word in Qualifiers.words.keys {
            qual = "\(qual) \(word),"
        }
        qual.removeFirst()
        qual.removeLast()
        myQualifiers.text = qual
        
        super.viewDidAppear(animated)
        
        gradientSet.append([gradientOne, gradientTwo])
        gradientSet.append([gradientTwo, gradientThree])
        gradientSet.append([gradientThree, gradientOne])
        
        
        gradient.frame = self.view.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
        
        self.view.layer.addSublayer(gradient)
        
        animateGradient()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func animateGradient() {
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
            
        }
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 5.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = kCAFillModeForwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
        
        gradient.zPosition = -0.05
        
    }
    
    @IBAction func addWord(_ sender: Any) {
        let s = wordField.text
        let list =  s!.components(separatedBy:", ")
        for phrase in list {
            Qualifiers.words[phrase] = 0
        }
        
    }
    

    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
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
extension SettingsViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}

