//
//  TabView.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 30/09/22.
//

import SwiftUI

struct TabBarView: View {
    @State var current = 0
    @State var expand = false
    @Namespace var animation
    @EnvironmentObject var audioManager: AudioManager
    @Environment(\.managedObjectContext) var dataController
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
            TabView(selection: $current){
                ListView()
                    .tag(0)
                    .tabItem{
                        Image(systemName: "square.and.arrow.down")
                        Text("New")
                    }
                    .environmentObject(audioManager)
                    .environment(\.managedObjectContext, dataController)
                
                PastSonification()
                    .tag(1)
                    .tabItem{
                        Image(systemName: "folder.fill")
                        Text("Creazioni Passate")
                    }
                    .environment(\.managedObjectContext, dataController)
            }
            .accentColor(Color.blue)
            Miniplayer(animation: animation, expand: $expand)
                .environmentObject(audioManager)
        })
        
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
            .environmentObject(AudioManager())
            .environment(\.managedObjectContext, CoreDataManager().container.viewContext)
    }
}
