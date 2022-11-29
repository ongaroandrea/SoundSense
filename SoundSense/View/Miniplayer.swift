//
//  Miniplayer.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 01/10/22.
//

import SwiftUI
import HealthKit

struct Miniplayer: View {
    var animation: Namespace.ID
    @Binding var expand: Bool
    
    @State private var value: Double = 0.0
    @State private var isEditing: Bool = false
    @EnvironmentObject var audioManager: AudioManager
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    var track: String
    
    var body: some View {
        VStack{
            if(!expand) {
                    HStack(spacing: 15){
                        Image(audioManager.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 45, height: 45)
                            .cornerRadius(15)
                        
                        Text(audioManager.track != "" ? audioManager.name : "Nessun audio in riproduzione")
                            .font(.headline)
                        
                        Spacer(minLength: 0)
                        if let playerT = audioManager.player {
                            ButtonPlayer(image: playerT.isPlaying ? "pause.fill" : "play.fill"){
                                if audioManager.track != "" {
                                    audioManager.playPause()
                                }
                            }
                            .font(.system(.title2))
                        }
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 40)
            } else {
                ZStack{
                    VStack{
                            Capsule()
                                .fill(Color.gray)
                                .frame(width: 60, height: 4)
                                .padding(.top, 50)
                                .padding(.vertical, 30)
                                .opacity(1)
                        Spacer()
                            // MARK: Image
                        if let player = audioManager.player {
                            if audioManager.track != "" {
                                ZStack{
                                    Image(audioManager.image)
                                        .resizable()
                                        .blur(radius: 20)
                                    
                                    VStack{
                                        Spacer()
                                        Image(audioManager.image)
                                            .resizable()
                                            .frame(width: 200, height: 200, alignment: .center)
                                        
                                        Text(audioManager.image)
                                            .font(.system(.title2))
                                            .bold()
                                        
                                        // MARK: Playback Timeline
                                        
                                        VStack(spacing: 10){
                                            Slider(value: $value, in: 0...(player.duration)) { editing in
                                                if !editing {
                                                    isEditing = true
                                                    player.currentTime = value
                                                }
                                                
                                            }
                                            HStack{
                                                Text(DateComponentsFormatter.positional.string(from: player.currentTime) ?? "0:00")
                                                
                                                Spacer()
                                                
                                                Text(DateComponentsFormatter.positional.string(from: player.duration) ?? "0:00")
                                            }
                                            
                                            HStack(spacing: 10){
                                                Spacer()
                                                ButtonPlayer(image: "gobackward.10") {
                                                    player.currentTime -= 10
                                                }
                                                .font(.system(size: 40))
                                                Spacer()
                                                ButtonPlayer(image: !audioManager.player.isPlaying ? "play.fill" : "pause"){
                                                    audioManager.playPause()
                                                }
                                                .font(.system(size: 40))
                                                Spacer()
                                                ButtonPlayer(image: "gobackward.10") {
                                                    player.currentTime += 10
                                                }
                                                .font(.system(size: 40))
                                                Spacer()
                                            }
                                        }
                                        .padding(10)
                                        Spacer()
                                    }
                                }
                            }
                        } else {
                            Image("noalbum")
                                .resizable()
                                .frame(width: 200, height: 200, alignment: .center)
                                .padding(.bottom, 20)
                            Text("Nessun audio in riproduzione")
                                .font(.system(.title2))
                                .bold()
                                .padding(.bottom, UIScreen.main.bounds.height / 3)
                            Spacer()
                        }
                    }
                        
                }
                .frame(maxWidth: .infinity)
            }
            
        }
        .onReceive(timer){ _ in
            guard let player = audioManager.player, !isEditing else {return}
            value = player.currentTime
        }
        .frame(maxHeight: expand ? .infinity : 65)
        .background(
            VStack(spacing: 0){
                BlurView()
                Divider()
            }
                .onTapGesture(perform: {
                    withAnimation(.spring()){
                        expand.toggle()
                    }
                })
                
        )
        .ignoresSafeArea()
        .offset(y: expand ? 0 : -48)
    }
}


struct Miniplayer_Previews: PreviewProvider {
    
    //intermediate view to add @Namespace var
    struct TestView: View {
            @Namespace var animation
            var body: some View {
                Miniplayer(animation: animation, expand: .constant(true), track: "sonificazione")
                    .environmentObject(AudioManager())
            }
        }
    
    static var previews: some View {
        TestView()
            .environmentObject(AudioManager())
    }
}
