#!/usr/bin/swift
//
//  FileExample.swift
//  Created by Ekkehard Koch on 2022.05.03.
//

import Foundation
// Setting directory URL "/Users/ekkehard/Desktop/" needs to be replaced
// with the full directory path where this code resides
let directoryPath = URL(fileURLWithPath: " /Users/ekkehard/Library/Mobile\ Documents/com\~apple\~CloudDocs/Workspace/SwiftExamples/")
print(directoryPath)
// Add Data.txt filename to directoryPath
let fileURL = directoryPath
    .appendingPathComponent("FileExample")
    .appendingPathExtension("txt")
print(fileURL)
// make sure the file exists
guard FileManager.default.fileExists(atPath: fileURL.path) else {
    preconditionFailure("file expected at \(fileURL.absoluteString) is missing.")
}
// open the file for reading
guard let filePointer:UnsafeMutablePointer<FILE> = fopen(fileURL.path, "r") else {
    preconditionFailure("Could not open file at \(fileURL.absoluteString)")
}
// a pointer to a null-terminated, UTF-8 encoded sequence of bytes
var lineByteArrayPointer: UnsafeMutablePointer<CChar>? = nil
defer {
    // Close the file when done
    fclose(filePointer)
    // Buffer should be freed
    lineByteArrayPointer?.deallocate()
}
// the smallest multiple of 16 that will fit the byte array for this line
var lineCap: Int = 0
// initial iteration
var bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
// go through file line by line
while (bytesRead > 0) {
    // note: this translates the sequence of bytes to a string using UTF-8 interpretation
    let lineAsString = String.init(cString:lineByteArrayPointer!)
    // do whatever you need to do with this single line of text
    // for debugging, can print it
    print(lineAsString)
    // updates number of bytes read, for the next iteration
    bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
}
