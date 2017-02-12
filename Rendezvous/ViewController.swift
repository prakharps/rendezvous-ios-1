//
//  ViewController.swift
//  Rendezvous
//
//  Created by Prakhar Srivastava on 1/20/17.
//  Copyright © 2017 Prakhar Srivastava. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {

    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var error: UILabel!
    var ref = FIRDatabase.database().reference(withPath: "user-data")
    //var flag=true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        FIRAuth.auth()?.addStateDidChangeListener(){(auth,user) in
            if user != nil {
                self.performSegue(withIdentifier: "login", sender: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        var test=""
        let userName = self.userName.text!
        let password = self.password.text!
        var email:String = ""
        if((userName.characters.count) < 1 || (password.characters.count) < 1){
            error.text="Please enter email Id and password"
            //flag=false
        }
        else{
            ref.child(userName).observeSingleEvent(of: .value, with: {(snapshot) in
                //print(snapshot)
            let value=snapshot.value as? NSDictionary
            email=value?["emailId"] as? String ?? ""
                FIRAuth.auth()?.signIn(withEmail: email, password: password){(user,err) in
                    if((err) != nil){
                        self.error.textColor=UIColor.red
                        self.error.text="UserName and Password didn't match"
                    }
                    else{
                        if(user?.displayName == nil || user?.displayName != userName){
                            let update=FIRAuth.auth()?.currentUser?.profileChangeRequest()
                            update?.displayName = userName
                            update?.commitChanges(completion: {(err) in
                                if(err != nil){
                                   // print(err)
                                }
                            })
                        }
                        self.ref.child("\(userName)/password").setValue(password)
                    }
                }
                //email=snapshot.value["emailId"] as? String
                //print(email)
                })
        }
    }
    @IBAction func forgotPassword(_ sender: Any) {
        let alert=UIAlertController.init(title: "Reset Password", message: "Password reset mail will be sent to your email Id", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(textField) in
            textField.placeholder="UserNAme"
        })
        //let userName = alert.textFields![0]
        //userName.placeholder="UserName"
        alert.addAction(UIAlertAction.init(title: "Reset", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
            let userName = alert.textFields![0]
            if((userName.text?.characters.count)! < 4){
                self.error.text="UserName not valid"
            }
            else{
                self.ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    let value=snapshot.value as! NSDictionary
                    var flag=false
                    for val in (value.allKeys){
                        //print(val)
                        if(userName.text! == val as! String){
                            flag=true
                            break
                        }
                        //print("inside \(flag)")
                    }
                    if(!flag){
                        self.error.text="No such UserName found"
                    }
                    else{
                        self.ref.child(userName.text!).observeSingleEvent(of: .value, with: {(snapshot) in
                            //print(snapshot)
                            let value=snapshot.value as? NSDictionary
                            let email=value?["emailId"] as? String ?? ""
                            FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: {(error) in
                                if(error != nil){
                                    print(error!)
                                    self.error.text="Error occured..try again"
                                }
                                else{
                                    self.error.text="password reset request sent"
                                }
                            })
                            
                        })

                    }
                })
            }
        }))
        alert.addAction(UIAlertAction.init(title: "cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue){
        
    }
    override func viewDidAppear(_ animated: Bool) {
        error.text=" "
        userName.text=""
        password.text=""
        
    }
    /*func check(){
        if(flag){
            performSegue(withIdentifier: "login", sender: self)
        }
    }*/
    
}
