//
//  SingleView.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 01/10/22.
//

import SwiftUI

struct SingleView: View {
    var image: String
    var nome: String
    var body: some View {
        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: (UIScreen.main.bounds.width - 50 ) , height: 100)
            
            
            .overlay(alignment: .bottom, content: {
                Rectangle()
                    .fill(Color.black)
                    .shadow(radius: 8)
                    .opacity(0.15)
                    .overlay(content: {
                          Text(nome)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
               })
            })
            .cornerRadius(15)
            .padding(.horizontal)
         
    }
}

struct SingleView_Previews: PreviewProvider {
    static var previews: some View {
        SingleView(image: "flights", nome: "Flights")
    }
}
