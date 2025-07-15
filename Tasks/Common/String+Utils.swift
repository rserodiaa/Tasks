//
//  String+Utils.swift
//  Tasks
//
//  Created by Rahul Serodia on 15/07/25.
//

import Foundation

extension String {
    func truncated(to length: Int) -> String {
        guard length > 0 else { return "" }
        if self.count <= length {
            return self
        } else {
            let truncated = String(self.prefix(length))
            return "\(truncated)..."
        }
    }
}
