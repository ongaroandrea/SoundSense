//
//  FullPlayerView.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 25/10/22.
//

import SwiftUI
import AVFAudio

struct FullPlayerView: View {
    @EnvironmentObject var audioManager: AudioManager
    @State private var isEditing: Bool = false
    @State private var value: Double = 0.0
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    var player: AVAudioPlayer!
    
    var body: some View {
        ZStack{
            Image("stepcount")
                .resizable()
                .blur(radius: 20)
            
            VStack{
                Spacer()
                Image("stepcount")
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
                
                Text("stepcount")
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
}

struct FullPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        FullPlayerView()
    }
}
