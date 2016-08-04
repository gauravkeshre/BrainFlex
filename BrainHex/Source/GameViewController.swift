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



extension GameViewController: UICollectionViewDataSource{
    
    //MARK:- UICollectionViewDataSource methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.imageArray.count
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GameTileCell", forIndexPath: indexPath) as! GameTileCell
        cell.setData(self.imageArray[indexPath.row], info: .open)
        return cell
    }
    
}