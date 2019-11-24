//
//  LoginViewModel.swift
//  PeaceForTrain
//
//  Created by 深見龍一 on 2019/11/15.
//  Copyright © 2019 深見龍一. All rights reserved.
//

import RxSwift
import RxCocoa
import Alamofire

class LoginViewModel {
    let udf = UserDefaults.standard
    private let disposeBag = DisposeBag()
    let mail = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")

    init(){
        
    }

    func api() -> Int
    {
        var keepAlive = true
        print(self.mail.value)
        print(self.password.value)
        let parameters:[String: Any] = [
            "mail": self.mail.value,
            "password": self.password.value,
        ]
        var resultNum = 1
        let url = "http://49.212.133.185:7854/canLogin"
        Alamofire.request(url, method: .post, parameters: parameters)
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseJSON { response in
            switch response.result {
                case .success:
                    print("success!")
                    guard let data = response.data else {
                        return
                    }
                    let decoder = JSONDecoder()
                    do {
                        let tasks = try decoder.decode(Login.self, from: data)
                        resultNum = tasks.count
                        self.setUserDefault(mail: self.mail.value, gender: tasks.gender, old: tasks.old, id: tasks.id)
                        print(resultNum)
                    } catch {
                        print("error:")
                        print(error)
                        resultNum = 0
                    }
                case .failure:
                    print("Failure!")
                    resultNum = 0
            }
            keepAlive = false
        }
        let runLoop = RunLoop.current
        while keepAlive &&
            runLoop.run(mode: RunLoop.Mode.default, before: NSDate(timeIntervalSinceNow: 0.1) as Date) {
        }
        return resultNum
    }
    
    func setUserDefault(mail:String, gender: String, old: String, id: Int)
    {
        self.udf.set(mail, forKey: "mail")
        self.udf.set(gender, forKey: "gender")
        self.udf.set(old, forKey: "old")
        self.udf.set(id, forKey: "id")
    }
}

