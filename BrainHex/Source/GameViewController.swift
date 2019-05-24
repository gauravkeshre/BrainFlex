//
//  GameViewController.swift
//  BrainHex
//
//  Created by Manisha Utwal on 04/05/19.
//  Copyright © 2016 Manisha Utwal. All rights reserved.
//

import UIKit
import SVProgressHUD

enum GameMode{
    case observing
    case guessing
    case ended
}

class GameViewController: UIViewController {
    
    //MARK:- Outletss
    @IBOutlet weak var lblTimer     : UILabel!
    @IBOutlet weak var btnReplay    : UIButton!
    @IBOutlet weak var imgHint      : UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var bottomBarHeightConstraint: NSLayoutConstraint! /// need to be strong 💪🏼
    
    
    /// Our Data source
    var imageArray   =  [GameImage]()
    
    
    fileprivate var timer: Timer?
    
    /// Number of ticks
    fileprivate var numberOfTicks: TimeInterval = 0
    
    /// The randomly picked image info
    var randomImage: GameImage!
    
    //MARK:- Property Obervers methods
    /// Keep track of all the guessed indexPaths
    
    var guessedIPs   =  [IndexPath](){
        didSet{
            if self.imageArray.count > 0 && self.guessedIPs.count == imageArray.count{
                self.gameMode = .ended
            }
        }
    }
    
    
    var gameMode: GameMode = .observing{
        didSet{
            /// Some UI Updates whenever the game mode changes
            self.btnReplay?.isHidden = (self.gameMode != .ended)
            self.lblTimer?.isHidden = (self.gameMode != .observing)
            self.imgHint?.isHidden = (self.gameMode != .guessing)
            
            switch self.gameMode {
                
            /// Observing the images. I have 15 seconds. The timer is picking and the timer label is updating with count down
            case .observing:
                fallthrough
            case .ended:
                bottomBarHeightConstraint.isActive = true /// Hide the hint image
                self.imgHint.image = nil
                self.guessedIPs.removeAll()
                self.randomImage = nil
                self.openAllTiles()
                
            /// The tiles are closed. A hint image is present in the bottom
            case .guessing:
                
                self.closeAllTiles()
                
                self.pickAndPrepareRandomPicture()
                
                /// Load the image accordingly
                self.imgHint.loadImageWithNameorPath(self.randomImage.pathOrName, formLocal: self.randomImage.isLocal)
                bottomBarHeightConstraint.isActive = false
                
            }
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutSubviews()
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleRefreshButton(nil)
        
    }
    
    //MARK:- IBAction methods
    @IBAction func handleRefreshButton(_ sender: AnyObject?) {
        
        SVProgressHUD.show(withStatus: "Fetching New Images...")
        self.imageArray.removeAll()
        self.guessedIPs.removeAll()
        
        ActiveDataSource().fetchPhotos(["dog", "planes"]) { (status, result) in
            
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                if status{
                    self.imageArray.append(contentsOf: result)
                    self.collectionView.reloadData()
                    
                    self.lblTimer?.text = "\(Int(GameConstants.ObservationTime))"
                    self.numberOfTicks = 0
                    self.gameMode = .observing
                    
                    self.startTimer()
                }
            })
        }
    }
    
    //MARK:- Conv methods
    
    fileprivate func pickAndPrepareRandomPicture(){
        ///Pick a random image
        let randomNum = Int( arc4random_uniform(UInt32(self.imageArray.count)))
        
        //            arc4random_uniform(self.imageArray.count)
        print("Random Index = \(randomNum)")
        self.randomImage = self.imageArray[randomNum]
        
    }
}


//MARK:- Timer methods
extension GameViewController{
    
    fileprivate func startTimer(){
        guard self.timer == nil else{
            return // timer is running
        }
        timer = Timer(timeInterval: 1,
                        target: self,
                        selector: #selector(GameViewController.timerTick(_:)),
                        userInfo: nil, repeats: true)
        
        RunLoop.current.add(timer!, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    fileprivate func stopTimer(){
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func timerTick(_ timer: Timer){
        guard numberOfTicks < GameConstants.ObservationTime - 1 else{
            self.stopTimer()
            self.gameMode = .guessing
            return
        }
        self.numberOfTicks += 1
        self.lblTimer?.text = "\(Int(GameConstants.ObservationTime - self.numberOfTicks))"
    }
}
