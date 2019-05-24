//
//  DataSource.swift
//  BrainHex
//
//  Created by Manisha Utwal on 05/05/19.
//  Copyright © 2016 Manisha Utwal. All rights reserved.
//

import Foundation

// MARK:- Callback Typealias

typealias CompletionCallback    = (_ status: Bool, _ result: [GameImage])	-> ()
typealias APICompletionCallback    = (_ status: Bool, _ result: [String]?)	-> ()


/// This method will decide which data source to used based on internet connection
func ActiveDataSource()-> DataSourceProtocol{
    if isConnectedToInternet(){
        return OnlineDataSource()
    }else{
        return OfflineDataSource()
    }
}


/**
 Checks the Internet connection
 
 - returns: Retuns true if internet is persent
 */
func isConnectedToInternet() -> Bool
{
    return true
}




//MARK:- Protocol methods

protocol DataSourceProtocol {
    
    func fetchPhotos(_ tags:[String],
                     onCompletion block: CompletionCallback?)
    
}
