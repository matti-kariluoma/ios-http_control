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
    let supervisor: BonjourBrowser
    
    init(supervisor: BonjourBrowser)
    {
        self.supervisor = supervisor
        super.init()
    }
    
    func netServiceDidResolveAddress(sender: NSNetService)
    {
        if let addresses = sender.addresses
        {
            var ips: [String] = []
            for address in addresses
            {
                let ptr = UnsafePointer<sockaddr_in>(address.bytes)
                var addr = ptr.memory.sin_addr
                var buf = UnsafeMutablePointer<Int8>.alloc(Int(INET6_ADDRSTRLEN))
                var family = ptr.memory.sin_family
                var ipc = UnsafePointer<Int8>()
                if family == __uint8_t(AF_INET)
                {
                    ipc = inet_ntop(Int32(family), &addr, buf, __uint32_t(INET6_ADDRSTRLEN))
                }
                else if family == __uint8_t(AF_INET6)
                {
                    let ptr6 = UnsafePointer<sockaddr_in6>(address.bytes)
                    var addr6 = ptr6.memory.sin6_addr
                    family = ptr6.memory.sin6_family
                    ipc = inet_ntop(Int32(family), &addr6, buf, __uint32_t(INET6_ADDRSTRLEN))
                }
                
                if let ip = String.fromCString(ipc)
                {
                    ips.append(ip)
                }
            }
            let port = sender.port
            var httpds: [String] = []
            for host in ips
            {
                let httpd = "http://\(host):\(port)/"
                httpds.append(httpd)
            }
            supervisor.resolvedService(sender, httpds)
        }
    }
    
    func netService(sender: NSNetService, didNotResolve errorDict: [NSObject : AnyObject])
    {
        supervisor.forgetService(sender)
    }
}