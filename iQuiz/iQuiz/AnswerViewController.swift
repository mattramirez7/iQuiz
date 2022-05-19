//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Matthew Ramirez on 5/12/22.
//

import UIKit

class AnswerViewController: UIViewController {

    @IBOutlet weak var answerMessage: UILabel!
    
    var _message : String? = nil
              open var message : String? {
                get { return self._message }
                set(value) {
                    self._message = value
                }
              }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setMessage() {
        answerMessage.text = message
        
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
