//
//  BareBonjourService.swift
//  Http Control
//
//  Created by Matti Kariluoma on 10/30/14.
//  Copyright (c) 2014 Kariluoma Industries. All rights reserved.
//

import Foundation

class BareBonjourServicer: NSObject, NSNetServiceDelegate
{
    override init()
    {
        super.init()
    }
    
    func netServiceDidResolveAddress(sender: NSNetService)
    {
        NSLog("found something")
        let host = sender.hostName
        let port = sender.port
        NSLog("http://\(host):\(port)/")
    }
    
    func netService(sender: NSNetService, didNotResolve errorDict: [NSObject : AnyObject])
    {
        NSLog("service resolve error: \(errorDict[NSNetServicesErrorCode]!)")
    }
    
    func netServiceWillResolve(sender: NSNetService)
    {
        let name = sender.name
        NSLog("looking for \(name)")
    }
    
    func netServiceDidStop(sender: NSNetService)
    {
        let name = sender.name
        NSLog("done with \(name)")
    }
}