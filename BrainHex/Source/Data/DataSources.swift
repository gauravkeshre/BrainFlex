//
//  OnlineDataSource.swift
//  BrainHex
//
//  Created by Gaurav on 05/08/16.
//  Copyright © 2016 Gaurav Keshre. All rights reserved.
//

import Foundation

class OfflineDataSource: DataSourceProtocol{
    func fetchPhotos(tags: [String], onCompletion block: CompletionCallback?) {
        var imageArray = [String]()
        for i in 0...GameConstants.MatrixSize - 1  {
            imageArray.append("\(i)")
        }
        block?(status: true, result: imageArray)
        
    }
}


class OnlineDataSource: DataSourceProtocol{
    func fetchPhotos(tags: [String], onCompletion block: CompletionCallback?) {
        //TODO: - 
        // 1. Fetch the data from Flikr
        // 2. get an array of 9 images
        // 3a. Start 9 NSOperations in a queue OR dispatch_async
        // 3b. save the images to document directory with names 0...8
        // once done, call the completion block with an array of local names / paths
    }
}