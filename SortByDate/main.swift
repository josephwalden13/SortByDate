//
//  main.swift
//  SortByName
//
//  Created by Joseph Walden on 24/03/2021.
//
//

import Foundation
import ArgumentParser

func createDirectory(_ path:String) {
    let fileManager = FileManager()
    do {
        try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
    }
    catch {
        print("Failed to create directory at \(path)")
    }
}

struct Files: ParsableCommand {
    @Argument(help: "File to move")
    var files:[String]

    mutating func run() {
        let fileManager:FileManager = FileManager()
        for file in files {
            do {
                if let modifiedDate = try fileManager.attributesOfItem(atPath: file)[.modificationDate] as? Date {
                    let components = Calendar.current.dateComponents([.year, .month, .day], from: modifiedDate)
                    if let year = components.year, let month = components.month, let day = components.day {
                        let dir = "\(year)/\(month)/\(day)"
                        createDirectory(dir)
                        do {
                            if let filename = file.split(separator: "/").last {
                                try fileManager.moveItem(atPath: file, toPath: "\(dir)/\(filename)")
                            }
                        }
                        catch {
                            print("Failed to move file \(file)")
                        }
                    }
                }
            }
            catch {
                print("Skipping \(file) due to: \n\(error.localizedDescription)")
            }
        }
    }
}

Files.main()
