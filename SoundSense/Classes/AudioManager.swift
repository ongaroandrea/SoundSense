//
//  AudioManager.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 30/09/22.
//

import Foundation
import AVKit

///https://www.youtube.com/watch?v=Bvep_4H9Kdg
final class AudioManager: ObservableObject {
    
    var player: AVAudioPlayer!
    @Published private(set) var isPlaying: Bool = false {
        didSet {
            print("Is playgin", isPlaying)
        }
    }
    
    @Published private(set) var isLooping: Bool = false {
        didSet {
            print("Is playgin", isLooping)
        }
    }
    
    func startPlayer(track:String){
        
        guard let soundFileURL = Bundle.main.url(
            forResource: track, withExtension: "wav"
        ) else {
            print("Resource not found \(track)")
            return
        }
        
        do {
            // Attempts to activate session so you can play audio,
            // if other sessions have priority this will fail
            let audioSession = AVAudioSession.sharedInstance()
            //default mode only includes audio not involving any recording, video or chat
            try audioSession.setCategory(.playback, mode: .moviePlayback)
            // Attempts to activate session so you can play audio,
            // if other sessions have priority this will fail
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: soundFileURL)
            player?.play()
            isPlaying = true
        } catch let error {
            print("Fail to initialize player", error)
        }
    }
    
    func playPause(){
        guard let player = player else {
            print("")
            return
        }
        
        if player.isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }
    
    func stop(){
        guard let player = player else {
            print("")
            return
        }
        
        if player.isPlaying {
            player.stop()
        }
    }
    
    func toggleLoop(){
        guard let player = player else {
            print("")
            return
        }
        
        player.numberOfLoops = player.numberOfLoops == 0 ? -1 : 0
        isLooping = true
    }
}
