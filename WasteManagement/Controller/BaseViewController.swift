//
//  BaseViewController.swift
//  WasteManagement
//
//  Created by Arjun on 03/07/20.
//  Copyright © 2020 Arjun. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet weak var imageviewItem: UIImageView!
    @IBOutlet weak var imageviewPlasticWaste: UIImageView!
    @IBOutlet weak var imageviewEWaste: UIImageView!
    @IBOutlet weak var imageviewBioWaste: UIImageView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var lifelineLabel: UILabel!
    
    var counterString = 0
    var centerLocation: CGPoint!
    var wasteData = [Waste]()
    var index = 0
    var currentWaste: Waste!
    private var score = 0
    private var lifeLine = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Playground"
        centerLocation = self.view.frame.origin
        if let wastes = WasteListManager.shared.wastes{
            wasteData = wastes
        } else {
            print("Error")
        }
        for item in wasteData {
            print("Name : \(item.name) : Category : \(item.wasteCategory)")
        }
        setBackgroundImage()
        setUpForNextItem()
        // Do any additional setup after loading the view.
    }
    
    func addGifFile() {
        //        imageviewItem.tintColor = .clear
        //        guard let bundleURL = Bundle.main.url(forResource: "badshot", withExtension: "gif") else {return}
        //        do {
        //            let data = try Data(contentsOf: bundleURL)
        //            imageviewItem.image = UIImage.gifImageWithData(data)
        //        } catch {
        //            print(error.localizedDescription)
        //        }
        
    }
    
    func setBackgroundImage() {
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "bg2")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    func setUpForNextItem() {
        counterLabel.isHidden = false
        self.readyForNextItem { () -> () in
            self.counterString = 1
            self.updateItem()
            self.counterLabel.isHidden = true
        }
    }
    
    func updateItem() {
        if index < wasteData.count {
            currentWaste = wasteData[index]
            addItemLabel()
            index = index + 1
        } else {
            //Game over handling
            showAlert(msg: "Well Done!! Your Score is \(score)")
        }
    }
    
    func addItemLabel() {
        let label = PaddingLabel()
        label.font = UIFont(name: "System-Bold", size: 14)
        label.textAlignment = .center
        label.layer.borderWidth = 2.0
        label.layer.cornerRadius = 8
        label.backgroundColor = UIColor.yellow
        label.layer.masksToBounds = true
        label.text = currentWaste.name
        label.isUserInteractionEnabled = true
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        gesture.minimumNumberOfTouches = 1
        gesture.cancelsTouchesInView = true
        gesture.delaysTouchesEnded = true
        label.addGestureRecognizer(gesture)
        label.alpha = 0
        animateLableText(label)
    }
    
    func animateLableText(_ lab: UILabel) {
        UIView.animate(withDuration: 2) {
            lab.alpha = 1.0
        }
    }
    
    func readyForNextItem(handleComplete: @escaping (()->())) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            if let self = self {
                self.counterString = self.counterString + 1
                DispatchQueue.main.async {
                    self.counterAnimate()
                }
                if self.counterString == 4 {
                    timer.invalidate()
                    handleComplete()
                }
            }
        }
    }
    
    
    func counterAnimate() {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.counterLabel.transform = .init(scaleX: 1.50, y: 1.50)
        }) { (finished: Bool) -> Void in
            self.counterLabel.text = String (self.counterString)
            UIView.animate(withDuration: 0.35, animations: { () -> Void in
                self.counterLabel.transform = .identity
            })
        }
    }
    
    func shakeImageView(image: UIImageView) {
        let midX = image.center.x
        let midY = image.center.y
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: midX - 10, y: midY)
        animation.toValue = CGPoint(x: midX + 10, y: midY)
        image.layer.add(animation, forKey: "position")
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        // 1
        let translation = gesture.translation(in: view)
        
        // 2
        guard let gestureView = gesture.view else {
            return
        }
        if gesture.state == .began {
            print("in begin")
            centerLocation = gestureView.frame.origin
        }else if gesture.state == .ended {
            print("in end")
            gestureView.frame.origin = centerLocation
        }else if gesture.state == .changed {
            
            func dumpInBinSuccessfully(bin: UIImageView) {
                gestureView.removeFromSuperview()
                shakeImageView(image: bin)
                setUpForNextItem()
            }
            
            func goodJob() {
                print("GOOD JOB : Your score now is \(score)")
                self.showToast(message: "GOOD JOB", color: UIColor.init(red: 51/255, green: 98/255, blue: 52/255, alpha: 1))
                scoreLabel.text = String (score)
            }
            
            func badJob() {
                print("BAD SHOT")
                self.showToast(message: "BAD SHOT", color: .red)
                if lifeLine == 0 {
                    //Show alert
                    lifelineLabel.text = String (lifeLine)
                    showAlert(msg: "Play Again!! Your Score is \(score)")
                }else {
                    lifelineLabel.text = String (lifeLine)
                }
            }
            
            if gestureView.frame.intersects(imageviewPlasticWaste.frame)
            {
                if currentWaste.wasteCategory == "plasticWaste" {
                    //Correct score
                    score = score + 1
                    goodJob()
                } else{
                    //wrong score
                    lifeLine = lifeLine - 1
                    badJob()
                }
                dumpInBinSuccessfully(bin: imageviewPlasticWaste)
            } else if gestureView.frame.intersects(imageviewBioWaste.frame) {
                if currentWaste.wasteCategory == "bioWaste" {
                    //Correct score
                    score = score + 1
                    goodJob()
                } else{
                    //wrong score
                    lifeLine = lifeLine - 1
                    badJob()
                }
                dumpInBinSuccessfully(bin: imageviewBioWaste)
            } else if gestureView.frame.intersects(imageviewEWaste.frame) {
                if currentWaste.wasteCategory == "eWaste" {
                    //Correct score
                    score = score + 1
                    goodJob()
                } else{
                    //wrong score
                    lifeLine = lifeLine - 1
                    badJob()
                }
                dumpInBinSuccessfully(bin: imageviewEWaste)
            }
        }
        
        gestureView.center = CGPoint(
            x: gestureView.center.x + translation.x,
            y: gestureView.center.y + translation.y
        )
        
        // 3
        gesture.setTranslation(.zero, in: view)
    }
    
    func showAlert(msg: String) {
        let alert = UIAlertController(title: "GAME OVER", message: msg, preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.performSegue(withIdentifier: "backToHomeScreen", sender: self)
        }
        // Add the actions
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UIViewController {
    
    func showToast(message : String, color: UIColor) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = color.withAlphaComponent(1)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}


