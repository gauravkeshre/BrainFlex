 //
 //  OnlineDataSource.swift
 //  BrainHex
 //
 //  Created by Gaurav on 05/08/16.
 //  Copyright © 2016 Gaurav Keshre. All rights reserved.
 //
 
 import Foundation
 import FlickrKit
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
            guard status, let resultArray = result else{
                print("error")
                block?(status: false, result: [GameImage]())
                return
            }
            
            let arr9 = Array(resultArray[0..<GameConstants.MatrixSize]) // pick only 9 images
            var imageArray = [GameImage]()
            self.fileSync.startFileDownload(from: arr9, withCompletion: { (status, result) in
                let folder = NSFileManager.defaultManager().pathInDocumentDirectoryFor("images_gk")
                for i in 0 ..< GameConstants.MatrixSize{
                    let path = "\(folder)down\(i).jpg"
                    let img = GameImage(pathOrName: path, isLocal: false, uuid: NSUUID().UUIDString)
                    
                    imageArray.append(img)
                }
                block?(status: true, result: imageArray)
            })
        }
    }
    
    private static var pageNo: Int = 2
    func fetchImagesFromFlickr(onCompletion: APICompletionCallback){
        FlickrKit.sharedFlickrKit().initializeWithAPIKey(HxFlickr.key.rawValue, sharedSecret: HxFlickr.secret.rawValue)
        let flickrInteresting = FKFlickrInterestingnessGetList()
        
        
        flickrInteresting.page = "\(OnlineDataSource.pageNo)"
        flickrInteresting.per_page = "10"
        OnlineDataSource.pageNo += 1 // increment
        
        var photoURLs = [String]()
        FlickrKit.sharedFlickrKit().call(flickrInteresting, maxCacheAge: FKDUMaxAgeNeverCache) { (fResponse, error) -> Void in
            /// No errors
            guard error == nil,
                let response = fResponse else{
                    onCompletion(status: false, result: nil)
                    return
            }
            let topPhotos = response["photos"] as! [String: AnyObject]
            let photoArray = topPhotos["photo"] as! [[String: AnyObject]]
            for photoDictionary in photoArray {
                let photoURL = FlickrKit.sharedFlickrKit().photoURLForSize(FKPhotoSizeSmall240, fromPhotoDictionary: photoDictionary)
                photoURLs.append(photoURL.absoluteString)
            }
            onCompletion(status: true, result: photoURLs)
        }
    }
 }