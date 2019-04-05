//
//  Quiz.swift
//  iOSVjestina2019
//
//  Created by Jelena Šarić on 03/04/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation

/// Class which represents quiz.
class Quiz {
    
    /// Quiz id.
    let id: Int
    /// Quiz title.
    let title: String
    /// Quiz description.
    let description: String?
    /// Quiz category.
    let category: Category
    /// Quiz level.
    let level: Int
    /// Quiz image.
    let image: String?
    /// Array of quiz questions.
    let questions: [Question]
    
    /**
     Initializes a new **Quiz** object using provided *json* object.
     
     - Parameters:
        - json: *json* object which represents quiz
     
     - Returns: a new **Quiz** object if parameters in provided *json* object
     can be interpreted as quiz parameters, otherwise *nil*.
    */
    init?(json: Any) {
        if let jsonDictionary = json as? [String: Any],
           let id = jsonDictionary["id"] as? Int,
           let title = jsonDictionary["title"] as? String,
           let category = jsonDictionary["category"] as? String,
           let level = jsonDictionary["level"] as? Int,
           let questions = jsonDictionary["questions"] as? [Any] {
    
            self.id = id
            self.title = title
            self.description = jsonDictionary["description"] as? String
            self.level = level
            self.image = jsonDictionary["image"] as? String
            
            if let unwrappedQuestions = Quiz.parseQuestions(json: questions),
               let unwrappedCategory = Category(rawValue: category) {
                self.questions = unwrappedQuestions
                self.category = unwrappedCategory
            } else {
                return nil
            }
            
        } else {
            return nil
        }
    }
    
    /**
     Parses provided *json* object into **Question** array.
     
     - Parameters:
        - json: *json* object which represents questions
     
     - Returns: a new **Question** array if provided data can be interpreted as
     such, otherwise *nil*.
     */
    static func parseQuestions(json: [Any]) -> [Question]? {
        var questions = [Question]()
        for question in json {
            if let unwrappedQuestion = Question(json: question) {
                questions.append(unwrappedQuestion)
            } else {
                return nil
            }
        }
        
        return questions
    }
}
