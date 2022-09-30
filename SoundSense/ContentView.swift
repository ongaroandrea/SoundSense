//
//  ContentView.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 30/09/22.
//

import SwiftUI

///https://www.youtube.com/watch?v=O0FSDNOXCl0
struct ContentView: View {
    @StateObject var audioManager = AudioManager()
    @StateObject var dataController = CoreDataManager()
    var body: some View {
        TabBarView()
            .environmentObject(audioManager)
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
