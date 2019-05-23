//
//  GameTileCell.swift
//  BrainHex
//
//  Created by Gaurav on 04/08/16.
//  Copyright © 2016 Gaurav Keshre. All rights reserved.
//

import UIKit

enum GameTileState{
    case open
    case closed
}


class GameTileCell: UICollectionViewCell, DataReceiver {
    
    @IBOutlet var imgCover: UIImageView! ///the backside of each tile
    @IBOutlet var imgContent: UIImageView! /// the image pulled from Flickr
    
    var state : GameTileState = .closed
    weak var delegate: GameTileCellDelegate?
    var gameData: GameImage!
    
    //MARK:- LIfeCycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 2.5 // subtle cleaning up
    }
    
    //MARK:- UI methods
    func flipCardTo(_ state: GameTileState){
        
        guard state != self.state else{
            return // ignore the flip
        }
        self.state = state
        let onCompletion: ((Bool) -> Void)? = { (finished) in
            self.delegate?.gameCellEndFlipAnimation(self)
        }
        
        self.delegate?.gameCellBeginFlipAnimation(self);
        switch state {
        case .open:
            UIView.transition(from: self.imgCover, to: self.imgContent, duration: GameConstants.FlipAnimationDuration, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: onCompletion)
            break
        case .closed:
            UIView.transition(from: self.imgContent, to: self.imgCover, duration: GameConstants.FlipAnimationDuration/2, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: onCompletion)
            
            break
        }
    }
    
    //MARK:- DataReceiver methods
    func setData(_ data: GameImage, info: GameTileState){
        /// set model
        self.gameData = data
        
        /// Set image
        self.imgContent.loadImageWithNameorPath(data.pathOrName, formLocal: data.isLocal)
        
        ///initial setup
        self.state = info
        //        self.flipCardTo(self.state)
        //        return
        if self.state == .open{
            self.contentView.bringSubview(toFront: self.imgContent)
        }else{
            self.contentView.bringSubview(toFront: self.imgCover)
        }
    }
    
}




extension UIImageView{
    func loadImageWithNameorPath(_ nameOrPath: String, formLocal: Bool){
        if let img = UIImage(named: nameOrPath), formLocal{
            self.image = img
        }else{
            let img = UIImage(contentsOfFile:nameOrPath)
            self.image = img
        }
    }
}
