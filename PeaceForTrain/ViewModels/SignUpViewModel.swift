//
//  SignUpViewModel.swift
//  PeaceForTrain
//
//  Created by 深見龍一 on 2019/11/16.
//  Copyright © 2019 深見龍一. All rights reserved.
//

import RxSwift
import RxCocoa
import Alamofire

class SignUpViewModel {
    private let disposeBag = DisposeBag()
    let name = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let gender = BehaviorRelay<String>(value: "")
    let old = BehaviorRelay<String>(value: "")

    init(){
        
    }

    func api() -> Int
    {
        var keepAlive = true
        print(self.name.value)
        print(self.password.value)
        let parameters:[String: Any] = [
            "mail": self.name.value,
            "password": self.password.value,
        ]
        var resultNum = 0
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
                        print(resultNum)
                    } catch {
                        print("error:")
                        print(error)
                        resultNum = 2
                    }
                case .failure:
                    print("Failure!")
                    resultNum = 2
            }
            keepAlive = false
        }
        let runLoop = RunLoop.current
        while keepAlive &&
            runLoop.run(mode: RunLoop.Mode.default, before: NSDate(timeIntervalSinceNow: 0.1) as Date) {
        }
        return resultNum
    }
}

