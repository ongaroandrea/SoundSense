//
//  Button.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 30/09/22.
//

import SwiftUI

struct ButtonPlayer: View {
    var image: String
    var action: () -> Void
    
    var body: some View {
        Button{
            action()
        } label: {
            Image(systemName: image)
                .foregroundColor(.black)
        }
    }
}

struct Button_Previews: PreviewProvider {
    static var previews: some View {
        ButtonPlayer(image: "play", action: {})
    }
}
