//
//  Track.swift
//  Swift-MusicPlayer
//
//  Created by Tatsuhiko Akashi on 2014/10/12.
//  Copyright (c) 2014年 akatatsu. All rights reserved.
//

import Foundation
class Track {
    
    var title: String
    var price: String
    var previewUrl: String
    
    init(title: String, price: String, previewUrl: String) {
        self.title = title
        self.price = price
        self.previewUrl = previewUrl
    }
    
    class func tracksWithJSON(allResults: NSArray) -> [Track] {
        
        var tracks = [Track]()
        
        if allResults.count>0 {
            for trackInfo in allResults {
                // Create the track
                if let kind = trackInfo["kind"] as? String {
                    if kind=="song" {
                        
                        var trackPrice = trackInfo["trackPrice"] as? String
                        var trackTitle = trackInfo["trackName"] as? String
                        var trackPreviewUrl = trackInfo["previewUrl"] as? String
                        
                        if(trackTitle == nil) {
                            trackTitle = "Unknown"
                        }
                        else if(trackPrice == nil) {
                            trackPrice = "?"
                        }
                        else if(trackPreviewUrl == nil) {
                            trackPreviewUrl = ""
                        }
                        
                        var track = Track(title: trackTitle!, price: trackPrice!, previewUrl: trackPreviewUrl!)
                        tracks.append(track)
                        
                    }
                }
            }
        }
        return tracks
    }

}