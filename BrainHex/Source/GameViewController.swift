//
//  GameViewController.swift
//  BrainHex
//
//  Created by Gaurav on 04/08/16.
//  Copyright © 2016 Gaurav Keshre. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblTimer: UILabel!
    
    private var imageArray =  [String]()
    private var timer: NSTimer?
    private var numberOfTicks: NSTimeInterval = 0
    
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
        
        self.lblTimer?.text = "\(Int(GameConstants.ObservationTime))"
        self.lblTimer?.hidden = false
        timer = NSTimer(timeInterval: 1,
                        target: self,
                        selector: #selector(GameViewController.timerTick(_:)),
                        userInfo: nil, repeats: true)
        
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSDefaultRunLoopMode)
        
        //timer?.fire()
    }
    
    private func stopTimer(){
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func timerTick(timer: NSTimer){
        guard numberOfTicks < GameConstants.ObservationTime else{
            self.stopTimer()
            self.closeAllTiles()
            self.lblTimer?.hidden = true
            return
        }
        self.numberOfTicks += 1
        self.lblTimer?.text = "\(Int(GameConstants.ObservationTime - self.numberOfTicks))"
        
    }
    
    
}