//
//  APIController.swift
//  Swift-MusicPlayer
//
//  Created by Tatsuhiko Akashi on 2014/10/12.
//  Copyright (c) 2014年 akatatsu. All rights reserved.
//

import Foundation


import Foundation

protocol APIControllerProtocol{
    func didReceiveAPIResults(results: NSDictionary)
}

class APIController {
    
    var delegate: APIControllerProtocol?
    
    init(delegate: APIControllerProtocol){
        self.delegate = delegate
    }
    
    func get(path: String) {
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if(error != nil) {
                
                println(error.localizedDescription)
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if(err != nil) {
                
                println("JSON Error \(err!.localizedDescription)")
            }
            let results: NSArray = jsonResult["results"] as NSArray
            self.delegate?.didReceiveAPIResults(jsonResult)
        })
        task.resume()
    }
    
    func searchItunesFor(searchTerm: String) {
        
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            let urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album"
            get(urlPath)
        }
    }
    
    func lookupAlbum(collectionId: Int) {
        get("https://itunes.apple.com/lookup?id=\(collectionId)&entity=song")
    }


}