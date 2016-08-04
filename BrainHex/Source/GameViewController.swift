//
//  GameViewController.swift
//  BrainHex
//
//  Created by Gaurav on 04/08/16.
//  Copyright © 2016 Gaurav Keshre. All rights reserved.
//

import UIKit

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
    private var numberOfTicks: NSTimeInterval = 0
    
    private var randomImage: GameImage!
    private var gameMode: GameMode = .observing{
        didSet{
            self.btnReplay?.hidden = (self.gameMode != .ended)
            self.lblTimer?.hidden = (self.gameMode != .observing)
            self.imgHint?.hidden = (self.gameMode != .guessing)
            switch self.gameMode {
            case .observing:
                bottomBarHeightConstraint.active = true
            case .guessing:
                let randomNum = random() % GameConstants.MatrixSize
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
    
    private var imageArray   =  [GameImage]()
    private var guessedIPs   =  [NSIndexPath](){
        didSet{
            if self.imageArray.count > 0 && self.guessedIPs.count == imageArray.count{
                self.gameMode = .ended
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startTimer()
        ActiveDataSource().fetchPhotos(["dog", "planes"]) { (status, result) in
            if status{
                self.imageArray.appendContentsOf(result)
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK:- IBAction methods
    @IBAction func handleRefreshButton(sender: AnyObject) {
        self.lblTimer?.text = "\(Int(GameConstants.ObservationTime))"
        self.numberOfTicks = 0
        self.closeAllTiles()
        self.gameMode = .observing
        self.guessedIPs.removeAll()
        self.startTimer()
    }
}


//MARK:- UICollectionView methods
extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    //MARK: UICollectionViewDataSource methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.imageArray.count    
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GameTileCell", forIndexPath: indexPath) as! GameTileCell
        cell.setData(self.imageArray[indexPath.row], info: .open)
        cell.delegate = self
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        guard !guessedIPs.contains(indexPath) else{
            return false
        }
        
        guard let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as? GameTileCell else{
            return false // let it go
        }
        ///Allow flip only on closed cells
        return (cell.state == .closed)
    }
    
    //MARK: UICollectionViewDelegate methods
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        guard let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as? GameTileCell else{
            return // let it go
        }
        
        ///Close All
        self.closeAllTiles()
        ///Flip Our guy
        cell.flipCardTo(.open);
        
        ///Check if win
        
        if self.randomImage.uuid == cell.gameData.uuid{
            print("WIN !!")
            self.gameMode = .ended
            let score = GameConstants.MatrixSize - self.guessedIPs.count
            let alert = UIAlertController(title: "Congratulations! You Won 🎉", message: "Yes this is the right match. Your score is \(score) Points", preferredStyle: .Alert)
            
            let action = UIAlertAction(title: "Replay", style: .Default, handler: { (action) in
                self.handleRefreshButton(action)
            })
            alert.addAction(action)
            
            self.presentViewController(alert, animated: true, completion:nil)        }
        
        
        self.guessedIPs.append(indexPath)
    }
    
    //MARK:- Convenience methods
    func closeAllTiles(){
        for cellInLoop in self.collectionView.visibleCells() as! [GameTileCell] {
            cellInLoop.flipCardTo(.closed)
        }
    }
    
}


//MARK:- GameCellDelegate methods
extension GameViewController: GameTileCellDelegate{
    func gameCell(cell: GameTileCell, willToggleStateTo state: GameTileState){
        
    }
    
    func gameCellBeginFlipAnimation(cell: GameTileCell){
        self.collectionView.userInteractionEnabled = false
    }
    
    func gameCellEndFlipAnimation(cell: GameTileCell){
        self.collectionView.userInteractionEnabled = true
    }
    
}


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