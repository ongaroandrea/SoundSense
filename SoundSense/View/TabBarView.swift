//
//  TabView.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 30/09/22.
//

import SwiftUI

struct TabBarView: View {
    @State var current = 0 //tab selection
    @State var expand = false
    @Namespace var animation
    @EnvironmentObject var audioManager: AudioManager

    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
            TabView(selection: $current){
                ListView(visiblePlayer: $expand)
                    .tag(0)
                    .tabItem{
                        Image(systemName: "square.and.arrow.down")
                        Text("Nuovo")
                    }
                    .environmentObject(audioManager)
                
                PastSonificationView(visiblePlayer: $expand)
                    .tag(1)
                    .tabItem{
                        Image(systemName: "folder.fill")
                        Text("Creazioni Passate")
                    }
                    .environmentObject(audioManager)
                
                SettingsView()
                    .tag(2)
                    .tabItem{
                        Image(systemName: "gear")
                        Text("Promemoria")
                    }
                    .environmentObject(audioManager)
            }
            .accentColor(Color.blue)
            
            Miniplayer(animation: animation, expand: $expand, track: "chitarra")
                .environmentObject(audioManager)
        })
        
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
            .environmentObject(VisibleMiniplayer())
            .environmentObject(AudioManager())
    }
}
