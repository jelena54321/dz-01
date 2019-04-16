//
//  LoginService.swift
//  iOSVjestina2019
//
//  Created by Jelena Šarić on 05/04/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation

/// Class which provides session establishment with server.
class LoginService {
    
    /**
     Establishes session with server on provided url source.
     
     - Parameters:
        - urlString: string representation of url source
        - username: username which will be used for session establishment
        - password: password which will be used for session establishment
        - onComplete: action which will be executed once fetch is finished
     */
    func establishSession(urlString: String, username: String, password: String, onComplete: @escaping ((String?) -> Void)) {
        
        if let url = URL(string: urlString) {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = "username=\(username)&password=\(password)".data(using: .utf8)
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let unwrappedData = data {
                
                    do {
                        let json = try JSONSerialization.jsonObject(
                            with: unwrappedData,
                            options: []
                        )
                        
                        onComplete(LoginService.parseToken(json: json))
                    } catch {
                        onComplete(nil)
                    }
                } else {
                    onComplete(nil)
                }
            }
            
            dataTask.resume()
        } else {
            onComplete(nil)
        }
    }
    
    /**
     Parses provided *json* as string associated with key 'token'
     
     - Parameters:
        - json: - json: *json* object which represents access token
     
     - Returns: string stored in *json* object if such string exists,
     otherwise *nil*
    
    */
    static func parseToken(json: Any) -> String? {
        if let jsonDictionay = json as? [String: Any],
           let token = jsonDictionay["token"] as? String {
            return token
        }
        
        return nil
    }
}
