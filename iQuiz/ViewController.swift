//
//  ViewController.swift
//  iQuiz
//
//  Created by Matthew Ramirez on 5/9/22.
//

import UIKit

class Question {
    var Q: String
    var C1: String
    var C2: String
    var C3: String
    var A: String
    
    init(Question: String, Choice1: String, Choice2: String, Choice3: String, Answer: String) {
        Q = Question
        C1 = Choice1
        C2 = Choice2
        C3 = Choice3
        A = Answer
    }
}

/*------------------------------------------------------------------------*/

class ViewController: UIViewController {
    var questionVC: QuestionViewController? = nil
    var answerVC: AnswerViewController? = nil
    var finishedVC: FinishedViewController? = nil
    var tableDataAndDelegate = TableDataAndDelegate()
    public static var questionSet = 0
    var currQuestion = 0
    var score = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitAndNextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if (tableView == nil) {
            buildQuestionVC()
            buildAnswerVC()
            buildFinishVC()
            switchViewController(nil, to: questionVC)
        } else {
            tableDataAndDelegate.vc = self
            tableView.dataSource = tableDataAndDelegate
            tableView.delegate = tableDataAndDelegate
        }
    }
    
    
    @IBAction func settingsBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
/*------------------------------------------------------------------------*/
    
    @IBAction func switchNextVC(_ sender: Any) {
        UIView.beginAnimations("View Flip", context: nil)
        UIView.setAnimationDuration(0.4)
        UIView.setAnimationCurve(.easeInOut)
        
        if questionVC != nil && questionVC!.view.superview != nil {
            UIView.setAnimationTransition(.flipFromRight, for: view, cache: true)
            answerVC!.view.frame = self.view.frame
            submitAndNextBtn.setTitle("Next", for: .normal)
            switchViewController(questionVC, to: answerVC)
            if questionVC?.currentChoice?.titleLabel?.text == TableDataAndDelegate.questions[ViewController.questionSet][currQuestion - 1].A {
                score += 1
                answerVC?.answerMessage.text = "Congrats, you selected the correct answer!"
            } else {
                answerVC?.answerMessage.text = "Oops, you selected the incorrect answer! The correct answer was  \(TableDataAndDelegate.questions[ViewController.questionSet][currQuestion - 1].A)"
            }
        } else if TableDataAndDelegate.questions[ViewController.questionSet].count == currQuestion {
            UIView.setAnimationTransition(.flipFromLeft, for: view, cache: true)
            finishedVC!.view.frame = self.view.frame
            submitAndNextBtn.isHidden = true
            switchViewController(answerVC, to: finishedVC)
            currQuestion = 0
        } else {
            UIView.setAnimationTransition(.flipFromRight, for: view, cache: true)
            questionVC!.view.frame = self.view.frame
            submitAndNextBtn.setTitle("Submit", for: .normal)
            switchViewController(answerVC, to: questionVC)
        }
        UIView.commitAnimations()
    }
    
    
    fileprivate func switchViewController(_ from: UIViewController?, to: UIViewController?) {
        if from != nil {
            from!.willMove(toParent: nil)
            from!.view.removeFromSuperview()
            from!.removeFromParent()
        }
        
        if to != nil {
            self.addChild(to!)
            self.view.insertSubview(to!.view, at: 0)
            to!.didMove(toParent: self)
            if (to == questionVC) {
                questionVC!.setData(TableDataAndDelegate.questions[ViewController.questionSet][currQuestion])
                currQuestion += 1
            } else if to == finishedVC {
                if TableDataAndDelegate.questions[ViewController.questionSet].count - score == 0 {
                    finishedVC!.message = "Hooray, you got \(String(score)) out of \(String(TableDataAndDelegate.questions[ViewController.questionSet].count)) questions correct!"
                } else {
                    finishedVC!.message = "Almost! You got \(String(score)) out of \(String(TableDataAndDelegate.questions[ViewController.questionSet].count)) questions correct."
                }
                finishedVC!.setMessage()
            }
        }
    }

/*------------------------------------------------------------------------*/
    
    fileprivate func buildQuestionVC() {
        if questionVC == nil {
            questionVC = storyboard?.instantiateViewController(identifier: "questionVC") as? QuestionViewController
            questionVC!.questionSet = TableDataAndDelegate.questions[ViewController.questionSet][currQuestion]
        }
    }
    
    fileprivate func buildAnswerVC() {
        if answerVC == nil {
            answerVC = storyboard?.instantiateViewController(identifier: "answerVC") as? AnswerViewController
        }
    }
    
    fileprivate func buildFinishVC() {
        if finishedVC == nil {
            finishedVC = storyboard?.instantiateViewController(identifier: "finishedVC") as? FinishedViewController
        }
    }
}

/*------------------------------------------------------------------------*/

class TableDataAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    weak var vc : ViewController?
    
    let images : [String] = ["math", "marvel", "science"]
    let subjects : [String] = ["Mathematics", "Marvel Super Heroes", "Science"]
    let descriptions : [String] = ["Test your math skills!", "Test what you know about Marvel!", "Test your science skills!"]
    
    static let questions: [[Question]] = [
        [Question(Question: "Math", Choice1: "1", Choice2: "2", Choice3: "3", Answer: "4"), Question(Question: "Math2", Choice1: "1-2", Choice2: "2-2", Choice3: "3-2", Answer: "4-2")],
        [Question(Question: "Marvel", Choice1: "1", Choice2: "2", Choice3: "3", Answer: "4")],
        [Question(Question: "Science", Choice1: "1", Choice2: "2", Choice3: "3", Answer: "4")]
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! customTableViewCell
        
        cell.cellImage.image = UIImage(named: images[indexPath.row])
        cell.cellSubject.text = subjects[indexPath.row]
        cell.cellDesc.text = descriptions[indexPath.row]
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        ViewController.questionSet = indexPath.row
        return indexPath
    }

    
}

