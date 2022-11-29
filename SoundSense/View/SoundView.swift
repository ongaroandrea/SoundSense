//
//  SoundView.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 30/09/22.
//

import SwiftUI
import CoreData
import HealthKit

struct SoundView: View {
    @State private var selectedInstrument = Instrument.violin
    @State private var selectedLenght = AudioLength.medium
    @State private var showingAlert = false
    
    @ObservedObject var healthData: HealthClass = HealthClass()
    @EnvironmentObject var audioManager: AudioManager
    
    var obj: HealthData
    @Binding var visiblePlayer: Bool
    
    var body: some View {
        VStack(spacing: 0){
            Image(obj.image)
                .resizable()
                .scaledToFill()
                .frame(height: UIScreen.main.bounds.height / 3)
                .opacity(0.8)
            ZStack {
                VStack(alignment: .leading){
                    Text(obj.name)
                        .font(.largeTitle)
                        .textCase(.uppercase)
                        .bold()
                        .padding(.top)
                    Text(obj.description)
                        .bold()
                    
                    VStack{
                            ///https://sarunw.com/posts/how-to-use-swiftui-picker/
                        Text("Scegli lo strumento")
                            .padding(.top)
                           
                        Picker("Scegli lo strumento", selection: $selectedInstrument, content: {
                                ForEach(Instrument.allCases, content: { instrument in
                                    Text(instrument.rawValue.capitalized)
                                    
                                })
                                
                                .textCase(.uppercase)
                                .foregroundColor(.black)
                            })
                            .listRowBackground(Color.clear)
                            .pickerStyle(.segmented)
                       
                        Text("Scegli la lunghezza")
                            .padding(.top)
                        Picker("Scegli la lunghezza", selection: $selectedLenght, content: {
                            ForEach(AudioLength.allCases, content: { audiolength in
                                Text(audiolength.rawValue.capitalized)
                                
                            })
                            
                            .textCase(.uppercase)
                            .foregroundColor(.black)
                        })
                        .listRowBackground(Color.clear)
                        .pickerStyle(.segmented)
                        
                       
                    }
                    Button{
                        //Ottieni i dati
                        Task {
                            var dataT: [DataType] = []
                            if(obj.typeIdentifiers.rawValue == "screenTime"){
                                dataT = getCSVData(path: "Data/app_usage.csv")
                            } else {
                                dataT = await HealthClass().statisticsData(identifier: obj.typeIdentifiers, unit: obj.unit)
                            }
                            
                            
                            //Creo il dato da mandare
                            let data: SendableData = SendableData(instrument: selectedInstrument, length: selectedLenght, data: dataT, type: obj.name, order: obj.order)
                            
                            //controlla nome file
                            let name = FilesManager().checkName(name: "sample")
                            //createFile
                            let responseCre = await Connection().uploadData(uploadData: data, fileManager: FilesManager(), fileURL: name!)
                            
                            if responseCre {
                                visiblePlayer = true
                                print(name!.lastPathComponent)
                                audioManager.name = obj.name
                                audioManager.image = obj.image
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
                if(obj.typeIdentifiers.rawValue != "screenTime"){
                    HealthClass().requestHealthAuthorization()
                }
                UITableView.appearance().backgroundColor = .clear
            }
        }
        .ignoresSafeArea()
    }
}

struct SoundView_Previews: PreviewProvider {
    static var previews: some View {
        SoundView(obj: HealthData(name: "Step Count", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", image: "stepcount", typeIdentifiers: HKQuantityTypeIdentifier.stepCount, order: .desc, unit: .count()), visiblePlayer: .constant(false))
    }
    
    init() {
       UITableView.appearance().separatorStyle = .none
       UITableViewCell.appearance().backgroundColor = .none
       UITableView.appearance().backgroundColor = .none
    }
}

