//
//  Connection.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 30/09/22.
//
//https://www.kairadiagne.com/2020/01/13/nssecurecoding-and-transformable-properties-in-core-data.html
import Foundation

///https://developer.apple.com/documentation/foundation/url_loading_system/uploading_data_to_a_website
final class Connection: ObservableObject {
    
    private var server_url: String = "http://192.168.178.182:5000/"
    @Published var content: [RecevingData] = [
        RecevingData(id: 1, name: "", file_type: "Conteggio passi", order: .desc, instrument: .basso, length: .lunga, created_at: "12-11-2022"),
        RecevingData(id: 2, name: "", file_type: "Utilizzo dispositivo", order: .desc, instrument: .basso, length: .lunga, created_at: "14-11-2022"),
        RecevingData(id: 3, name: "", file_type: "Battito cardiaco passi", order: .desc, instrument: .basso, length: .lunga, created_at: "15-11-2022"),
        RecevingData(id: 4, name: "", file_type: "Conteggio passi", order: .desc, instrument: .basso, length: .lunga, created_at: "12-11-2022")
    ]
    
    func uploadData(uploadData: SendableData, fileManager: FilesManager, fileURL: URL) async -> Bool{
        guard let uploadData = try? setDifferentEncoderForData().encode(uploadData) else {
            return false
        }
        let url = URL(string: self.server_url + "audio/new")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("34234234", forHTTPHeaderField: "access-token")
        request.httpBody = uploadData
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            if(verifyResponse(data: data, response: response)){
                print ("got data: \(data)")
                fileManager.writeToFile(data: data, fileurl: fileURL)
                return true
            } else {
                return false
            }
        } catch {
            print(error)
            return false
        }
    }
    
    func downloadAudio(id: Int, fileManager: FilesManager, fileURL: URL) async -> Bool{
        let url = URL(string: self.server_url + "audio/" + String(id))!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("34234234", forHTTPHeaderField: "access-token")
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            if(verifyResponse(data: data, response: response)){
                print ("got data: \(data)")
                fileManager.writeToFile(data: data, fileurl: fileURL)
                return true
            } else {
                return false
            }
        } catch {
            print(error)
            return false
        }
    }
    
    func getPreviousData() {
        let url = URL(string: self.server_url + "audio/all")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("34234234", forHTTPHeaderField: "access-token")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print(data)
                if let response = try? JSONDecoder().decode([RecevingData].self, from: data) {
                    DispatchQueue.main.async {
                        print(response)
                        self.content = response
                    }
                return
                }
            }
        }.resume()
    }
    
    func deleteFile(id: Int){
        let url = URL(string: self.server_url + "audio/" + String(id))!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("34234234", forHTTPHeaderField: "access-token")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print(data)
                if let response = try? JSONDecoder().decode([String].self, from: data) {
                    print(response)
                    return
                }
            }
        }.resume()
    }
    ///https://tapadoo.com/swift-json-date-formatting/
    func setDifferentEncoderForData() -> JSONEncoder{
        let enc = JSONEncoder()
            enc.outputFormatting = [.prettyPrinted , .sortedKeys]
        enc.dateEncodingStrategy = .secondsSince1970
        return enc
    }
    

}

private func verifyResponse(data: Data, response: URLResponse) -> Bool {
    guard let httpResponse = response as? HTTPURLResponse else {
        return false
    }
    
    switch httpResponse.statusCode {
        case 200...299:
            return true
        case 400...499:
            return false
        case 500...599:
            return false
        default:
            return false
    }
}

///https://saeedrz.medium.com/api-call-with-urlsession-async-await-91b3c09834fd
enum APIError: Error {
    case badRequest
    case serverError
    case unknown
}

