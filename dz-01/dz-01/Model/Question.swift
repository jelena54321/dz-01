//
//  Question.swift
//  iOSVjestina2019
//
//  Created by Jelena Šarić on 03/04/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation

/// Class which represents question.
class Question {
    
    /// Question id.
    let id: Int
    /// Question content.
    let question: String
    /// List of answers.
    let answers: [String]
    /// Correct answer.
    let correctAnswer: Int
    
    /**
     Initializes a new **Question** object using provided *json* object.
     
     - Parameters:
        - json: *json* object which represents question
     
     - Returns: a new **Question** object if parameters in provided *json* object
     can be interpreted as question parameters, otherwise *nil*.
     */
    init?(json: Any) {
        if let jsonDictionary = json as? [String: Any],
           let id = jsonDictionary["id"] as? Int,
           let question = jsonDictionary["question"] as? String,
           let answers = jsonDictionary["answers"] as? [String],
           let correctAnswer = jsonDictionary["correct_answer"] as? Int {
            
            self.id = id
            self.question = question
            self.answers = answers
            self.correctAnswer = correctAnswer
        } else {
            return nil
        }
    }
}
