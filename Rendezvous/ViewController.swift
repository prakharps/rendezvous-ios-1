//
//  ViewController.swift
//  Rendezvous
//
//  Created by Prakhar Srivastava on 1/20/17.
//  Copyright © 2017 Prakhar Srivastava. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var emailId: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var error: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func loginAction(_ sender: Any) {
        check()
    }
    /*override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var test:String=""
        if(identifier == "login"){
            return check()
        }
        return false
    }*/
    func check() {
        var flag:Bool
        var test=""
        let emailId = self.emailId?.text
        let password = self.password?.text
        var request = URLRequest(url: URL(string: "http://localhost:3000/login")!)
        request.httpMethod="post"
        let postString = "emailid="+emailId!+"&password="+password!
        request.httpBody=postString.data(using: .utf8)
        let task=URLSession.shared.dataTask(with: request){
            data,
            response,
            error in guard let data = data ,
                error == nil else {
                    print("error=\(error)")
                    return
                }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("Status code is not 200")
            }
            let responseString = String(data: data, encoding: .utf8)
            //print("responseString = \(responseString)")
            /*let bodyStr = String(data: request.httpBody!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
             if(bodyStr == emailId){
             check=true
             }
             else{
             check = false
             }*/
            
            /*if let httpresponse = response as? HTTPURLResponse{
             //var mail = HTTPURLResponse.value(forKey: "emailId") as? String
             var mail = HTTPURLResponse.value(forUndefinedKey: "emailId") as? String
             if(mail == emailId){
             check = true
             }
             else{
             check = false
             }
             }
             */
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:String]
                let mail = json.values//json["emailId"] as? [[String: Any]] ?? []
                test=mail.first!
                print(test)
            } catch let error as NSError {
                print(error)
            }
        }
        if(test == emailId!){
            flag = true
            performSegue(withIdentifier: "login", sender: self)
            //return true
        }
        else{
            flag = false
            error.text="Email Id and Password did not match"
        }
        task.resume()
    }
}
