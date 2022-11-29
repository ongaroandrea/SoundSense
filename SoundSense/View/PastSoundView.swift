//
//  OldPastView.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 01/11/22.
//

import SwiftUI

struct PastSoundView: View {
    @ObservedObject var healthData: HealthClass = HealthClass()
    @EnvironmentObject var audioManager: AudioManager
    @State private var showingAlert = false
    
    var obj: RecevingData
    @Binding var visiblePlayer: Bool
    
    var body: some View {
        VStack(spacing: 0){
            Image("sample_image")
                .resizable()
                .scaledToFill()
                .frame(height: UIScreen.main.bounds.height / 3)
                .opacity(0.8)
            ZStack {
                VStack(alignment: .leading){
                    Text(obj.file_type)
                        .font(.largeTitle)
                        .textCase(.uppercase)
                        .bold()
                        .padding(.top)
                    Text("Data di creazione: \(convertDate(date: obj.created_at))")
                        .bold()
                    
                    Text("Strumento scelto: \(obj.instrument.rawValue)")
                        .bold()
                    
                    Text("Ordine scelto: \(obj.order.rawValue)")
                        .bold()
                    
                    Text("Lunghezza scelta: \(obj.length.rawValue)")
                        .bold()
                    
                    Button{
                        //Ottieni i dati
                        Task {
                            //controlla nome file
                            let name = FilesManager().checkName(name: "sample")
                            //createFile
                            let responseCre = await Connection().downloadAudio(id: obj.id, fileManager: FilesManager(), fileURL: name!)
                            
                            if responseCre {
                                visiblePlayer = true
                                print(name!.lastPathComponent)
                                audioManager.name = obj.name
                                audioManager.image = "sample_image"
                                audioManager.track = name!.lastPathComponent
                                audioManager.soundFileURL = name!
                                audioManager.startPlayer()
                            } else {
                                print("Errore")
                                showingAlert = true
                            }
  
                        }
                    } label: {
                        Label("Riproduci Brano", systemImage: "play.fill")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                            .padding(15)
                            .frame(maxWidth: .infinity) //diventa grande quanto il padre
                            .background(.black)
                            .cornerRadius(20)
                    }
                    .padding(.top)
                    .alert("Errore. Riprovare", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    }
                    
                    
                    Spacer()
                }
                .font(.subheadline)
                
                .padding(10)
                
            }
            .frame(height: UIScreen.main.bounds.height * 2 / 3)
            .onAppear() {
                UITableView.appearance().backgroundColor = .clear
            }
        }
        .ignoresSafeArea()
    }
}

struct PastSoundView_Previews: PreviewProvider {
    static var previews: some View {
        PastSoundView(obj: RecevingData(created_at: "", file_type: "", id: 1, instrument: .bass, length: .medium, name: "", order: .desc),  visiblePlayer: .constant(false))
    }
}

func convertDate(date: String) -> Date{
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return dateFormatter.date(from:date)!
}
