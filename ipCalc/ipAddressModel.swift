//
//  ipAddress.swift
//  ipcalc
//
//  Created by Nate Beach on 4/1/23.
//

import Foundation

// TODO This should be a struct or class or whatever

enum IpClass: String, CaseIterable, Identifiable {
    case A = "Class A", B = "Class B", C = "Class C"
    var id: Self { self }
}

struct UserIpAddress {
    var userInput: String
    var ipAddressBinary = Array(repeating: 0, count: 32)
    var subnetMaskBinary = Array(repeating: 0, count: 32)
    var prefixAddressBinary = Array(repeating: 0, count: 32)
    var broadcastAddressBinary = Array(repeating: 0, count: 32)
    
    init(userInput: String) {
        self.userInput = userInput
        self.ipStringToBin()
        self.getSubnetMaskBinary()
        self.getPrefixAddressBinary()
        self.getBroadcastAddressBinary()
    }
    
    private mutating func ipStringToBin() {
        let s = userInput.components(separatedBy: "/")
        let octets = s[0].split(separator: ".")
        var idx = 0
        for octet in octets {
            let octet_i = Int(octet) ?? 0
            for i in stride(from:7,to:-1,by:-1) {
                let b = (octet_i >> i) & 1
                ipAddressBinary[idx] = b
                idx += 1
            }
        }
    }
    
    
    private mutating func getSubnetMaskBinary() {
        let s = userInput.components(separatedBy: "/")
        if s.count < 2 {
            return
        }
        let mask = Int(s[1]) ?? -1
        if s.count == 2 && mask > 0 && mask < 33 {
            var count = 0
            
            for idx in 0..<32 {
                if count < mask {
                    subnetMaskBinary[idx] = 1
                }
                count += 1
            }
        }
    }
    
    
    private mutating func getPrefixAddressBinary() {
        if ipAddressBinary.count != 32 || subnetMaskBinary.count != 32 {
            return
        }
        for idx in 0..<32 {
            prefixAddressBinary[idx] = (ipAddressBinary[idx] & subnetMaskBinary[idx])
        }
    }
    
    
    
    private mutating func getBroadcastAddressBinary() {
        if ipAddressBinary.count != 32 || subnetMaskBinary.count != 32 {
            return
        }
        var complement = Array<Int>()
        // flip bits
        for bit in subnetMaskBinary {
            if bit == 1 {
                complement.append(0)
            } else {
                complement.append(1)
            }
        }
        for idx in 0..<32 {
            broadcastAddressBinary[idx] = (ipAddressBinary[idx] | complement[idx])
        }
    }
    
    public func binaryToIp(b: Array<Int>) -> String {
        if b.count != 32 {
            return ""
        }
        var result = Array<String>()
        for chunk in stride(from:0,to:25, by: 8) {
            var octet = 0
            for idx in 0..<8 {
                let actualIdx = chunk + idx
                octet += b[actualIdx] << (7 - idx)
            }
            result.append(String(octet))
            
        }
        return result.joined(separator: ".")
        
    }
    
    public func alignedBinary(b: Array<Int>) -> String {
        var result = ""
        for chunk in stride(from: 0, to:b.count, by:8) {
            for idx in 0..<8 {
                let actualIdx = chunk + idx
                result += String(b[actualIdx])
            }
            result += " "
        }
        return result
    }
}
