//
//  FileSyncVC.swift
//  BrainHex
//
//  Created by Gaurav on 05/08/16.
//  Copyright © 2016 Gaurav Keshre. All rights reserved.
//

typealias DownloadCompletionCallback = (status: Bool, result: [String]?) -> ()

import Foundation
class FileSyncVC {
    var callback: DownloadCompletionCallback? = nil
    
    func startFileDownload(from arrayOfFileURLS: [String], withCompletion: DownloadCompletionCallback){
        guard arrayOfFileURLS.count > 0 else{
            return
        }
        self.callback = withCompletion
        
        
        let group: dispatch_group_t = dispatch_group_create();
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
               let folder = NSFileManager.defaultManager().pathInDocumentDirectoryFor("images_gk")
        
        var indx = 0
        
        ///Clean the folder first
        NSFileManager.defaultManager().deleteContentsOfFolder(folder)
        
        ///Dipatch Group to download and write the files
        for strImage in arrayOfFileURLS{
            dispatch_group_async(group, queue, {
                if let data = NSData(contentsOfURL: NSURL(string: strImage)!){
                    let path = "\(folder)down\(indx).jpg"
                    do{
                        try data.writeToFile(path, options: .AtomicWrite)
                        indx += 1
                    }catch{
                        print("Failed to Save file on path: \(path)")
                    }
                }
            });
            
        }
        
        ///Dipatch will execute when all files are downloaded and written
        dispatch_group_notify(group, queue) {
            if  arrayOfFileURLS.count > 0{
                self.callback?(status: true, result: arrayOfFileURLS)
            }else{
                self.callback?(status: false, result: nil)
            }
        }
    }
}



extension NSFileManager{
    var pathToDocumentDirectoryOrTempDirectory: String{
        guard let docDirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first else{
            return NSTemporaryDirectory()
        }
        return docDirPath
    }
    func pathInDocumentDirectoryFor(folder: String) -> String{
        
        let folderPath = self.pathToDocumentDirectoryOrTempDirectory.stringByAppendingString("/\(folder)")
        if !(self.fileExistsAtPath(folderPath)){
            do{
                try self.createDirectoryAtPath(folderPath, withIntermediateDirectories: true, attributes: nil)
            }catch{
                return NSTemporaryDirectory()
            }
        }
        return "\(folderPath)/"
    }
    
    public func deleteContentsOfFolder(folderPath: String)
    {
        do {
            let filePaths = try self.contentsOfDirectoryAtPath(folderPath)
            for filePath in filePaths {
                try self.removeItemAtPath(folderPath + filePath)
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
}