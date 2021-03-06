//
//  DataFile.swift
//  FileKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015-2016 Nikolai Vazquez
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

/// A representation of a filesystem data file.
///
/// The data type is NSData.
public typealias DataFile = File<NSData>

extension File where Data: NSData {

    /// Reads the file and returns its data.
    /// - Parameter options: A mask that specifies write options
    ///                      described in `NSDataReadingOptions`.
    ///
    /// - Throws: `FileKitError.ReadFromFileFail`
    /// - Returns: The data read from file.
    public func read(options: NSDataReadingOptions) throws -> Data {
        return try Data.readFromPath(path, options: options)
    }

    /// Writes data to the file.
    ///
    /// - Parameter data: The data to be written to the file.
    /// - Parameter options: A mask that specifies write options
    ///                      described in `NSDataWritingOptions`.
    ///
    /// - Throws: `FileKitError.WriteToFileFail`
    ///
    public func write(data: Data, options: NSDataWritingOptions) throws {
        do {
            try data.writeToFile(self.path._safeRawValue, options: options)
        } catch {
            throw FileKitError.WriteToFileFail(path: path)
        }
    }

}
