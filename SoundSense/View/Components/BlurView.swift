//
//  BlurView.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 01/10/22.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
