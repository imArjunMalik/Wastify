//
//  HomeViewController.swift
//  WasteManagement
//
//  Created by Arjun on 07/07/20.
//  Copyright © 2020 Arjun. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var customButton = CustomButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        setBackgroundImage()
    }
    
    func setBackgroundImage() {
           UIGraphicsBeginImageContext(self.view.frame.size)
           UIImage(named: "bg4")?.draw(in: self.view.bounds)
           let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
           UIGraphicsEndImageContext()
           self.view.backgroundColor = UIColor(patternImage: image)
       }
    
    @IBAction func startTapped() {
        performSegue(withIdentifier: "startWasteManagement", sender: self)
    }
    
    @IBAction func learnTapped() {
        performSegue(withIdentifier: "learnIdentifier", sender: self)
    }
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        if segue.identifier == "backToHomeScreen" {
            
        }
    }
}
