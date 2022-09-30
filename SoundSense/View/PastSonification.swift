//
//  PastSonification.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 01/10/22.
//

import SwiftUI
import CoreData

struct PastSonification: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var file: FetchedResults<Generations>
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                HStack{
                    Text("Generazione Passate")
                        .font(.title)
                        .bold()
                    Spacer()
                }
            }
            List {
                ForEach(file) { file in
                    NavigationLink(value: file) {
                        Text("\(file.name ?? "")")
                    }
                }
                .onDelete(perform: deleteFile)
            }
            .listStyle(.plain)
        }
    }
    
    func deleteFile(offsets: IndexSet){
        withAnimation{
            offsets.map{file[$0]}.forEach(managedObjContext.delete)
            CoreDataManager().save(context: managedObjContext)
        }
    }
}

struct PastSonification_Previews: PreviewProvider {
    static var previews: some View {
        PastSonification()
    }
}
