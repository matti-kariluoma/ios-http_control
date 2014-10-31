//
//  BonjourService.swift
//  Http Control
//
//  Created by Matti Kariluoma on 10/30/14.
//  Copyright (c) 2014 Kariluoma Industries. All rights reserved.
//

import Foundation

class BonjourServicer: NSObject, NSNetServiceDelegate
{
    let view: ViewController
    init(view: ViewController)
    {
        self.view = view
        super.init()
    }
    
    func netServiceDidResolveAddress(sender: NSNetService)
    {
        view.httpds.append("found something")
        view.tableView.reloadData()
        let host = sender.hostName
        let port = sender.port
        view.httpds.append("http://\(host):\(port)/")
        view.tableView.reloadData()
    }
    
    func netService(sender: NSNetService, didNotResolve errorDict: [NSObject : AnyObject])
    {
        view.httpds.append("service resolve error")
        view.tableView.reloadData()
        NSLog("Search was not successful. Error code: \(errorDict[NSNetServicesErrorCode]!)")
    }
}