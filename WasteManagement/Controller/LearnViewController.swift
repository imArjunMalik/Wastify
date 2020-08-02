//
//  LearnViewController.swift
//  WasteManagement
//
//  Created by Arjun on 09/07/20.
//  Copyright © 2020 Arjun. All rights reserved.
//

import UIKit

class LearnViewController: BaseViewController {
    
    @IBOutlet weak var blueBgView: UIView!
    @IBOutlet weak var greenBgView: UIView!
    @IBOutlet weak var blackBgView: UIView!
    var animateFlag: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Learning Mode"
        blueBgView.isHidden = true
        blackBgView.isHidden = true
        greenBgView.isHidden = true
    }
    
    override  func updateItem() {
        currentWaste = wasteData[index]
        if index < wasteData.count - 1 {
            index = index + 1
        }
        addItemLabel()
        addCategoryBasedView()
    }
    
    func addCategoryBasedView() {
        switch currentWaste.wasteCategory {
        case "eWaste":
            animateFlag = true
            fadeInFadeOutAnimation(view: blackBgView)
        case "plasticWaste":
            animateFlag = true
            fadeInFadeOutAnimation(view: blueBgView)
        case "bioWaste":
            animateFlag = true
            fadeInFadeOutAnimation(view: greenBgView)
        default:
            print("worng category")
        }
    }
    
    func fadeInFadeOutAnimation(view: UIView) {
        view.isHidden = false
        UIView.animate(withDuration: 1.0, animations: {
            view.alpha = 1.0
        }, completion: {
            (Completed: Bool) -> Void in
            UIView.animate(withDuration: 1.0, delay: 1, options: UIView.AnimationOptions.curveLinear, animations: {
                view.alpha = 0
            }, completion: {
                (Completed: Bool) -> Void in
                if self.animateFlag == true {
                    self.fadeInFadeOutAnimation(view: view)
                }
            })
        })
    }
    
    @objc override func handlePan(_ gesture: UIPanGestureRecognizer) {
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
            
            switch currentWaste.wasteCategory {
                
            case "plasticWaste":
                var tempFrame = imageviewPlasticWaste.frame
                tempFrame.size.width = tempFrame.size.width/3
                tempFrame.size.height = tempFrame.size.height/3
                if gestureView.frame.intersects(tempFrame) {
                    print("In intersect plastic waste")
                    gestureView.removeFromSuperview()
                    self.animateFlag = false
                    blueBgView.isHidden = true
                    shakeImageView(image: imageviewPlasticWaste)
                    setUpForNextItem()
                }
                break
            case "bioWaste":
                var tempFrame = imageviewBioWaste.frame
                tempFrame.size.width = tempFrame.size.width/3
                tempFrame.size.height = tempFrame.size.height/3
                if gestureView.frame.intersects(tempFrame) {
                    print("In intersect bioWaste")
                    gestureView.removeFromSuperview()
                    self.animateFlag = false
                    greenBgView.isHidden = true
                    shakeImageView(image: imageviewBioWaste)
                    setUpForNextItem()
                }
                break
            case "eWaste":
                var tempFrame = imageviewEWaste.frame
                tempFrame.size.width = tempFrame.size.width/3
                tempFrame.size.height = tempFrame.size.height/3
                if gestureView.frame.intersects(tempFrame) {
                    print("In intersect eWaste")
                    gestureView.removeFromSuperview()
                    self.animateFlag = false
                    blackBgView.isHidden = true
                    shakeImageView(image: imageviewEWaste)
                    setUpForNextItem()
                }
                break
            default:
                print("No category matched")
            }
            
        }
        
        gestureView.center = CGPoint(
            x: gestureView.center.x + translation.x,
            y: gestureView.center.y + translation.y
        )
        
        // 3
        gesture.setTranslation(.zero, in: view)
    }
    
    
}
