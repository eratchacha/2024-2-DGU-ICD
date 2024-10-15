//
//  ContentView.swift
//  http_request
//
//  Created by 차차 on 10/15/24.
//

import SwiftUI

struct ContentView: View {
    @State private var message = "message"
    @State private var responseMessage = ""
    
    var body: some View {
        VStack {
            Button("Send to Server") {
                sendMessageToServer(message: message)
            }
            .padding()
            
            Text("Response from server: \(responseMessage)")
                .padding()
        }
        .padding()
    }
    
    func sendMessageToServer(message: String) {
        guard let url = URL(string: "http://127.0.0.1:3000/send-message") else {
            print("Invalid URL")
            return
        }

        let parameters = [
            "message": message,
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Failed to serialize JSON")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending request: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    responseMessage = responseString
                }
                print("Response from server: \(responseString)")
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}
