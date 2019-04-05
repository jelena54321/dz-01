//
//  QuizService.swift
//  iOSVjestina2019
//
//  Created by Jelena Šarić on 03/04/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation

/// Class which provides acquiring **Quiz** array from server.
class QuizService {
    
    /**
     Fetches **Quiz** array in *json* format.
     
     - Parameters:
        - urlString: string representation of url source
        - onComplete: action which will be executed once fetch is finished
    */
    func fetchQuizzes(urlString: String, onComplete: @escaping (([Quiz]?) -> Void)) {
        if let url = URL(string: urlString) {
            
            let request = URLRequest(url: url)
            let dataTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
                if let unwrappedData = data {
                    do {
                        let json = try JSONSerialization.jsonObject(
                            with: unwrappedData,
                            options: []
                        )
                        
                        onComplete(QuizService.parseQuizzes(json: json))
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
     Parses provided *json* object into **Quiz** array.
     
     - Parameters:
        - json: *json* object which represents quizzes
     
     - Returns: a new **Quiz** array if provided data can be interpreted as
     such, otherwise *nil*.
    */
    static func parseQuizzes(json: Any) -> [Quiz]? {
        if let jsonDictionary = json as? [String: Any],
           let quizzes = jsonDictionary["quizzes"] as? [Any] {
            
            var quizArray = [Quiz]()
            for quiz in quizzes {
                if let unwrappedQuiz = Quiz(json: quiz) {
                    quizArray.append(unwrappedQuiz)
                } else {
                    return nil
                }
            }
            
            return quizArray
        }
        
        return nil
    }
    
}
