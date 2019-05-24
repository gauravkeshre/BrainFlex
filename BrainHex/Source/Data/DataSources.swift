 //
 //  OnlineDataSource.swift
 //  BrainHex
 //
 //  Created by Manisha Utwal on 05/05/19.
 //  Copyright © 2016 Manisha Utwal. All rights reserved.
 //
 
 import Foundation
 import FlickrKit
 class OfflineDataSource: DataSourceProtocol{
    func fetchPhotos(_ tags: [String], onCompletion block: CompletionCallback?) {
        var imageArray = [GameImage]()
        for i in 0...GameConstants.MatrixSize - 1  {
            let img = GameImage(pathOrName: "\(i)", isLocal: true, uuid: UUID().uuidString)
            imageArray.append(img)
        }
        block?(true, imageArray)
        
    }
 }
 
 
 class OnlineDataSource: DataSourceProtocol{
    
    let fileSync = FileSyncVC()
    func fetchPhotos(_ tags: [String], onCompletion block: CompletionCallback?) {
        //TODO: - 
        // 1. Fetch the data from Flikr
        // 2. get an array of 9 images
        // 3a. Start 9 NSOperations in a queue OR dispatch_async
        // 3b. save the images to document directory with names 0...8
        // once done, call the completion block with an array of local names / paths
        
        self.fetchImagesFromFlickr { (status, result) in
            guard status, let resultArray = result else{
                print("error")
                block?(false, [GameImage]())
                return
            }
            
            let arr9 = Array(resultArray[0..<GameConstants.MatrixSize]) // pick only 9 images
            var imageArray = [GameImage]()
            self.fileSync.startFileDownload(from: arr9, withCompletion: { (status, result) in
                let folder = FileManager.default.pathInDocumentDirectoryFor("images_gk")
                for i in 0 ..< GameConstants.MatrixSize{
                    let path = "\(folder)down\(i).jpg"
                    let img = GameImage(pathOrName: path, isLocal: false, uuid: UUID().uuidString)
                    
                    imageArray.append(img)
                }
                block?(true, imageArray)
            })
        }
    }
    
    fileprivate static var pageNo: Int = 2
    func fetchImagesFromFlickr(_ onCompletion: @escaping APICompletionCallback){
        FlickrKit.shared().initialize(withAPIKey: HxFlickr.key.rawValue, sharedSecret: HxFlickr.secret.rawValue)
        let flickrInteresting = FKFlickrInterestingnessGetList()
        
        
        flickrInteresting.page = "\(OnlineDataSource.pageNo)"
        flickrInteresting.per_page = "10"
        OnlineDataSource.pageNo += 1 // increment
        
        var photoURLs = [String]()

        FlickrKit.shared().call(flickrInteresting, maxCacheAge: FKDUMaxAgeNeverCache) { (fResponse, error) -> Void in
            /// No errors
            guard error == nil,
                let response = fResponse else{
                    onCompletion(false, nil)
                    return
            }
            let topPhotos = response["photos"] as! [String: AnyObject]
            let photoArray = topPhotos["photo"] as! [[String: AnyObject]]
            for photoDictionary in photoArray {
                let photoURL = FlickrKit.shared().photoURL(for: FKPhotoSizeSmall240, fromPhotoDictionary: photoDictionary)
                photoURLs.append((photoURL?.absoluteString)!)
            }
            onCompletion(true, photoURLs)
        }
    }
 }
