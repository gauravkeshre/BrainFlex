//
//  Protocols.swift
//  BrainHex
//
//  Created by Gaurav on 04/08/16.
//  Copyright © 2016 Gaurav Keshre. All rights reserved.
//

import Foundation

protocol DataReceiver {
    associatedtype DataType
    associatedtype AnotherDataType
    func setData(_ data: DataType, info: AnotherDataType)
}

protocol GameTileCellDelegate: class {
    func gameCell(_ cell: GameTileCell, willToggleStateTo state: GameTileState)
    func gameCellBeginFlipAnimation(_ cell: GameTileCell)
    func gameCellEndFlipAnimation(_ cell: GameTileCell)
}
