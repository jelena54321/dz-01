//
//  QuizViewController.swift
//  iOSVjestina2019
//
//  Created by Jelena Šarić on 01/04/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import UIKit

/// Class which presents view controller for Quiz interface.
class QuizViewController : UIViewController {
    
    /// Quiz source url.
    static let quizUrl = "https://iosquiz.herokuapp.com/api/quizzes"
    /// Error message.
    static let errorMessage = "Neupješan dohvat sa servera!"
    
    /// Information label.
    @IBOutlet weak var infoLabel: UILabel!
    /// Fun Fact label.
    @IBOutlet weak var funFactLabel: UILabel!
    /// Quiz title label.
    @IBOutlet weak var quizTitleLabel: UILabel!
    /// Quiz image.
    @IBOutlet weak var quizImage: UIImageView!
    /// Question view container.
    @IBOutlet weak var questionViewContainer: UIView!
    
    /// Current quiz ID.
    var quizId: Int?
    
    /**
     Fetches quizzes from server and updates views in view hierarchy.
    */
    @IBAction func fetchButtonTapped() {
        QuizService().fetchQuizzes(
            urlString: QuizViewController.quizUrl,
            onComplete: { (quizzes) in
                
                if let quizzes = quizzes {
                    DispatchQueue.main.async {
                        self.infoLabel.isHidden = true
                    }
                    
                    self.updateFunFact(quizzes: quizzes)
                    self.updateBasicQuizInfo(quizzes: quizzes)
                    self.displayQuestion(quizzes: quizzes)
                    
                } else {
                    DispatchQueue.main.async {
                        self.infoLabel.isHidden = false
                        self.infoLabel.text = QuizViewController.errorMessage
                    }
                }
        })
    }
    
    /**
     Removes access token from **UserDefaults** object.
    */
    @IBAction func logoutButtonTapped() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
    }
    
    /**
     Updates 'Fun Fact' label with frequency of string 'NBA' in quiz questions.
     
     - Parameters:
        - quizzes: quizzes array
    */
    func updateFunFact(quizzes: [Quiz]) {
        let NBACount = quizzes.flatMap { (quiz) -> [Question] in
            quiz.questions
        }.filter { (question) -> Bool in
            question.question.contains("NBA")
        }.count
        
        DispatchQueue.main.async {
             self.funFactLabel.text = String(NBACount)
        }
        
    }
    
    /**
     Updates basic information section with current quiz title and associated
     image if image url is provided.
     
     - Parameters:
        - quizzes: quizzes array
    */
    func updateBasicQuizInfo(quizzes: [Quiz]) {
        guard let randomQuiz = quizzes.randomElement() else {
            return
        }
    
        self.quizId = randomQuiz.id
        if let imageUrl = randomQuiz.image {
            ImageService().fetchImage(urlString: imageUrl, onComplete: { (image) in
                if let unwrappedImage = image {
                    DispatchQueue.main.async {
                        self.quizImage.isHidden = false
                        self.quizImage.image = unwrappedImage
                        self.quizImage.backgroundColor = randomQuiz.category.color
                    }
                }
            })
        }
        
        DispatchQueue.main.async {
            self.quizTitleLabel.isHidden = false
            self.quizTitleLabel.text = randomQuiz.title
            self.quizTitleLabel.backgroundColor = randomQuiz.category.color
        }
    }
    
    /**
     Displays **QuestionView** with current quiz question and associated answers.
     
     - Parameters:
        - quizzes: quizzes array
    */
    func displayQuestion(quizzes: [Quiz]) {
        guard let randomQuestion = quizzes[quizId! - 1].questions.randomElement() else {
            return
        }
       
        DispatchQueue.main.async {
            self.addQuestionView()
            
            if let questionView = self.questionViewContainer.subviews.first as? QuestionView,
               let answerButtons = questionView.answerButtons {
                
                questionView.question = randomQuestion
                answerButtons.forEach({ (button) in
                    button.backgroundColor = UIColor.lightGray
                })
            }
        }
    }
    
    /**
     Adds **QuestionView** to view hierarchy if such object has not been previously added.
    */
    func addQuestionView() {
        if self.questionViewContainer.subviews.first != nil {
            return
        }
        
        let questionView = QuestionView(
            frame: CGRect(
                origin: CGPoint(x: 0, y: 0),
                size: CGSize(width: 299, height: 200)
            )
        )
        
        if let answerButtons = questionView.answerButtons {
            answerButtons.forEach { (button) in
                button.addTarget(
                    self,
                    action: #selector(QuizViewController.evaluateResult),
                    for: UIControl.Event.touchUpInside
                )
            }
        }
        self.questionViewContainer.addSubview(questionView)
        
        
    }
    
    /**
     Evaluates result by changing tapped button to appropriate colour.
    */
    @objc func evaluateResult(_ sender: UIButton) {
        self.refreshAnswerButtons()
        
        guard let questionView = questionViewContainer.subviews.first as? QuestionView,
              let question = questionView.question else {
            
            return
        }
        
        let correctAnswerIndex = question.correctAnswer
        let correctAnswer = question.answers[correctAnswerIndex]
        
        let backgroundColor = sender.currentTitle! == correctAnswer ?
            UIColor.green : UIColor.red
        sender.backgroundColor = backgroundColor
    }
    
    /**
     Sets default colour as background colour to all answer buttons in **QuestionView**.
    */
    func refreshAnswerButtons() {
        guard let questionView = questionViewContainer.subviews.first as? QuestionView,
              let answerButtons = questionView.answerButtons else {
            return
        }
        
        answerButtons.forEach { (button) in
            button.backgroundColor = UIColor.lightGray
        }
    }
    
}
