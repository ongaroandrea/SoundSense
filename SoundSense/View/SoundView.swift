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
    @State private var selectedLenght = AudioLenght.medium
    
    @ObservedObject var healthData: HealthClass = HealthClass()
    @Environment(\.managedObjectContext) var managedObjController
    @EnvironmentObject var audioManager: AudioManager
    
    var obj: HealthDataV2
    
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
                            ForEach(AudioLenght.allCases, content: { audiolenght in
                                Text(audiolenght.rawValue.capitalized)
                                
                            })
                            
                            .textCase(.uppercase)
                            .foregroundColor(.black)
                        })
                        .listRowBackground(Color.clear)
                        .pickerStyle(.segmented)
                        
                       
                    }
                    Button{
                        //Ottieni i dati
                        let threeMonthsAgo = DateComponents(month: -3)
                        
                        guard let startDate = Calendar.current.date(byAdding: threeMonthsAgo, to: Date()) else {
                            fatalError("*** Unable to calculate the start date ***")
                        }
                       
                        Task {
                            let dataT = await HealthClass().getSampleData(startDate: startDate, endDate: Date(), identifier: .stepCount)
                            
                            //Creo il dato da mandare
                            let data: SendableData = SendableData(instrument: selectedInstrument, lenght: selectedLenght, data: dataT)
                            
                            //controlla nome file
                            let name = FilesManager().checkName(name: "sample")
                            //createFile
                            let responseCre = await Connection().uploadData(uploadData: data, fileManager: FilesManager(), fileURL: name!)
                            
                            //add File to DB
                            //CoreDataManager().addFile(id: UUID(), name: name!.lastPathComponent, description: obj.description, file_name: "", data: data, context: managedObjController)
                            
                            //Riproduci Audio
                            if(responseCre){
                                MediaPlayerView(track: name!.absoluteString, obj: obj)
                                    .environmentObject(audioManager)
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

struct SoundView_Previews: PreviewProvider {
    static var previews: some View {
        SoundView(obj: HealthDataV2(name: "Step Count", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", image: "stepcount", typeIdentifiers: HKQuantityTypeIdentifier.stepCount.rawValue))
    }
    
    init() {
       UITableView.appearance().separatorStyle = .none
       UITableViewCell.appearance().backgroundColor = .none
       UITableView.appearance().backgroundColor = .none
    }
}

