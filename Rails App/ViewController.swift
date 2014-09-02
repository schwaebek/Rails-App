//
//  ViewController.swift
//  Rails App
//
//  Created by Katlyn Schwaebe on 9/2/14.
//  Copyright (c) 2014 Katlyn Schwaebe. All rights reserved.
//

import UIKit
import CoreData
let API = "http://ancient-taiga-9634.herokuapp.com/"

class ViewController: UIViewController {
                            
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentField: UITextField!
    
    @IBAction func postNew(sender: AnyObject) {
        let newPostURL = API + "posts?post[title]=\(titleField.text)&post[content]=\(contentField.text)"
        //NSURL in objective c
        let encodedString = newPostURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        var request = NSMutableURLRequest(URL: NSURL(string: encodedString!))
        
        request.setValue("zxcasdqwe", forHTTPHeaderField: "AUTH_TOKEN")
        request.HTTPMethod = "POST"
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (respone: NSURLResponse!, data:NSData!, error: NSError!) -> Void in
            
            let info: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
            println(info)
            
        }
        
    }
    @IBAction func getMyPosts(sender: AnyObject) {
        let myPostsURL = API + "posts/mine"
        var request = NSMutableURLRequest(URL: NSURL(string: myPostsURL))
        request.setValue("zxcasdqwe", forHTTPHeaderField: "AUTH_TOKEN")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (respone: NSURLResponse!, data:NSData!, error: NSError!) -> Void in
            
            let posts = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSArray
            println(posts)
        }
    }
    @IBAction func getAllPosts(sender: AnyObject) {
        let allPostsURL = API + "posts"
        let request = NSURLRequest(URL:NSURL(string: allPostsURL))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (respone: NSURLResponse!, data:NSData!, error: NSError!) -> Void in
            
            let posts = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSArray
            println(posts)
        }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var appD = UIApplication.sharedApplication().delegate as AppDelegate
        
        var entity = NSEntityDescription.entityForName("Post", inManagedObjectContext: appD.managedObjectContext)
        
        var postObject = NSEntityDescription.insertNewObjectForEntityForName("Post", inManagedObjectContext: appD.managedObjectContext) as NSManagedObject
        
        postObject.setValue("jo@theironyard.com", forKey: "user")
        postObject.setValue("this is a cool title", forKey: "title")
        appD.saveContext()
        
        //// fetch
        var fetchRequest = NSFetchRequest()
        
        fetchRequest.entity = entity
        var predicate = NSPredicate(format: "user = 'jo@theironyard.com'")
        fetchRequest.predicate = predicate
        var sortDescriptor = NSSortDescriptor(key: "posted_at", ascending:true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        var fetchedObjects = appD.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil)
        println(fetchedObjects)
        
    
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

