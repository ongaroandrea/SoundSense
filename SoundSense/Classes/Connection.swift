//
//  Connection.swift
//  SoundSense
//
//  Created by Andrea  Ongaro on 30/09/22.
//
//https://www.kairadiagne.com/2020/01/13/nssecurecoding-and-transformable-properties-in-core-data.html
import Foundation

///https://developer.apple.com/documentation/foundation/url_loading_system/uploading_data_to_a_website
final class Connection {
    
    private var server_url: String = "http://127.0.0.1:5000/test2"
    
    
    func uploadData(uploadData: SendableData, fileManager: FilesManager, fileURL: URL) async -> Bool{
        guard let uploadData = try? JSONEncoder().encode(uploadData) else {
            return false
        }
        let url = URL(string: self.server_url)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = uploadData
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            if(verifyResponse(data: data, response: response)){
                print ("got data: \(data)")
                fileManager.writeToFile(data: data, fileurl: fileURL)
            }
           return true
        } catch {
            print(error)
            return false
        }
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

