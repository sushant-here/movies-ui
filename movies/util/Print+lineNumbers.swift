//
//  Print+lineNumbers.swift
//  movies
//
//  Created by Sushant Verma on 21/6/2023.
//

import Foundation

#if DEBUG
struct DebugTimestamp {
    static var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return formatter
    }()
}

// Override print with a print that puts line number.... https://stackoverflow.com/a/55835930
public func print(_ items: String..., filename: String = #file, function : String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n") {

    let pretty = "\(DebugTimestamp.formatter.string(from: .now)) \(URL(fileURLWithPath: filename).lastPathComponent):\(line).\(function) -> "
    let output = items.map { "\($0)" }.joined(separator: separator)
    Swift.print(pretty+output, terminator: terminator)

}
#endif
