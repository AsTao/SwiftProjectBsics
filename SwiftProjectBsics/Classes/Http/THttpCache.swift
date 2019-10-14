//
//  THttpCache.swift
//  NewProject
//
//  Created by tao on 2019/8/13.
//  Copyright © 2019 tao. All rights reserved.
//

import UIKit
//import RealmSwift

class THttpCache {
    
//    init() {
//        configurationRealm()
//        print(Realm.Configuration.defaultConfiguration)
//    }
    
 //   let realm = try! Realm()
    
    func configurationRealm() {
//        var config = Realm.Configuration()
//        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("THttpCache.realm")
//        Realm.Configuration.defaultConfiguration = config
    }

    func filter(_ id :String) -> THttpResp?{
//        let response = realm.objects(THttpCacheResponse.self).filter("id = '\(id)'")
//        return response.first?.data
     //   THttpResp(data: nil, list: nil, code: nil, msge: nil, originalValue: nil)
        return nil
    }
    
    func add(_ id :String, _ data :String){
//        let response = THttpCacheResponse()
//        response.id = id
//        response.data = data
//        try? realm.write {
//            realm.add(response)
//        }
    }
    
}

extension THttpClient{
    
}


//class THttpCacheResponse: Object {
//    @objc dynamic var id = ""
//    @objc dynamic var data = ""
//    override static func primaryKey() -> String? {
//        return "id"
//    }
//    override static func indexedProperties() -> [String] {
//        return ["id"]
//    }
//}
