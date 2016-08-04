//
//  GameTileCell.swift
//  BrainHex
//
//  Created by Gaurav on 04/08/16.
//  Copyright © 2016 Gaurav Keshre. All rights reserved.
//

import UIKit

enum TileState{
    case open
    case closed
}

class GameTileCell: UICollectionViewCell, DataReceiver {
    
    @IBOutlet var imgCover: UIImageView! ///the backside of each tile
    @IBOutlet var imgContent: UIImageView! /// the image pulled from Flickr
    
    var state : TileState = .closed
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    //MARK:- UI methods
    func flipCardTo(state: TileState){
        
        let onCompletion: ((Bool) -> Void)? = { (finished) in
            self.state = state
        }
        
        switch state {
        case .open:
            UIView.transitionFromView(self.imgCover, toView: self.imgContent, duration: 0.5, options: [.TransitionFlipFromRight, .ShowHideTransitionViews], completion: onCompletion)
            break
        case .closed:
            UIView.transitionFromView(self.imgContent, toView: self.imgCover, duration: 0.5, options: [.TransitionFlipFromLeft, .ShowHideTransitionViews], completion: onCompletion)
            
            break
        }
    }
    //MARK:- DataReceiver methods
    
    func setData(data: String, info: TileState){
        /// set url
        self.imgContent.image = UIImage(named: data)!
        
        ///initial setup
        self.state = info
        if self.state == .open{
            self.contentView.bringSubviewToFront(self.imgContent)
        }else{
            self.contentView.bringSubviewToFront(self.imgCover)
        }
        
    }
    
}
