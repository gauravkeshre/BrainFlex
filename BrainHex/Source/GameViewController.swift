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
    var imageArray =  [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...8{
            imageArray.append("\(i)")
        }
        self.collectionView.reloadData()
    }
    
    //MARK:- IBBAction methods
    @IBAction func handleRefreshButton(sender: AnyObject) {
        for cell in self.collectionView.visibleCells() as! [GameTileCell] {
            if cell.state == .open{
                cell.flipCardTo(.closed)
            }else{
                cell.flipCardTo(.open)
            }
        }
    }
}



extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    //MARK:- UICollectionViewDataSource methods
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
    
    //MARK:- UICollectionViewDelegate methods
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        guard let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as? GameTileCell else{
            return // let it go
        }
        
        ///Close All
        for cellInLoop in self.collectionView.visibleCells() as! [GameTileCell] {
            cellInLoop.flipCardTo(.closed)
        }
        
        ///Flip Our guy
        cell.flipCardTo(.open);
        
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