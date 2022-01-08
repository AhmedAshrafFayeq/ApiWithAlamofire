//
//  ViewController.swift
//  ApiWithAlamofire
//
//  Created by Ahmed Fayeq on 08/01/2022.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchUserData { (response) in
            switch response{
            case .success(let users):
                guard let users = users else {return}
                for user in users{
                    print(user.name)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func fetchUserData(completion: @escaping (Result<Users?,NSError>)-> Void){
        let url = "https://jsonplaceholder.typicode.com/users"
        AF.request(url, method: .get, parameters: [:],headers: []).responseJSON { (response) in
            guard let statusCode = response.response?.statusCode else {return}
            if statusCode == 200 {
                guard let jsonResponse  = try? response.result.get() else {return}
                guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {return}
                guard let jsonResponseObj = try? JSONDecoder().decode(Users.self, from: jsonData) else {return}
                completion(.success(jsonResponseObj))
            }
        }
    }

}

