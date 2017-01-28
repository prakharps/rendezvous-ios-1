//
//  RegisterViewController.swift
//  Rendezvous
//
//  Created by Prakhar Srivastava on 1/24/17.
//  Copyright © 2017 Prakhar Srivastava. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var emailId: UITextField!
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var sex: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var question: UITextField!
    @IBOutlet weak var answer: UITextField!
    @IBOutlet weak var error: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var password: UITextField!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(identifier == "RegisterSegue"){
            var userName = self.userName.text
            var password = self.password.text
            var emailId = self.emailId.text
            var phoneNo = self.phoneNo.text
            var sex = self.sex.text
            var age = self.age.text
            var question = self.question.text
            var answer = self.answer.text
            if((userName?.characters.count)! < 4){
                error.text="Username must be more than 4 alphabets"
                return false
            }
            else if((password?.characters.count)! < 6){
                error.text="Password must be more than 6 digits"
                return false
            }
            else if((emailId?.characters.count)! < 4){
                error.text="enter a valid email id"
                return false
            }
            else if((phoneNo?.characters.count)! < 10 || (phoneNo?.characters.count)! > 10){
                error.text="Enter a valid phone number"
                return false
            }
            /*else if(sex?.caseInsensitiveCompare("Male") != .orderedSame || sex?.caseInsensitiveCompare("Female") != .orderedSame){
                error.text="Sex must be Male or Female"
                return false
            }*/
            else if((question?.characters.count)! < 10){
                error.text="Enter a valid question"
                return false
            }
            else if((answer?.characters.count)! < 1){
                error.text="Enter security answer"
                return false
            }
            else {
                var request = URLRequest(url: URL(string: "http://localhost:3000/register")!)
                request.httpMethod="post"
                var postString =  "username="+userName!
                postString += "&password="+password!+"&emailid="+emailId!
                postString += "&phoneno="+phoneNo!+"&sex="+sex!
                postString += "&age="+age!+"&question="+question!
                postString += "&answer="+answer!
                //let postString=postString1+postString2
                request.httpBody = postString.data(using: .utf8)
                let task=URLSession.shared.dataTask(with: request){data,response,error in guard let data = data, error == nil else{
                    print("error=\(error)")
                    return
                    }
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                        print("Status code is not 200")
                    }
                    let responseString = String(data: data, encoding: .utf8)
                    print("responseString = \(responseString)")
                }
                task.resume()
                return true
            }
        }
        return true
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
