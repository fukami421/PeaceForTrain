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
import CoreBluetooth

class TryConnectViewModel: NSObject, CLLocationManagerDelegate, CBPeripheralManagerDelegate {
    
    // 受信用
    let udf = UserDefaults.standard
    private let disposeBag = DisposeBag()
    let distance = BehaviorRelay<String>(value: "? m")
    let gender = BehaviorRelay<String>(value: "不明")
    let old = BehaviorRelay<String>(value: "不明")
    let isDisplayActivityIndicator = BehaviorRelay<Bool>(value: true)
    
    var clLocationManager:CLLocationManager!
    var beaconRegion:CLBeaconRegion!
//    var beaconUuids: NSMutableArray!
//    var beaconDetails: NSMutableArray!
    
    var isApi = 0
    
    // 発信用
    var myPeripheralManager: CBPeripheralManager!

    override init(){
        super.init()
        self.setUpMonitoring()
        self.myPeripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    // 受信用
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
        if beacon.rssi != 0
        {
            if (isApi == 0){self.api()}
        }
        
        print(beacon.proximity.rawValue) //距離を1mごとに測る
        self.distance.accept("約" + String(beacon.proximity.rawValue) + "m")
        if beacon.rssi == 0
        {
            self.isDisplayActivityIndicator.accept(true)
            self.distance.accept("不明")
            self.gender.accept("不明")
            self.old.accept("不明")
            print("rssiが0や")
            self.clLocationManager.stopRangingBeacons(satisfying: self.beaconRegion.beaconIdentityConstraint)
            clLocationManager.startMonitoring(for: self.beaconRegion)
            self.isApi = 0
        }
    }

    
    // 発信用
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        let uuid:UUID? = UUID(uuidString: "48534442-4C45-4144-80C0-1800FFFFFFFF") // BeaconのUUIDを設定
        if peripheral.state == CBManagerState.poweredOn {
            let beaconRegion = CLBeaconRegion(uuid: uuid!, major: 0, minor: 0, identifier: "com.ryu1.myregion")
            let beaconPeripheralData = NSDictionary(dictionary: beaconRegion.peripheralData(withMeasuredPower: nil))
            self.myPeripheralManager.startAdvertising(beaconPeripheralData as? [String : AnyObject])
        }
    }
    
    func stopAdvertising()
    {
        self.myPeripheralManager.stopAdvertising()
    }


    func api()
    {
        let parameters:[String: Any] = [
            "id": udf.integer(forKey: "id"),
        ]
        let url = "http://49.212.133.185:7854/getUserInfo"
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
                        let tasks = try decoder.decode(TryConnect.self, from: data)
                        self.gender.accept(tasks.gender)
                        self.old.accept(tasks.old)
                        self.isApi = 1
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
