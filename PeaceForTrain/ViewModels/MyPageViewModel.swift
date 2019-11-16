//
//  MyPageViewModel.swift
//  PeaceForTrain
//
//  Created by 深見龍一 on 2019/11/15.
//  Copyright © 2019 深見龍一. All rights reserved.
//

import RxSwift
import RxCocoa
import Alamofire

class MyPageViewModel {
  private let disposeBag = DisposeBag()
  let name = BehaviorRelay<String>(value: "")
    
  init(){
    self.api()
  }
  func api()
  {
    let url = "http://localhost:5000/hello"
    Alamofire.request(url, method: .get, parameters: nil)
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON { response in
        switch response.result {
        case .success:
          print("success!")
          guard let data = response.data else {
            return
          }
//          let decoder = JSONDecoder()
          do {
            print(data)
          } catch {
            print("error:")
            print(error)
          }
        case .failure:
          print("Failure!")
        }
    }
  }
}
