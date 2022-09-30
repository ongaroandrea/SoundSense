//
//  ListView.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 01/10/22.
//

import SwiftUI
import HealthKit
import CoreData

struct ListView: View {
    @State private var path: [String] = []
    @Environment(\.managedObjectContext) var dataController
    @EnvironmentObject var audioManager: AudioManager
    var body: some View {
        NavigationStack{
            VStack {
                ScrollView{
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 250), spacing: 15)], spacing: 50){
                        ForEach(HealthDataV2.datat, id: \.self) { data in
                            NavigationLink(value: data) {
                                SingleView(image: data.image, nome: data.name)
                                    
                            }
                        }
                        
                    }
                    .navigationDestination(for: HealthDataV2.self) { data in
                        SoundView(obj: data)
                            .environment(\.managedObjectContext, dataController)
                            .environmentObject(audioManager)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Sonifica ora")
            .padding(.vertical)
            Spacer()
        }
        
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
