//
//  FileGenerated.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 02/10/22.
//

import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    let container = NSPersistentContainer(name: "Generations")
    
    static let shared = CoreDataManager()
    init() {
        container.loadPersistentStores{desc, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext){
        do {
            try context.save()
            print("Save")
        } catch {
            print("Nope")
        }
    }
    
    func addFile(id: UUID, name: String, description: String, file_name: String, data: SendableData, context: NSManagedObjectContext){
        let file = Generations(context: context)
        file.id = id
        file.date = Date()
        file.name = name
        file.file_name = file_name
        file.description_f = description
        file.data = data
        
        save(context: context)
    }
}
