//
//  CSVReader.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 27/10/22.
//

import Foundation

func getCSVData(path: String) -> [DataType] {
    var array: [DataType] = []
    do {
        if let path2 = Bundle.main.path(forResource: "screenUsage.csv", ofType: nil) {
            print("[check] FILE AVAILABLE \(path2)")
            let content = try String(contentsOfFile: path2)
            var parsedCSV: [String] = content.components(separatedBy: "\n")
            parsedCSV.removeFirst() //rimuovo l'intestazione
            for line in parsedCSV {
                if line != "" {
                    let columns: [String] = line.components(separatedBy: ",")
                    let data = Date(timeIntervalSince1970: TimeInterval(Int(columns[0])!))
                    let value = Double(columns[3])!
                    array.append(DataType(id: UUID().uuidString, date: data, double: value))
                }
            }
            
        }
        return array
    }
    catch {
        print(error)
        return array
    }
}
