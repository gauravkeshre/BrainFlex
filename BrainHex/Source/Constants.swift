//
//  Constants.swift
//  BrainHex
//
//  Created by Gaurav on 04/08/16.
//  Copyright © 2016 Gaurav Keshre. All rights reserved.
//

import Foundation

enum HxFlickr: String{
    case key = "2e1aecfda3721ef1a6dc7f4980266180"
    case secret = "17e1c7eb8e4f96be"
    
    enum Api{
        //https://api.flickr.com/services/feeds/photos_public.gne?format=json&lang=en-us&nojsoncallback=1&tags=dog
        case publicPhoto(format:String, tags: [String])
        var url: String{
            var str = "https://api.flickr.com/services/feeds/"
            switch self {
            case .publicPhoto(let format, let tags):
                let strTags = tags.reduce("", combine: {$0 + "," + $1})
                str += "photos_public.gne?lang=en-us&nojsoncallback=1&tagmode=all&format=\(format)&tags=\(strTags)"
                return str
            }
        }
    }
}

struct GameConstants {
    /// Board
    static var MatrixSize: Int = 9
    
    ///Cosmetics
    static var FlipAnimationDuration: NSTimeInterval = 0.24
    
    /// Game
    static var ObservationTime: NSTimeInterval = 5 // in seconds. The player will be given 15 mins to observe the board.
}