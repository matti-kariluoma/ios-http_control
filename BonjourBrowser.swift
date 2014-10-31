//
//  BonjourBrowser.swift
//  Http Control
//
//  Created by Matti Kariluoma on 10/30/14.
//  Copyright (c) 2014 Kariluoma Industries. All rights reserved.
//

import Foundation


class BonjourBrowser: NSObject, NSNetServiceBrowserDelegate
{
    let view: ViewController
    let browser: NSNetServiceBrowser
    let servicer: BonjourServicer
    var found: [NSNetService]
    init(view: ViewController)
    {
        self.view = view
        self.browser = NSNetServiceBrowser()
        self.servicer = BonjourServicer(view: view)
        self.found = []
        super.init()
        self.browser.delegate = self
        self.browser.searchForServicesOfType(
            "_http._tcp.", inDomain:"local")
    }
    
    func addService(service: NSNetService)
    {
        found.append(service)
    }
    
    func resolve()
    {
        for service in self.found
        {
            service.delegate = servicer
            service.resolveWithTimeout(NSTimeInterval(0.0))
            let name = service.name
            view.httpds.append("search \(name)")
        }
        view.tableView.reloadData()
        found.removeAll()
    }
    
    func netServiceBrowser(aNetServiceBrowser: NSNetServiceBrowser, didNotSearch errorDict: [NSObject : AnyObject])
    {
        view.httpds.append("search failed")
        view.tableView.reloadData()
    }
    
       
    func netServiceBrowser(aNetServiceBrowser: NSNetServiceBrowser, didRemoveService aNetService: NSNetService, moreComing: Bool)
    {
        // TODO: stop resolving
        // TODO: delete from list
        if (!moreComing)
        {
                resolve()
        }
    }
    
    func netServiceBrowser(aNetServiceBrowser: NSNetServiceBrowser, didFindService aNetService: NSNetService, moreComing: Bool)
    {
        addService(aNetService)
        if (!moreComing)
        {
            resolve()
        }
    }
    
}