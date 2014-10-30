//
//  ViewController.swift
//  http_control
//
//  Created by Matti Kariluoma on 10/29/14.
//  Copyright (c) 2014 Kariluoma Industries. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UITableViewController,UITableViewDelegate, UITableViewDataSource, NSNetServiceDelegate, NSNetServiceBrowserDelegate
{
    var httpds: [String]
    var found: [NSNetService]
    let browser: NSNetServiceBrowser
    @IBAction
    func refresh()
    {
        self.httpds.removeAtIndex(0)
        self.httpds.append("hello")
        self.tableView.reloadData()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        self.httpds = [
                "http://192.168.3.100:8000/",
                "http://192.168.3.100:8080/",
                "obnoxiously long title tha twill over flow at some point hopefully righgt at the edge of the screen"
            ]
        self.found = []
        self.browser = NSNetServiceBrowser()
        super.init(coder: aDecoder)
        self.browser.delegate = self
        self.browser.searchForServicesOfType(
            "_http._tcp.", inDomain: "local")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.httpds.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
    let cell = self.tableView.dequeueReusableCellWithIdentifier("httpd_entry") as TableCell
        cell.title?.text = self.httpds[indexPath.row]
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if let url = NSURL(string: self.httpds[indexPath.row])
        {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func addService(service: NSNetService)
    {
        self.found.append(service)
    }
    
    func resolve()
    {
        for service in self.found
        {
            service.delegate = self
            service.resolveWithTimeout(5)
            let name = service.name
            self.httpds.append("search \(name)")
        }
        self.tableView.reloadData()
        self.found.removeAll()
    }
    
    func netServiceBrowser(aNetServiceBrowser: NSNetServiceBrowser, didNotSearch errorDict: [NSObject : AnyObject])
    {
        self.httpds.append("search failed")
        self.tableView.reloadData()
    }
    
    func netServiceDidResolveAddress(sender: NSNetService)
    {
        self.httpds.append("found something")
        self.tableView.reloadData()
        let host = sender.hostName
        let port = sender.port
        self.httpds.append("http://\(host):\(port)/")
        self.tableView.reloadData()
    }
    
    func netServiceBrowser(aNetServiceBrowser: NSNetServiceBrowser, didRemoveService aNetService: NSNetService, moreComing: Bool)
    {
        // TODO: stop resolving
        // TODO: delete from list
        if (!moreComing)
        {
            self.resolve()
        }
    }
    
    func netServiceBrowser(aNetServiceBrowser: NSNetServiceBrowser, didFindService aNetService: NSNetService, moreComing: Bool)
    {
        self.addService(aNetService)
        if (!moreComing)
        {
            self.resolve()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

