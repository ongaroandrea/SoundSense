//
//  PastSonification.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 01/10/22.
//

import SwiftUI
import CoreData

struct PastSonificationView: View {

    @ObservedObject var connection: Connection = Connection()
    @EnvironmentObject var audioManager: AudioManager
    @Binding var visiblePlayer: Bool
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(connection.content, id: \.self) { file in
                    NavigationLink(value: file) {
                        VStack{
                            Text("\(file.created_at) - \(file.file_type)")
                        }
                    }
                }
                .onDelete(perform: deleteFile)
            }
            .navigationDestination(for: RecevingData.self) { data in
                PastSoundView(obj: data, visiblePlayer: $visiblePlayer)
                    .environmentObject(audioManager)
            }
            .listStyle(.plain)
            
            .navigationTitle("Sonificazioni passate")
            .padding(.vertical)
        }
        .onAppear(perform: {
            //connection.getPreviousData()
            print(connection.content)
        })
    }
    
    func deleteFile(offsets: IndexSet){
        print(offsets)
        withAnimation{
            connection.deleteFile(id: offsets.count)
        }
    }
}

struct PastSonification_Previews: PreviewProvider {
    static var previews: some View {
        PastSonificationView(visiblePlayer: .constant(false))
            .environmentObject(AudioManager())
    }
}
