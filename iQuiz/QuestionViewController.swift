//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Matthew Ramirez on 5/12/22.
//

import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var answerChoicesBtns: [UIButton]!
    var currentChoice : UIButton?
    var _questionSet : Question? = nil
          
    open var questionSet : Question? {
        get { return self._questionSet }
        set(value) {
            self._questionSet = value
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentChoice = nil
        // Do any additional setup after loading the view.
    }
    
    @IBAction func choiceBtnPressed(_ sender: UIButton) {
        if currentChoice != nil {
            currentChoice!.backgroundColor = UIColor.white
        }
        sender.backgroundColor = UIColor.systemYellow
        currentChoice = sender
    }
    
    func setData(_ next: Question) {
        for qBtn in answerChoicesBtns {
            qBtn.backgroundColor = UIColor.white
        }
        currentChoice = nil
        questionSet = next
        questionLabel.text = questionSet!.Q
        answerChoicesBtns[0].setTitle(questionSet!.C1, for: .normal)
        answerChoicesBtns[1].setTitle(questionSet!.C2, for: .normal)
        answerChoicesBtns[2].setTitle(questionSet!.C3, for: .normal)
        answerChoicesBtns[3].setTitle(questionSet!.A, for: .normal)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
