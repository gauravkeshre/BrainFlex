//
//  GameViewController+Shake.swift
//  BrainHex
//
//  Created by Manisha Utwal on 05/05/19.
//  Copyright © 2016 Manisha Utwal. All rights reserved.
//

import Foundation
import UIKit
extension GameViewController{
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        self.handleRefreshButton(event)
    }
}
