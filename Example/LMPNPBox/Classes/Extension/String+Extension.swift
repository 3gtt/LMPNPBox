//
//  String+Extension.swift
//  LMPNPBox_Example
//
//  Created by Liam on 2021/11/16.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

extension String {
    
    func index(from number: Int) -> String.Index {
        return self.index(self.startIndex, offsetBy: number)
    }
    
    func substring(from start: Int, to end: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: end)
        return String(self[startIndex..<endIndex])
    }
    
    func substrings(sublength: Int) -> [String] {
        var substrings: [String] = []
        for i in 0..<(self.count / sublength) {
            let startIndex = i * sublength
            let endIndex = startIndex + sublength
            let substring = self.substring(from: startIndex, to: endIndex)
            substrings.append(substring)
        }
        if self.count % sublength != 0 {
            let lastStartIndex = substrings.count * sublength
            let lastString = self[self.index(from: lastStartIndex)...]
            substrings.append(String(lastString))
        }
        return substrings
    }
    
}
