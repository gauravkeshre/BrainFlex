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
    func setData(data: DataType, info: AnotherDataType)
}