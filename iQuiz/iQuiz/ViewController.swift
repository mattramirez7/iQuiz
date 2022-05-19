//
//  ViewController.swift
//  iQuiz
//
//  Created by Matthew Ramirez on 5/9/22.
//

import UIKit

struct Subject: Codable {
    var title, description: String
    var questions: [Question] = []
    
    init(title: String, description: String, questionSet: [Question]?) {
        self.title = title
        self.description = description
        if (questionSet != nil) {
            self.questions = questionSet!
        }
    }
}

struct Question: Codable {
    var q, answer: String
    var answers: [String]
    
    init(q: String, answer: String, answers: [String]) {
        self.q = q
        self.answer = answer
        self.answers = answers
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
    var urlPath = UserDefaults.standard.string(forKey: "questionUrl") ?? "https://tednewardsandbox.site44.com/questions.json"
    
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
            getData()
        }
    }
    
    
    @IBAction func settingsBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        let promptURL = UIAlertAction(title: "Check Now", style: .default) { _ in
            self.urlPath = (alert.textFields?[0].text)!
            UserDefaults.standard.set(self.urlPath, forKey: "questionUrl")
            self.getData()
        }
        let reloadQuestions = UIAlertAction(title: "Reload Questions", style: .default) {_ in
            self.getData()
            self.tableView.reloadData()
        }
        alert.addTextField {
            (textField) in textField.placeholder = "Enter new URL"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) { _ in
        }
        alert.addAction(promptURL)
        alert.addAction(reloadQuestions)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    fileprivate func getData() {
        guard let url = URL.init(string: urlPath) else {
                    return
                }
                let task = URLSession.shared.dataTask(with: url) {data, response, error in
                    if response != nil {
                        if (response! as! HTTPURLResponse).statusCode == 200 {
                            do {
                                TableDataAndDelegate.subjectData = []
                                let questionList =  try JSONSerialization.jsonObject(with: data!) as! NSArray
                                DispatchQueue.main.async {
                                    for i in 0..<questionList.count {
                                        var questions : [Question] = []
                                        let set = questionList[i] as! NSDictionary
                                        let qObjects = set["questions"]! as! NSArray
                                        for i in 0...qObjects.count - 1{
                                            let question = qObjects[i] as! NSDictionary
                                            questions.append(
                                                Question(
                                                    q: question["text"] as! String,
                                                    answer: question["answer"] as! String,
                                                    answers: question["answers"] as! [String]
                                                )
                                            )
                                        }
                                        TableDataAndDelegate.subjectData.append(Subject(
                                            title: set["title"]! as! String,
                                            description: set["desc"]! as! String,
                                            questionSet: questions
                                        ))
                                    }
                                    self.tableView.reloadData()
                                }
                            } catch {
                                DispatchQueue.main.async {
                                    let alertError = UIAlertController(title: "Network Error!", message: "Check your network connection and try again.", preferredStyle: .alert)
                                    let alertErrorAction = UIAlertAction(title: "Enter", style: .default) { (_) in }
                                    alertError.addAction(alertErrorAction)
                                    self.present(alertError, animated: true, completion: nil)
                                }
                            }
                        } else {
                            let getScores = NSArray(contentsOf: URL(fileURLWithPath: NSHomeDirectory() + "/Documents/scores.archive"))
                            TableDataAndDelegate.subjectData = getScores as! [Subject]
                        }
                    }
                }
                task.resume()
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
            if questionVC?.currentChoice?.titleLabel?.text == TableDataAndDelegate.currQuestionSet![currQuestion - 1].answers[Int(TableDataAndDelegate.currQuestionSet![currQuestion - 1].answer)! - 1] {
                score += 1
                answerVC?.answerMessage.text = "Congrats, you selected the correct answer!"
            } else {
                answerVC?.answerMessage.text = "Oops, you selected the incorrect answer! The correct answer was  \(TableDataAndDelegate.currQuestionSet![currQuestion - 1].answers[Int(TableDataAndDelegate.currQuestionSet![currQuestion - 1].answer)! - 1])"
            }
        } else if TableDataAndDelegate.currQuestionSet!.count == currQuestion {
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
                questionVC!.setData(TableDataAndDelegate.currQuestionSet![currQuestion])
                currQuestion += 1
            } else if to == finishedVC {
                if TableDataAndDelegate.currQuestionSet!.count - score == 0 {
                    finishedVC!.message = "Hooray, you got \(String(score)) out of \(String(TableDataAndDelegate.currQuestionSet!.count)) questions correct!"
                } else {
                    finishedVC!.message = "Almost! You got \(String(score)) out of \(String(TableDataAndDelegate.currQuestionSet!.count)) questions correct."
                }
                finishedVC!.setMessage()
            }
        }
    }

/*------------------------------------------------------------------------*/
    
    fileprivate func buildQuestionVC() {
        if questionVC == nil {
            questionVC = storyboard?.instantiateViewController(identifier: "questionVC") as? QuestionViewController
            questionVC!.questionSet = TableDataAndDelegate.currQuestionSet![currQuestion]
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
    static var currQuestionSet: [Question]? = nil
    static var subjectData: [Subject] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableDataAndDelegate.subjectData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! customTableViewCell
        
        cell.cellSubject.text = TableDataAndDelegate.subjectData[indexPath.row].title
        cell.cellDesc.text = TableDataAndDelegate.subjectData[indexPath.row].description
        cell.cellImage.image = UIImage(named: TableDataAndDelegate.subjectData[indexPath.row].title)
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        TableDataAndDelegate.currQuestionSet = TableDataAndDelegate.subjectData[indexPath.row].questions
        return indexPath
    }

    
}

