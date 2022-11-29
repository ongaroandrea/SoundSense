//
//  Settings.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 25/10/22.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var notificationManager = NotificationManager()
    @State private var isCreatePresented = false
    @State private var error = false
    
    static var notificationDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
            
    private func timeDisplayText(from notification: UNNotificationRequest) -> String {
        guard let nextTriggerDate = (notification.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate() else { return "" }
        return Self.notificationDateFormatter.string(from: nextTriggerDate)
    }

    @ViewBuilder
            var infoOverlayView: some View {
                switch notificationManager.authorizationStatus {
                case .authorized:
                    if notificationManager.notifications.isEmpty {
                        InfoOverlayView(
                            infoMessage: "Nessun promemoria",
                            buttonTitle: "Crea",
                            systemImageName: "plus.circle.fill",
                            action: {
                                isCreatePresented = true
                            }
                        )
                    }
                case .denied:
                    InfoOverlayView(
                        infoMessage: "Non ho i permessi",
                        buttonTitle: "Impostazioni",
                        systemImageName: "gear",
                        action: {
                            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                    )
                default:
                    EmptyView()
                }
            }
            
    var body: some View {
        NavigationStack{
            List {
                ForEach(notificationManager.notifications, id: \.identifier) { notification in
                    HStack {
                        Text(notification.content.title)
                            .fontWeight(.semibold)
                        Text(timeDisplayText(from: notification))
                            .fontWeight(.bold)
                        Spacer()
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Promemoria")
            .listStyle(.plain)
            .overlay(infoOverlayView)
            .onAppear(perform: notificationManager.reloadAuthorizationStatus)
            .onAppear(perform: {
                UITableView.appearance().backgroundColor = .clear
            })
            
            .onChange(of: notificationManager.authorizationStatus) { authorizationStatus in
                switch authorizationStatus {
                case .notDetermined:
                    notificationManager.requestAuthorization()
                case .authorized:
                    notificationManager.reloadLocalNotifications()
                default:
                    break
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                notificationManager.reloadAuthorizationStatus()
            }
            .navigationBarItems(trailing: Button {
                isCreatePresented = true
            } label: {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
            })
            .sheet(isPresented: $isCreatePresented) {
                NavigationStack {
                    CreateNotificationView(
                        notificationManager: notificationManager,
                        isPresented: $isCreatePresented, error: $error
                    )
                }
            }
        }
    }
}

extension SettingsView {
    func delete(_ indexSet: IndexSet) {
        notificationManager.deleteLocalNotifications(
            identifiers: indexSet.map { notificationManager.notifications[$0].identifier }
        )
        notificationManager.reloadLocalNotifications()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
