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
        
        fetchData(url: "https://jsonplaceholder.typicode.com/users", response: Users.self) { (response) in
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
        
        fetchData(url: "https://jsonplaceholder.typicode.com/posts", response: Posts.self) { (response) in
            switch response{
            case .success(let posts):
                guard let posts = posts else {return}
                for post in posts{
                    print(post.title)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchData<T:Decodable>(url: String, response: T.Type, completion: @escaping (Result<T?,NSError>)-> Void){
        AF.request(url,method: .get, parameters: [:],headers: [:]).responseJSON { (response) in
            guard let statusCode = response.response?.statusCode else {return}
            if statusCode == 200{
                guard let jsonResponse = try? response.result.get() else {return}
                guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: [])else {return}
                guard let jsonResponseObject = try? JSONDecoder().decode(T.self, from: jsonData) else {return}
                completion(.success(jsonResponseObject))
            }
        }
    }

//    func fetchUserData(completion: @escaping (Result<Users?,NSError>)-> Void){
//        let url = "https://jsonplaceholder.typicode.com/users"
//        AF.request(url, method: .get, parameters: [:],headers: [:]).responseJSON { (response) in
//            guard let statusCode = response.response?.statusCode else {return}
//            if statusCode == 200 {
//                guard let jsonResponse  = try? response.result.get() else {return}
//                guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {return}
//                guard let jsonResponseObj = try? JSONDecoder().decode(Users.self, from: jsonData) else {return}
//                completion(.success(jsonResponseObj))
//            }
//        }
//    }

}

