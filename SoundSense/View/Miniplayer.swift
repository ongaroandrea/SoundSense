//
//  Miniplayer.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 01/10/22.
//

import SwiftUI

struct Miniplayer: View {
    var animation: Namespace.ID
    @Binding var expand: Bool
    
    var body: some View {
        VStack{
            
            HStack(spacing: 15){
                Image("stepcount")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .cornerRadius(15)
                
                Text("I Got you (frat. Jax Jon.....)")
                    .font(.headline)
                
                Spacer(minLength: 0)
                    
                ButtonPlayer(image: "play.fill", action: {})
                    .font(.system(.title2))
            }
            .padding(.leading, 20)
            .padding(.trailing, 40)
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


