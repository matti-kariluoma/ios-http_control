//
//  BareBonjourBrowser.swift
//  Http Control
//
//  Created by Matti Kariluoma on 10/30/14.
//  Copyright (c) 2014 Kariluoma Industries. All rights reserved.
//

import Foundation


class BareBonjourBrowser: NSObject, NSNetServiceBrowserDelegate
{
    let browser: NSNetServiceBrowser
    let servicer: BareBonjourServicer
    var found: [NSNetService]
    
    override init()
    {
        self.browser = NSNetServiceBrowser()
        self.servicer = BareBonjourServicer()
        self.found = []
        super.init()
        self.browser.delegate = self
        self.browser.searchForServicesOfType(
            "_http._tcp.", inDomain:"")
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
            service.resolveWithTimeout(5)
            let name = service.name
            NSLog("search \(name)")
        }
        found.removeAll()
    }
    
    func netServiceBrowser(aNetServiceBrowser: NSNetServiceBrowser, didNotSearch errorDict: [NSObject : AnyObject])
    {
        NSLog("search failed")
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