//
//  DriveLoggerDataFormat.swift
//  DriveLoggerServicePackage
//
//  Created by Ronan Furuta on 10/24/20.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

public struct DLStateDocument: FileDocument {
    
    public static var readableContentTypes: [UTType] { [.plainText] }

    public var appData: String

    public init(data: String) {
        self.appData = data
    }

    public init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        appData = string
    }

    public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: appData.data(using: .utf8)!)
    }
    
}
