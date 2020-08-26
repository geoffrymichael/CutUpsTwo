//
//  FilesManager.swift
//  CutUpsTwo
//
//  Created by Geoffry Gambling on 8/25/20.
//  Copyright © 2020 Geoffry Gambling. All rights reserved.
//

import Foundation

class FilesManager {
    enum Error: Swift.Error {
        case fileAlreadyExists
        case invalidDirectory
        case writtingFailed
        case fileNotExists
        case readingFailed
    }
    let fileManager: FileManager
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    func save(fileNamed: String, data: Data) throws {
        guard let url = makeURL(forFileNamed: fileNamed) else {
            throw Error.invalidDirectory
        }
       
        do {
            try data.write(to: url, options: .atomicWrite)
        } catch {
            debugPrint(error)
            throw Error.writtingFailed
        }
    }
    
    func delete(fileNamed: String) throws {
        guard let url = makeURL(forFileNamed: fileNamed) else {
            throw Error.fileNotExists
        }
        
        do {
            try fileManager.removeItem(at: url)
        } catch {
            print("error deleting")
        }
    }
    
    private func makeURL(forFileNamed fileName: String) -> URL? {
        
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(fileName)
    }
    
    func read(fileNamed: String) throws -> Data {
        guard let url = makeURL(forFileNamed: fileNamed) else {
            throw Error.invalidDirectory
        }
        //Read was failing here at check if file exists. I presume i am cchecking in the wrong location as it appears the do statement below it is able to retrieve data.
//        guard fileManager.fileExists(atPath: url.absoluteString) else {
//            throw Error.fileNotExists
//        }
        do {
            return try Data(contentsOf: url)
        } catch {
            debugPrint(error)
            throw Error.readingFailed
        }
    }
    
}
