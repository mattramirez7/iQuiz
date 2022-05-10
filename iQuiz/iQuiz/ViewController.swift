//
//  ViewController.swift
//  iQuiz
//
//  Created by Matthew Ramirez on 5/9/22.
//

import UIKit


class TableDataAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    weak var vc : ViewController?
    
    let images : [String] = ["math", "marvel", "science"]
    let subjects : [String] = ["Mathematics", "Marvel Super Heroes", "Science"]
    let descriptions : [String] = ["Test your math skills!", "Test what you know about Marvel!", "Test your science skills!"]
    
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
    
}






class ViewController: UIViewController {
    
    var tableDataAndDelegate = TableDataAndDelegate()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func settingsBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Settings",
                                      message: "Settings go here",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
                                      style: .default,
                                      handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableDataAndDelegate.vc = self
        
        tableView.dataSource = tableDataAndDelegate
        tableView.delegate = tableDataAndDelegate
    }


}

