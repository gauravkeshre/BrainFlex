//
//  FlipTestViewController.swift
//  BrainHex
//
//  Created by Gaurav on 04/08/16.
//  Copyright © 2016 Gaurav Keshre. All rights reserved.
//

import UIKit

class FlipTestViewController: UIViewController {
    @IBOutlet weak var fView: UIView!
    @IBOutlet var fImageBack: UIImageView!
    @IBOutlet var fImageViewFront: UIImageView!
    //MARK:- IBAction methods
    
    @IBAction func handleFlipButton(sender: AnyObject) {
                UIView.transitionFromView(self.fImageBack, toView: self.fImageViewFront, duration: 2, options: [.Repeat, .TransitionFlipFromRight, .ShowHideTransitionViews, .TransitionFlipFromRight], completion: nil)
        
//        self.justFlip()
        //
        //        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        //        rotateAnimation.repeatCount = 15
        //        rotateAnimation.fromValue = 0.0
        //        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        //        rotateAnimation.duration = 1
        //        self.fView.layer.addAnimation(rotateAnimation, forKey: "basic")
    }
    
    @IBAction func handleStopButton(sender: AnyObject) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = 1
        
        self.fView.layer.addAnimation(rotateAnimation, forKey: nil)
    }
    
    //MARK:- conv methods
    func justFlip() {
        let transitionOptions: UIViewAnimationOptions = [.TransitionFlipFromRight, .ShowHideTransitionViews]
        
//        UIView.transitionWithView(self.fImageBack, duration: 1.0, options: transitionOptions, animations: {
//            self.fImageBack.hidden = true
//            }, completion: nil)
        
        UIView.transitionWithView(self.fImageViewFront, duration: 1.0, options: transitionOptions, animations: {
            self.fImageViewFront.hidden = true
            }, completion: nil)
    }
}
