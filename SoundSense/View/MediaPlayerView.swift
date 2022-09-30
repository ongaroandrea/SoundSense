//
//  MediaPlayer.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 30/09/22.
//

import SwiftUI
import HealthKit

struct MediaPlayerView: View {
    @State private var value: Double = 0.0
    @State private var isEditing: Bool = false
    @EnvironmentObject var audioManager: AudioManager
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var track: String
    var obj: HealthDataV2
    
    var body: some View {
        ZStack{
            Image(obj.image)
                .resizable()
                .blur(radius: 20)
                .ignoresSafeArea()
            VStack{
                // MARK: Image
                Image(obj.image)
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
                
                Text(obj.name)
                    .font(.system(.title2))
                    .bold()
                
                // MARK: Playback Timeline
                if let playerT = audioManager.player {
                    VStack(spacing: 10){
                        Slider(value: $value, in: 0...(playerT.duration)) { editing in
                            if !editing {
                                isEditing = true
                                playerT.currentTime = value
                            }
                            
                        }
                        HStack{
                            Text("00:00")
                            
                            Spacer()
                            
                            Text("")
                        }
                        
                        HStack(spacing: 10){
                            Spacer()
                            ButtonPlayer(image: "gobackward.10") {
                                playerT.currentTime -= 10
                            }
                            .font(.system(size: 40))
                            Spacer()
                            ButtonPlayer(image: !audioManager.player.isPlaying ? "play.fill" : "pause"){
                                audioManager.playPause()
                            }
                            .font(.system(size: 40))
                            Spacer()
                            ButtonPlayer(image: "gobackward.10") {
                                playerT.currentTime += 10
                            }
                            .font(.system(size: 40))
                            Spacer()
                        }
                    }
                    .padding(10)
                }
            }
        }
        
        .onAppear(perform: {
            audioManager.startPlayer(track: track)
        })
        .onReceive(timer){ _ in
            guard let player = audioManager.player, !isEditing else {return}
            value = player.currentTime
        }
    }
}

struct MediaPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        MediaPlayerView(track: "chitarra", obj: HealthDataV2(name: "Step Count", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", image: "stepcount", typeIdentifiers: HKQuantityTypeIdentifier.stepCount.rawValue))
            .environmentObject(AudioManager())
    }
}
