//
//  GameViewController+Cosmetic.swift
//  BrainHex
//
//  Created by Gaurav on 05/08/16.
//  Copyright © 2016 Gaurav Keshre. All rights reserved.
//

import Foundation
import UIKit

//MARK:- UICollectionView methods
extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    //MARK: UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameTileCell", for: indexPath) as! GameTileCell
        
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let gtCell = cell as? GameTileCell{
            gtCell.setData(self.imageArray[indexPath.row], info: .open)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard !guessedIPs.contains(indexPath) else{
            return false
        }
        
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? GameTileCell else{
            return false // let it go
        }
        ///Allow flip only on closed cells
        return (cell.state == .closed)
    }
    
    //MARK: UICollectionViewDelegate methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? GameTileCell else{
            return // let it go
        }
        
        ///Close All
        self.closeAllTiles()
        ///Flip Our guy
        cell.flipCardTo(.open);
        
        ///Check if win
        
        if self.randomImage.uuid == cell.gameData.uuid{
            print("WIN !!")
            
            let score = GameConstants.MatrixSize - self.guessedIPs.count
            let alert = UIAlertController(title: "Congratulations! You Won 🎉", message: "Yes this is the right match. Your score is \(score) Points", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Play again 💙", style: .default, handler: { (action) in
                
                self.handleRefreshButton(action)
            })
            alert.addAction(action)
            
            self.present(alert, animated: true, completion:nil)
            self.gameMode = .ended
        }
        
        
        self.guessedIPs.append(indexPath)
    }
    
    
    //MARK:- Convenience methods
    internal func closeAllTiles(){
        for cellInLoop in self.collectionView.visibleCells as! [GameTileCell] {
            cellInLoop.flipCardTo(.closed)
        }
    }
    internal func openAllTiles(){
        for cellInLoop in self.collectionView.visibleCells as! [GameTileCell] {
            cellInLoop.flipCardTo(.open)
        }
    }
    
}



//MARK:- GameCellDelegate methods
extension GameViewController: GameTileCellDelegate{
    func gameCell(_ cell: GameTileCell, willToggleStateTo state: GameTileState){
        
    }
    
    func gameCellBeginFlipAnimation(_ cell: GameTileCell){
        self.collectionView.isUserInteractionEnabled = false
    }
    
    func gameCellEndFlipAnimation(_ cell: GameTileCell){
        self.collectionView.isUserInteractionEnabled = true
    }
    
}
