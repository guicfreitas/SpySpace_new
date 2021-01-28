//
//  Favoritos.swift
//  SpySpace_New
//
//  Created by João Guilherme on 26/01/21.
//

import Foundation
import CloudKit
import UIKit

struct Favoritos{
    
    var RecordId: String
    
    
    
    var container: CKContainer {
        return CKContainer(identifier: "iCloud.br.com.SpySpace")
    }
    
    func createRecord(completionHandler: @escaping (Error?)->()){
        let record = CKRecord(recordType: "Favoritos")
        
        //Cast para CKRecordValue pois o compilador swift nao compreende que uma String adota um CKRecordValue
        record["recordStr"] = self.RecordId as CKRecordValue
        
        
        //RecordId = record.recordID
        
        
        container.publicCloudDatabase.save(record) { _, error in
            
            
            if let error = error {
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
            
            
        }
    }
    
    func readRecord(completionHandler: @escaping ([Favoritos]?,Error?)->()){
        _ = CKRecord(recordType: "Favoritos")
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Favoritos", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        //operation.resultsLimit = 5
        
        var favoritosRecords: [Favoritos] = []
        
        operation.recordFetchedBlock = { record in
            
            // record é um registro do tipo Letter que foi obtido na operação
            let favoritos = Favoritos(RecordId: record["recordStr"] as! String)
            
            favoritosRecords.append(favoritos)
            
            
        }
        
        operation.queryCompletionBlock = { (cursor, error) in
            
            if error == nil {
                print("succesFavoritos")
                completionHandler(favoritosRecords,nil)
            } else {
                
                completionHandler(nil,error)
            }
            
            
            
        }
        container.publicCloudDatabase.add(operation)
        
    }
    
    func readRecordWithId() -> Curiosidade{
        let favoriteID = CKRecord.ID(recordName: self.RecordId)
        var curi = Curiosidade(title: "", content: "")
        container.publicCloudDatabase.fetch (withRecordID: favoriteID) { record, error in
            
                if error != nil {

                    print("there was an error",error as Any)

                } else {
                    
                    curi.title = (record?.object(forKey: "title") as! String)
                    curi.content = (record?.object(forKey: "content") as! String)
                    curi.image = (record?.object(forKey: "image") as! CKAsset)
                    
                    
                }
            }
        return curi
    }


}
