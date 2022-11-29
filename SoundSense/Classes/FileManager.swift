//
//  FileManager.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 01/10/22.
//

import Foundation

final class FilesManager {
    
    //https://mobikul.com/play-audio-file-save-document-directory-ios-swift/
    
    func writeToFile(data: Data, fileurl: URL){
        // get path of directory
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            return
        }
        do{
           try data.write(to: fileurl, options: .atomic)
        }catch {
           print("Unable to write in new file.")
        }
    }
    
    func checkName(name: String) -> URL? {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            return nil
        }
        var fileurl: URL
        var i = 0
        repeat {
            fileurl =  directory.appendingPathComponent("\(name)_\(i).wav")
            i += 1
        } while(FileManager.default.fileExists(atPath: fileurl.path))
        
        return fileurl
    }
}
