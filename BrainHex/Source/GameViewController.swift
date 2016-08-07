//
//  GameViewController.swift
//  BrainHex
//
//  Created by Gaurav on 04/08/16.
//  Copyright © 2016 Gaurav Keshre. All rights reserved.
//

import UIKit
import MBProgressHUD
enum GameMode{
    case observing
    case guessing
    case ended
}

class GameViewController: UIViewController {
    
    
    @IBOutlet weak var lblTimer     : UILabel!
    @IBOutlet weak var btnReplay    : UIButton!
    @IBOutlet weak var imgHint      : UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var bottomBarHeightConstraint: NSLayoutConstraint! /// need to be strong 💪🏼
    
    
    private var timer: NSTimer?
    var numberOfTicks: NSTimeInterval = 0
    var randomImage: GameImage!
    var imageArray   =  [GameImage]()
    
    var guessedIPs   =  [NSIndexPath](){
        didSet{
            if self.imageArray.count > 0 && self.guessedIPs.count == imageArray.count{
                self.gameMode = .ended
            }
        }
    }
    
    var gameMode: GameMode = .observing{
        didSet{
            self.btnReplay?.hidden = (self.gameMode != .ended)
            self.lblTimer?.hidden = (self.gameMode != .observing)
            self.imgHint?.hidden = (self.gameMode != .guessing)
            switch self.gameMode {
            case .observing:
                bottomBarHeightConstraint.active = true
            case .guessing:
                let randomNum = random() % self.imageArray.count
                print("Random Index = \(randomNum)")
                self.randomImage = self.imageArray[randomNum]
                self.imgHint.image = UIImage(named: self.randomImage.pathOrName)
                bottomBarHeightConstraint.active = false
            case .ended:
                bottomBarHeightConstraint.active = true
            }
            UIView.animateWithDuration(0.3, animations: {
                self.view.layoutSubviews()
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleRefreshButton(nil)
        
    }
    
    //MARK:- IBAction methods
    @IBAction func handleRefreshButton(sender: AnyObject?) {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.backgroundColor = UIColor.blackColor()
        self.imageArray.removeAll()
        self.guessedIPs.removeAll()
        ActiveDataSource().fetchPhotos(["dog", "planes"]) { (status, result) in
            hud.hideAnimated(true)
            if status{
                self.startTimer()
                self.imageArray.appendContentsOf(result)
                self.collectionView.reloadData()
                self.lblTimer?.text = "\(Int(GameConstants.ObservationTime))"
                self.numberOfTicks = 0
                self.openAllTiles()
                self.gameMode = .observing
                self.startTimer()
            }
        }
    }
}


//MARK:- Timer methods
extension GameViewController{
    
    private func startTimer(){
        guard self.timer == nil else{
            return // timer is running
        }
        timer = NSTimer(timeInterval: 1,
                        target: self,
                        selector: #selector(GameViewController.timerTick(_:)),
                        userInfo: nil, repeats: true)
        
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSDefaultRunLoopMode)
    }
    
    private func stopTimer(){
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func timerTick(timer: NSTimer){
        guard numberOfTicks < GameConstants.ObservationTime - 1 else{
            self.stopTimer()
            self.closeAllTiles()
            self.gameMode = .guessing
            return
        }
        self.numberOfTicks += 1
        self.lblTimer?.text = "\(Int(GameConstants.ObservationTime - self.numberOfTicks))"
    }
}