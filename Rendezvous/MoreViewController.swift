//
//  MoreViewController.swift
//  Rendezvous
//
//  Created by Prakhar Srivastava on 2/4/17.
//  Copyright © 2017 Prakhar Srivastava. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class MoreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var events:[String]=[]
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func logout(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
            performSegue(withIdentifier: "Logout", sender: self)
        } catch let signOutError as NSError {
            print(signOutError)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuth.auth()?.addStateDidChangeListener(){(auth,user) in
            if user == nil {
                self.performSegue(withIdentifier: "Logout", sender: self)
            }
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "events")
        }
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        FIRAuth.auth()?.addStateDidChangeListener(){(auth,user) in
            if user == nil {
                self.performSegue(withIdentifier: "Logout", sender: self)
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return events.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell=tableView.dequeueReusableCell(withIdentifier: "events", for: indexPath)
        cell.textLabel?.text=events[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
