//
//  QuestionView.swift
//  iOSVjestina2019
//
//  Created by Jelena Šarić on 04/04/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import UIKit

/// View which represents question with associated answers.
class QuestionView: UIView {
    
    /// Question label.
    var questionLabel: UILabel?
    /// Array of answer buttons.
    var answerButtons: [UIButton]?
    /// Question.
    var question: Question? {
        willSet {
            questionLabel?.text = newValue?.question
            answerButtons?[0].setTitle(newValue?.answers[0], for: .normal)
            answerButtons?[1].setTitle(newValue?.answers[1], for: .normal)
            answerButtons?[2].setTitle(newValue?.answers[2], for: .normal)
            answerButtons?[3].setTitle(newValue?.answers[3], for: .normal)
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFields()
    }
    
    convenience init(frame: CGRect, question: Question) {
        self.init(frame: frame)
        self.question = question
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFields()
    }
    
    convenience init?(coder aDecoder: NSCoder, question: Question) {
        self.init(coder: aDecoder)
        self.question = question
    }
    
    func initFields() {
        questionLabel = UILabel(
            frame: CGRect(
                origin: CGPoint(x: 0, y: 0),
                size: CGSize(width: 299, height: 55)
            )
        )
        questionLabel?.backgroundColor = UIColor.darkGray
        questionLabel?.numberOfLines = 0
        questionLabel?.textColor = UIColor.white
        questionLabel?.textAlignment = NSTextAlignment.center
        if let unwrappedQuestionLabel = questionLabel {
            addSubview(unwrappedQuestionLabel)
        }
        
        answerButtons = [UIButton]()
        for i in 0...3 {
            let button = UIButton(
                frame: CGRect(
                    origin: CGPoint(x: 0, y: 58 + 34 * i),
                    size: CGSize(width: 299, height: 32)
                )
            )
            button.backgroundColor = UIColor.lightGray
            button.setTitleColor(UIColor.white, for: .normal)
            answerButtons?.append(button)
            addSubview(button)
        }
        
    
    }
    
}
