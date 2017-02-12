//
//  RegisterViewController.swift
//  Rendezvous
//
//  Created by Prakhar Srivastava on 1/24/17.
//  Copyright © 2017 Prakhar Srivastava. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var emailId: UITextField!
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var sex: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var fullName: UITextField!
    var ref = FIRDatabase.database().reference(withPath: "user-data")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var password: UITextField!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        error.text!=" "
        userName.text!=""
        emailId.text!=""
        phoneNo.text!=""
        sex.text!=""
        age.text!=""
        fullName.text!=""
    }
    
    @IBAction func register(_ sender: Any) {
        error.textColor=UIColor.red
        let charSet=CharacterSet(charactersIn: "!@#$%^&*()-_=+{}[]|\\:;<,>.?/'\"")
        var userName = self.userName.text!
        var password = self.password.text
        var emailId = self.emailId.text
        var phoneNo = self.phoneNo.text
        var fullName = self.fullName.text
        var sex = self.sex.text
        var age = self.age.text
        //var spa=NSCharacterSet.alphanumerics
        var flag = false
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            let value=snapshot.value as! NSDictionary
            for val in (value.allKeys){
                //print(val)
                if(userName == val as? String){
                    flag=true
                    break
                }
                //print("inside \(flag)")
            }
            if(flag){
                self.error.text="UserName not available"
            }
        })
        
        if((userName.characters.count) < 4){
            error.text="Username must be more than 4 alphabets"
            return
        }
        else if((password!.characters.count) < 6){
            error.text="Password must be more than 6 digits"
            return
        }
        else if((emailId!.characters.count) < 4){
            error.text="enter a valid email id"
            return
        }
        else if((fullName!.characters.count) < 1){
            error.text="enter a name"
            return
        }
        else if((phoneNo!.characters.count) < 10 || (phoneNo?.characters.count)! > 10){
            error.text="Enter a valid phone number"
            return
        }
//        else if(sex?.caseInsensitiveCompare("Male") != .orderedSame || sex?.caseInsensitiveCompare("Female") != .orderedSame){
//         error.text="Sex must be Male or Female"
//         return
//         }
            
        
        else if((userName.rangeOfCharacter(from: charSet)) != nil){
            error.text="UserName Cannot contain special character except of _"
            return
        }
        else{
            FIRAuth.auth()?.createUser(withEmail: emailId!, password: password!){(user,err) in
                if((err) != nil){
                    self.error.text="Registration Failed"
                    print(err!)
                }
                else{
                    //self.ref.child(userName!).setValue(["emailId":emailId!])
                    //self.ref.child(userName!).setValue(["fullname":fullName!])
                    //self.ref.child(userName!).setValue(["password":password!])
                    //self.ref.child(userName!).setValue(["phoneNo":phoneNo!])
                    //self.ref.child(userName!).setValue(["age":age!])
                    //self.ref.child(userName!).setValue(["sex":sex!])
                    self.ref.child("\(userName)/emailId").setValue(emailId!)
                    self.ref.child("\(userName)/fullname").setValue(fullName!)
                    self.ref.child("\(userName)/password").setValue(password!)
                    self.ref.child("\(userName)/phoneNo").setValue(phoneNo!)
                    self.ref.child("\(userName)/age").setValue(age!)
                    self.ref.child("\(userName)/sex").setValue(sex!)
                    self.ref.child("\(userName)/noOfEvents").setValue(0)
                    self.error.textColor=UIColor.green
                    self.error.text="Registered successfully"
                }
            }
        }
    }
}
