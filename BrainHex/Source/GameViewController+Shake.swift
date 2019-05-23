//
//  GameViewController+Shake.swift
//  BrainHex
//
//  Created by Gaurav on 05/08/16.
//  Copyright © 2016 Gaurav Keshre. All rights reserved.
//

import Foundation
import UIKit
extension GameViewController{
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        self.handleRefreshButton(event)
    }
}
