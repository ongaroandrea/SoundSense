//
//  CreateNavigationView.swift
//  test
//
//  Created by Andrea  Ongaro on 03/04/22.
//

import SwiftUI

struct CreateNotificationView: View {
    @ObservedObject var notificationManager: NotificationManager
    @State private var title = ""
    @State private var date = Date()
    @Binding var isPresented: Bool
    @Binding var error: Bool
    @State var valueDay = "Lunedì"
    @State var idDay: Int = 1
    
    var dropDownList = [
        DropdownOption(id: 2, value: "Lunedì"),
        DropdownOption(id: 3, value: "Martedì"),
        DropdownOption(id: 4, value: "Mercoledì"),
        DropdownOption(id: 5, value: "Giovedì"),
        DropdownOption(id: 6, value: "Venerdì"),
        DropdownOption(id: 7, value: "Sabato"),
        DropdownOption(id: 1, value: "Domenica")
    ]
    
    var body: some View {
        List {
            Section {
                VStack(spacing: 16) {
                    VStack{
                        Text("Aggiungi un promemoria")
                            .font(.title)
                            .bold()
                        
                        HStack{
                            Text("Scegli il giorno")
                            
                            Menu {
                                
                                ForEach(dropDownList, id: \.self) { drop in
                                    Button(drop.value) {
                                        valueDay = drop.value
                                        idDay = drop.id
                                    }
                                }
                            } label: {
                                HStack{
                                    Spacer()
                                    VStack(spacing: 5) {
                                        HStack {
                                            Text(valueDay.isEmpty ? "placeholder" : valueDay)
                                                .foregroundColor(valueDay.isEmpty ? .black : .black)
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .font(Font.system(size: 20, weight: .bold))
                                                .foregroundColor(.black)
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                            .padding(15)
                            .cornerRadius(5)
                            .background(.white.opacity(0))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                        }
                        .padding(.horizontal)
                        //Text("Your current date is \(valueDay)")
                        
                        DatePicker("Scegli l'orario", selection: $date, displayedComponents: [.hourAndMinute])
                            .padding(.horizontal)
                            .datePickerStyle(.graphical)
                            .background(.white)
                    }
                    
                    Button {
                        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
                        notificationManager.createLocalNotification( title: "Sonificazione", hour: dateComponents.hour!, minute: dateComponents.minute!, weekDay: idDay) { error in
                            if error == nil {
                                DispatchQueue.main.async {
                                    self.isPresented = false
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.error = true
                                    print("error")
                                }
                            }
                        }
                    } label: {
                        
                        Text("Aggiungi")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                            .padding(15)
                            .frame(maxWidth: .infinity) //diventa grande quanto il padre
                            .background(.black)
                            .cornerRadius(20)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .onDisappear {
            notificationManager.reloadLocalNotifications()
        }
        .navigationBarItems(trailing: Button {
            isPresented = false
        } label: {
            Image(systemName: "xmark")
                .imageScale(.large)
        })
    }
}


struct CreateNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNotificationView(
            notificationManager: NotificationManager(),
            isPresented: .constant(false),
            error: .constant(false)
        )
    }
}

struct DropdownOption: Identifiable, Hashable {
    let id: Int
    let value: String
}
