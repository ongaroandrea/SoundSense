//
//  ListView.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 01/10/22.
//

import SwiftUI
import HealthKit

struct ListView: View {
    @State private var path: [String] = []
    @EnvironmentObject var audioManager: AudioManager
    @Binding var visiblePlayer: Bool
    
    var body: some View {
        NavigationStack{
            VStack {
                ScrollView{
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 250), spacing: 15)], spacing: 50){
                        ForEach(HealthData.listHealthData, id: \.self) { data in
                            NavigationLink(value: data) {
                                SingleView(image: data.image, nome: data.name)
                            }
                        }
                    }
                    .navigationDestination(for: HealthData.self) { data in
                        SoundView(obj: data, visiblePlayer: $visiblePlayer)
                            .environmentObject(audioManager)
                    }
                    .padding(.horizontal)
                }
            }
            
            .navigationTitle("Sonifica ora")
            .padding(.vertical)
            .padding(.bottom, 40)
            Spacer()
        }
        
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        
        ListView(visiblePlayer: .constant(false))
            .environmentObject(AudioManager())
    }
}
