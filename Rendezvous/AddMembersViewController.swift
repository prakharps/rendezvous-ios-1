//
//  AddMembersViewController.swift
//  Rendezvous
//
//  Created by Prakhar Srivastava on 2/5/17.
//  Copyright © 2017 Prakhar Srivastava. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class AddMembersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var memberName: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var timeAndDate: UIDatePicker!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var rCoordinate:CLLocationCoordinate2D!
    var members:[String]=[]
    var ref = FIRDatabase.database().reference(withPath: "event-data")
    var refUser = FIRDatabase.database().reference(withPath: "user-data")
    var event:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "members")
        memberName.isEnabled=false
        addButton.isHidden=true
        finishButton.isHidden=true
        let user = FIRAuth.auth()?.currentUser
        members.append((user?.displayName!)!)
        // Do any additional setup after loading the view.
    }
    @IBAction func cancel(_ sender: Any) {
        let alert=UIAlertController.init(title: "confirmation", message: "Are you sure you want to cancel", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: "Yes", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            self.performSegue(withIdentifier: "home", sender: self)
        }))
        alert.addAction(UIAlertAction.init(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func create(_ sender: Any) {
        eventName.isEnabled = false
        timeAndDate.isEnabled = false
        createButton.isHidden = true
        addButton.isHidden = false
        memberName.isEnabled = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        errorLabel.text=""
    }
    
    @IBAction func add(_ sender: Any) {
        errorLabel.text=""
        let newUser:String = memberName.text!
        for one in members{
            if(one == newUser){
                errorLabel.text="\(newUser) already added"
                return
            }
        }
        var flag=false
        refUser.observeSingleEvent(of: .value, with: {(snapshot) in
            let value=snapshot.value as! NSDictionary
            for val in (value.allKeys){
                //print(val)
                if(newUser == val as? String){
                    flag=true
                    break
                }
                //print("inside \(flag)")
            }
            if(flag){
                self.members.append(newUser)
                self.tableView.reloadData()
                self.memberName.text=""
                self.finishButton.isHidden=false
            }
            else{
                self.errorLabel.text="No such UserNAme found"
            }
        })
        
    }
    @IBAction func finish(_ sender: Any) {
        let event=eventName.text!
        if(members.count<2){
            let alert=UIAlertController.init(title: "No members added", message: "Add atleast one more member", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        let formatter=DateFormatter()
        formatter.dateFormat = "MMMM dd ,YYYY"
        let date = formatter.string(from: timeAndDate.date)
        formatter.dateFormat = "hh:mm a"
        let time = formatter.string(from: timeAndDate.date)
        ref.child("\(event)/latitude").setValue(rCoordinate.latitude)
        ref.child("\(event)/longitude").setValue(rCoordinate.longitude)
        ref.child("\(event)/date").setValue(date)
        ref.child("\(event)/time").setValue(time)
        ref.child("\(event)/noOfMembers").setValue(members.count)
        for i in 0..<members.count{
            ref.child("\(event)/member\(i)").setValue(members[i])
            refUser.child("\(members[i])/noOfEvents").observeSingleEvent(of: .value, with: {(snapshot) in
                var no = snapshot.value as! Int
                no += 1
                self.refUser.child("\(self.members[i])/noOfEvents").setValue(no)
                self.refUser.child("\(self.members[i])/event\(no)").setValue(event)
            })
        }
        let alert=UIAlertController.init(title: "Done", message: "Event created..!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
            self.performSegue(withIdentifier: "home", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell=tableView.dequeueReusableCell(withIdentifier: "members", for: indexPath)
        cell.textLabel?.text=members[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //let user = FIRAuth.auth()?.currentUser?.displayName
        if(editingStyle == UITableViewCellEditingStyle.delete){
            if(indexPath.row == 0){
                let alert=UIAlertController.init(title: "Error !!", message: "You cannot remove yourself..!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                members.remove(at: indexPath.row)
                if(members.count < 2){
                    finishButton.isHidden = true
                }
                tableView.reloadData()
            }
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
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
