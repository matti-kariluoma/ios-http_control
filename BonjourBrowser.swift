//
//  BonjourBrowser.swift
//  Http Control
//
//  Created by Matti Kariluoma on 10/30/14.
//  Copyright (c) 2014 Kariluoma Industries. All rights reserved.
//

import Foundation

class SKey: Hashable, Equatable
{
    var name: String
    var type: String
    var domain: String
    init(_ service: NSNetService)
    {
        name = service.name
        type = service.type
        domain = service.domain
    }
    var hashValue: Int
    {
        get {return "\(name)\(type)\(domain)".hashValue}
    }
}
func ==(lhs: SKey, rhs: SKey) -> Bool
{
    return lhs.hashValue == rhs.hashValue
}

class BonjourBrowser: NSObject, NSNetServiceBrowserDelegate
{
    let view: ViewController
    let browser: NSNetServiceBrowser
    let servicer: BonjourServicer?
    var found: [SKey: NSNetService]
    var resolving: [SKey: NSNetService]
    var reified: [SKey: [String]]
    
    init(view: ViewController)
    {
        self.view = view
        self.browser = NSNetServiceBrowser()
        self.found = [SKey: NSNetService]()
        self.resolving = [SKey: NSNetService]()
        self.reified = [SKey: [String]]()
        super.init()
        self.servicer = BonjourServicer(supervisor: self)
        self.browser.delegate = self
        self.browser.searchForServicesOfType(
            "_http._tcp.", inDomain:"")
    }
    
    func updateView()
    {
        // TODO: some sort of cool-down to prevent flashing UI
        // TODO: message if no servers found
        view.httpds.removeAll(keepCapacity: true)
        for httpds in reified.values
        {
            for httpd in httpds
            {
                view.httpds.append(httpd)
            }
        }
        view.tableView.reloadData()
    }
    
    func foundService(service: NSNetService)
    {
        found[SKey(service)] = service
    }
    
    func forgetService(service: NSNetService)
    {
        let key = SKey(service)
        service.stop()
        if let fservice = found.removeValueForKey(key)
        {
            fservice.stop()
        }
        if let rservice = resolving.removeValueForKey(key)
        {
            rservice.stop()
        }
        // TODO: animate fade-out/disappear of old entries
        reified.removeValueForKey(key)
        updateView()
    }
    
    func resolvedService(service: NSNetService, _ httpds: [String])
    {
        let key = SKey(service)
        resolving.removeValueForKey(key)
        reified[key] = httpds
        updateView()
    }
    
    func resolve()
    {
        let infinite = NSTimeInterval(0.0)
        for key in self.found.keys
        {
            if let service = self.found.removeValueForKey(key)
            {
                service.delegate = servicer
                service.resolveWithTimeout(infinite)
                resolving[key] = service
            }
        }
    }
    
    func netServiceBrowser(aNetServiceBrowser: NSNetServiceBrowser, didNotSearch errorDict: [NSObject : AnyObject])
    {
        view.tableView.reloadData()
    }
    
       
    func netServiceBrowser(aNetServiceBrowser: NSNetServiceBrowser, didRemoveService aNetService: NSNetService, moreComing: Bool)
    {
        forgetService(aNetService)
        if (!moreComing)
        {
                resolve()
        }
    }
    
    func netServiceBrowser(aNetServiceBrowser: NSNetServiceBrowser, didFindService aNetService: NSNetService, moreComing: Bool)
    {
        foundService(aNetService)
        if (!moreComing)
        {
            resolve()
        }
    }
    
}