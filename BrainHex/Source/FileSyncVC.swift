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
    let callback: DownloadCompletionCallback? = nil
    
    func startFileDownload(from arrayOfFileURLS: [String], withCompletion: DownloadCompletionCallback){
        guard arrayOfFileURLS.count > 0 else{
            return
        }
        let group: dispatch_group_t = dispatch_group_create();
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
        let mainQ = dispatch_get_main_queue()
        let folder = NSFileManager.defaultManager().pathInDocumentDirectoryFor("images_gk")
        
        for strImage in arrayOfFileURLS{
            dispatch_group_async(group, queue, {
                if let data = NSData(contentsOfURL: NSURL(string: strImage)!){
                    let name = strImage.componentsSeparatedByString("=").last!
                    let path = "\(folder)\(name).jpg"
                    
                    do{
                        try data.writeToFile(path, options: .AtomicWrite)
                    }catch{
                        print("Failed to Save file on path: \(path)")
                    }
                }
            });
        }
        
        dispatch_group_notify(group, mainQ) {
            let images = arrayOfFileURLS.flatMap({$0.componentsSeparatedByString("=").last})
            if  images.count > 0{
                self.callback?(status: true, result: images)
            }else{
                self.callback?(status: false, result: nil)
            }
        }
    }
}



extension NSFileManager{
    var pathToDocumentDirectoryOrTempDirectory: String{
        guard let docDirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first else{
            print("Returning NSTemporaryDirectory() when asked for pathForReactJSFiles. There is some serious problem here!")
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
                print("Returning NSTemporaryDirectory() when asked for pathForReactJSFiles. There is some serious problem here!")
                return NSTemporaryDirectory()
            }
        }
        return "\(folderPath)/"
    }
}