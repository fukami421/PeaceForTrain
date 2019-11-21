//
//  TryConnectViewModel.swift
//  PeaceForTrain
//
//  Created by 深見龍一 on 2019/11/19.
//  Copyright © 2019 深見龍一. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa
import Alamofire

class TryConnectViewModel: NSObject, CLLocationManagerDelegate {
    private let disposeBag = DisposeBag()
    let distance = BehaviorRelay<String>(value: "? m")
    let gender = BehaviorRelay<String>(value: "不明")
    let old = BehaviorRelay<String>(value: "不明")
    let isDisplayActivityIndicator = BehaviorRelay<Bool>(value: true)

    var clLocationManager:CLLocationManager!
    var beaconRegion:CLBeaconRegion!
//    var beaconUuids: NSMutableArray!
//    var beaconDetails: NSMutableArray!
    
    override init(){
        super.init()
        self.setUpMonitoring()
    }
    
    func setUpMonitoring()
    {
        print("CLLocationManager")
        self.clLocationManager = CLLocationManager()
        self.clLocationManager.delegate = self
        let uuid:UUID? = UUID(uuidString: "48534442-4C45-4144-80C0-1800FFFFFFFF") // BeaconのUUIDを設定
        
        //Beacon領域を作成
        if #available(iOS 13.0, *) {
            self.beaconRegion = CLBeaconRegion(uuid: uuid!, identifier: "id")
        } else {
            self.beaconRegion = CLBeaconRegion(proximityUUID: uuid!, identifier: "id")
        }
        self.beaconRegion = CLBeaconRegion(uuid: uuid!, identifier: "String")
        // 取得精度の設定.
        self.clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 取得頻度の設定.(1mごとに位置情報取得)
        self.clLocationManager.distanceFilter = 1
        // セキュリティ認証のステータスを取得
        let status = CLLocationManager.authorizationStatus()
        // まだ認証が得られていない場合は、認証ダイアログを表示(成功)
        if(status == CLAuthorizationStatus.notDetermined) {
            self.clLocationManager.requestWhenInUseAuthorization()
        }
    }
    //位置認証のステータスが変更された時に呼ばれる
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //観測を開始させる
        clLocationManager.startMonitoring(for: self.beaconRegion)
    }

    //観測の開始に成功すると呼ばれる
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        //観測開始に成功したら、領域内にいるかどうかの判定をおこなう。→（didDetermineState）へ
        print("観測開始")
        self.isDisplayActivityIndicator.accept(true)
        clLocationManager.requestState(for: self.beaconRegion)
    }

    //領域内にいるかどうかを判定する
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for inRegion: CLRegion) {

        switch (state) {
        case .inside: // すでに領域内にいる場合は（didEnterRegion）は呼ばれない
            clLocationManager.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
            self.isDisplayActivityIndicator.accept(false)
            print("inside")
            // →(didRangeBeacons)で測定をはじめる
            break

        case .outside:
            // 領域外→領域に入った場合はdidEnterRegionが呼ばれる
            print("outside -> inside")
            break

        case .unknown:
            print("unknown")
            // 不明→領域に入った場合はdidEnterRegionが呼ばれる
            break

        }
    }

    //領域に入った時
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // →(didRangeBeacons)で測定をはじめる
        self.clLocationManager.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
        self.isDisplayActivityIndicator.accept(false)
        print("入ったよ")
    }

    //領域から出た時
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        //測定を停止する
        self.clLocationManager.stopRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
        print("出たよ")
    }

    //領域内にいるので測定をする
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion){
        /*
         beaconから取得できるデータ
         proximityUUID   :   regionの識別子
         major           :   識別子１
         minor           :   識別子２
         proximity       :   相対距離
         accuracy        :   精度
         rssi            :   電波強度
         */
        
        if(beacons.count == 0) { return }
        let beacon = beacons[0] as CLBeacon //複数あった場合は一番先頭のものを処理する

        print(beacon.proximity.rawValue) //距離を1mごとに測る
        self.distance.accept("約" + String(beacon.proximity.rawValue) + "m")
        if beacon.rssi == 0
        {
            self.isDisplayActivityIndicator.accept(true)
            self.distance.accept("不明")
            print("rssiが0や")
            self.clLocationManager.stopRangingBeacons(satisfying: self.beaconRegion.beaconIdentityConstraint)
            clLocationManager.startMonitoring(for: self.beaconRegion)
        }
    }

//    func api() -> Int
//    {
//        var canSignUp = 2
//        var keepAlive = true
//        print(self.name.value)
//        print(self.password.value)
//        let parameters:[String: Any] = [
//            "mail": self.name.value,
//            "password": self.password.value,
//            "gender": self.gender.value,
//            "old": self.old.value
//        ]
//
//        let url = "http://49.212.133.185:7854/signUp"
//        Alamofire.request(url, method: .post, parameters: parameters)
//        .validate(statusCode: 200..<300)
//        .validate(contentType: ["application/json"])
//        .responseJSON { response in
//            switch response.result {
//                case .success:
//                    print("success!")
//                    guard let data = response.data else {
//                        return
//                    }
//                    let decoder = JSONDecoder()
//                    do {
//                        let tasks = try decoder.decode(SignUp.self, from: data)
//                        canSignUp = tasks.result
//                    } catch {
//                        print("error:")
//                        print(error)
//                    }
//                case .failure:
//                    print("Failure!")
//            }
//            keepAlive = false
//        }
//        let runLoop = RunLoop.current
//        while keepAlive &&
//            runLoop.run(mode: RunLoop.Mode.default, before: NSDate(timeIntervalSinceNow: 0.1) as Date) {
//        }
//        return canSignUp
//    }
}


