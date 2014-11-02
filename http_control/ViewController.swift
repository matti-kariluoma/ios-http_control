//
//  ViewController.swift
//  http_control
//
//  Created by Matti Kariluoma on 10/29/14.
//  Copyright (c) 2014 Kariluoma Industries. All rights reserved.
//

import UIKit

class ViewController: UITableViewController,UITableViewDelegate, UITableViewDataSource
{
    var httpds: [String]
    let none_found = "No Http servers can be found!"
    let browser: BonjourBrowser?
    
    @IBAction
    func refresh()
    {
        if self.httpds.count < 1
        {
            self.httpds.append(none_found)
        }
    }
    
    required init(coder aDecoder: NSCoder)
    {
        self.httpds = [none_found]
        super.init(coder: aDecoder)
        self.browser = BonjourBrowser(view: self)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

