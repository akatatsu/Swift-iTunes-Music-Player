//
//  ViewController.swift
//  Swift-MusicPlayer
//
//  Created by Tatsuhiko Akashi on 2014/10/12.
//  Copyright (c) 2014年 akatatsu. All rights reserved.
//

import UIKit
import QuartzCore

class SearchResultsViewController: UIViewController, UITableViewDelegate, APIControllerProtocol, UISearchBarDelegate {
    
    @IBOutlet weak var appsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var api : APIController?
    let kCellIdentifier: String = "SearchResultCell"
    var imageCache = [String : UIImage]()
    var albums = [Album]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "iTunes Music Player"
        api = APIController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api!.searchItunesFor("Beatles")
        
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        
        return albums.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        
        let album = self.albums[indexPath.row]
        cell.textLabel?.text = album.title
        cell.imageView?.image = UIImage(named: "Blank52")
        
        let urlString = album.thumbnailImageURL
        
        let formattedPrice = album.price
        
        var image = self.imageCache[urlString]
        
        if( image == nil ) {
            
            var imgURL: NSURL = NSURL(string: urlString)
            
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    image = UIImage(data: data)
                    
                    self.imageCache[urlString] = image
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                            cellToUpdate.imageView?.image = image
                        }
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
        }
        else {
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                    cellToUpdate.imageView?.image = image
                }
            })
        }
        
        cell.detailTextLabel?.text = formattedPrice
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var detailsViewController: DetailsViewController = segue.destinationViewController as DetailsViewController
        var albumIndex = appsTableView!.indexPathForSelectedRow()!.row
        var selectedAlbum = self.albums[albumIndex]
        detailsViewController.album = selectedAlbum
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.albums = Album.albumsWithJSON(resultsArr)
            self.appsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    func searchBarSearchButtonClicked( searchBar: UISearchBar!)
    {
        println(searchBar.text)
        api!.searchItunesFor(searchBar.text)
        searchBar.resignFirstResponder()
    }


}

