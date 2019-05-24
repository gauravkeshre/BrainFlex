//
//  Protocols.swift
//  BrainHex
//
//  Created by Manisha Utwal on 04/05/19.
//  Copyright © 2016 Manisha Utwal. All rights reserved.
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
