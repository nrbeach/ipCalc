//
//  ContentView.swift
//  ipcalc
//
//  Created by Nate Beach on 3/27/23.
//

import SwiftUI

struct ContentView: View {
    @State private var userInput: String = ""
    var body: some View {
        VStack {
            Image(systemName: "cloud")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Enter an IP address in CIDR notation")
            TextField("192.168.1.1/24", text: $userInput)
            let ip = UserIpAddress(userInput: userInput)
            Grid {
                GridRow {
                    Text("Binary:")
                    Text(ip.alignedBinary(b: ip.ipAddressBinary)).monospacedDigit()
                    Text(ip.binaryToIp(b: ip.ipAddressBinary)).monospacedDigit()
                }
                Divider()
                GridRow {
                    Text("Subnet Mask:")
                    Text(ip.alignedBinary(b: ip.subnetMaskBinary)).monospacedDigit()
                    Text(ip.binaryToIp(b: ip.subnetMaskBinary)).monospacedDigit()
                }
                GridRow {
                    Text("Network Prefix:")
                    Text(ip.alignedBinary(b: ip.prefixAddressBinary)).monospacedDigit()
                    Text(ip.binaryToIp(b: ip.prefixAddressBinary)).monospacedDigit()
                }
                GridRow {
                    Text("Broadcast Address:")
                    Text(ip.alignedBinary(b: ip.broadcastAddressBinary)).monospacedDigit()
                    Text(ip.binaryToIp(b: ip.broadcastAddressBinary)).monospacedDigit()
                }
            }
            //Text(getClass(ip: ip_bin).rawValue)
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
