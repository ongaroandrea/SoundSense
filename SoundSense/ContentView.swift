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

    var body: some View {
        TabBarView()
            .environmentObject(audioManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

final class VisibleMiniplayer: ObservableObject {
    var visibility: Bool = false
}
