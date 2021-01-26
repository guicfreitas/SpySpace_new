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
    var title: String
    var content: String
    var image: CKAsset?
    var RecordId: CKRecord.ID? = nil
    
    
    
    var container: CKContainer {
        return CKContainer(identifier: "iCloud.br.com.SpySpace")
    }
    
    func createRecord(completionHandler: @escaping (Error?)->()){
        let record = CKRecord(recordType: "Favoritos")
        
        //Cast para CKRecordValue pois o compilador swift nao compreende que uma String adota um CKRecordValue
        record["title"] = self.title as CKRecordValue
        record["content"] = self.content as CKRecordValue
        record["image"] = self.image
        
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
            let favoritos = Favoritos(title: record["title"] as! String, content: record["content"] as! String,image: record["image"] as? CKAsset, RecordId: record.recordID)
            
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
    
    mutating func parseImageToAsset(imageF: UIImage){
        let data = imageF.pngData(); // UIImage -> NSData, see also UIImageJPEGRepresentation
        let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")
        do {
            try data!.write(to: url!,options: [])
            self.image =  CKAsset(fileURL: url!)
        } catch let e as NSError {
            print("Error! \(e)");
            
        }
        
    }
    func parseAssetToImage() -> UIImage?{
        
        if let data = NSData(contentsOf: (self.image?.fileURL)!) {
            return UIImage(data: data as Data)
        }
        return nil
        
    }

}
