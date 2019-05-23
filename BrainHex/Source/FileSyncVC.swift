//
//  FileSyncVC.swift
//  BrainHex
//
//  Created by Gaurav on 05/08/16.
//  Copyright © 2016 Gaurav Keshre. All rights reserved.
//

typealias DownloadCompletionCallback = (_ status: Bool, _ result: [String]?) -> ()

import Foundation
class FileSyncVC {
    var callback: DownloadCompletionCallback? = nil
    
    func startFileDownload(from arrayOfFileURLS: [String], withCompletion: @escaping DownloadCompletionCallback){
        guard arrayOfFileURLS.count > 0 else{
            return
        }
        self.callback = withCompletion
        
        
        let group: DispatchGroup = DispatchGroup();
        
        let queue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)
        let folder = FileManager.default.pathInDocumentDirectoryFor("images_gk")
        
        var indx = 0
        
        ///Clean the folder first
        FileManager.default.deleteContentsOfFolder(folder)
        
        ///Dipatch Group to download and write the files
        for strImage in arrayOfFileURLS{
            queue.async(group: group, execute: {
                guard let data = try? Data(contentsOf: URL(string: strImage)!) else{
                    print("Failed to download file : \(strImage)")
                    return
                }
                let path = "\(folder)down\(indx).jpg"
                do{
                    try data.write(to: URL(fileURLWithPath: path), options: .atomicWrite)
                    indx += 1
                }catch{
                    print("Failed to Save file on path: \(path)")
                }
            });
            
        }
        
        ///Dipatch will execute when all files are downloaded and written
        group.notify(queue: queue) {
            if  arrayOfFileURLS.count > 0{
                self.callback?(true, arrayOfFileURLS)
            }else{
                self.callback?(false, nil)
            }
        }
    }
}



extension FileManager{
    var pathToDocumentDirectoryOrTempDirectory: String{
        guard let docDirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else{
            return NSTemporaryDirectory()
        }
        return docDirPath
    }
    func pathInDocumentDirectoryFor(_ folder: String) -> String{
        
        let folderPath = self.pathToDocumentDirectoryOrTempDirectory + "/\(folder)"
        if !(self.fileExists(atPath: folderPath)){
            do{
                try self.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
            }catch{
                return NSTemporaryDirectory()
            }
        }
        return "\(folderPath)/"
    }
    
    public func deleteContentsOfFolder(_ folderPath: String)
    {
        do {
            let filePaths = try self.contentsOfDirectory(atPath: folderPath)
            for filePath in filePaths {
                try self.removeItem(atPath: folderPath + filePath)
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
}
