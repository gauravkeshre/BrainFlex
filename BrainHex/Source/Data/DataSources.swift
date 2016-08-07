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
        var imageArray = [GameImage]()
        for i in 0...GameConstants.MatrixSize - 1  {
            let img = GameImage(pathOrName: "\(i)", isLocal: true, uuid: NSUUID().UUIDString)
            imageArray.append(img)
        }
        block?(status: true, result: imageArray)
        
    }
}


class OnlineDataSource: DataSourceProtocol{
    
    let fileSync = FileSyncVC()
    func fetchPhotos(tags: [String], onCompletion block: CompletionCallback?) {
        //TODO: - 
        // 1. Fetch the data from Flikr
        // 2. get an array of 9 images
        // 3a. Start 9 NSOperations in a queue OR dispatch_async
        // 3b. save the images to document directory with names 0...8
        // once done, call the completion block with an array of local names / paths
        
        self.fetchImagesFromFlickr { (status, result) in
//            guard status, let resultArray = result else{
//                print("error")
//                block?(status: false, result: [GameImage]())
//                return
//            }
//            let arr9 = Array(resultArray[0..<GameConstants.MatrixSize])
//            self.fileSync.startFileDownload(from: arr9, withCompletion: { (status, result) in
//                print("all files stored in : \(result)")
//                
//                for str in arr9{
//                    let img = GameImage(pathOrName: str, isLocal: false, uuid: NSUUID().UUIDString)
//                }
//            })
//            
//            
            
        }
        
        
        
        
    }
    
    func fetchImagesFromFlickr(onCompletion: APICompletionCallback){
        //        let string = "https://api.flickr.com/services/feeds/photos_public.gne?lang=en-us&tagmode=all&format=json&tags=sun&nojsoncallback=1"
        let string = "http://www.json-generator.com/api/json/get/bQeQvTNqTC"
        
        //        let string = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&lang=en-us&nojsoncallback=1&tags=dog"
        guard let url =  NSURL(string: string) else{
            onCompletion(status: false, result: nil)
            return;
        }
        
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, err) in
            print(err)
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                print("json")
                guard let items = json?["items"] as? [[String: AnyObject]] else{
                    onCompletion(status: false, result: nil)
                    return
                }
                
                let arr = items.flatMap({$0["media"]?["m"] as? String})
                onCompletion(status: true, result: arr)
            }catch {
                print("exception: ")
            }
            }.resume()
    }
    
}