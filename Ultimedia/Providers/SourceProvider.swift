//
//  Provider.swift
//  Ultimedia
//
//  Created by William Alexander on 4/24/22.
//

import Foundation
import CoreData
import SwiftUI
import AMSMB2

class SourceProvider {
    static var sources = [Source]()
    static var activeSource: Source? = nil
    //var moc: NSManagedObjectContext!
    //let appDelegate = UIApplication.shared.delegate as? AppDelegate

    //init() {
    //    moc = appDelegate?.persistentContainer.viewContext
    //}
    
    class func Save(name: String, endpoint: String, share: String, port: Int32?, sourceType: SourceType, username: String, password: String) -> Source{
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        
        let source = Source(context: context)
        let credentials = Credentials(context: context)
        
        var defaultPort : Int32?
        
        switch(sourceType) {
            case (SourceType.SMB) : defaultPort = 445
            case (SourceType.Imageboard) : defaultPort = 443
            case (SourceType.Reddit) : defaultPort = 443
            default: defaultPort = nil
        }
        
        source.name = name
        source.endpoint = endpoint
        source.share = share
        source.port = port ?? defaultPort!
        source.sourceType = sourceType.rawValue
        credentials.username = username
        credentials.password = password
        source.credentials = credentials

        do {
            try context.save()
        }
        catch {
            print("Could not save source to CoreData")
        }
        return source
    }
       
    class func Edit(Source: Source){
        print ("Source.Edit not implemented.")
    }
    
    class func Delete(Source: Source){
        print ("Source.Delete not implemented.")
    }
    
    class func LoadSources() -> [Source]{
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let sourceRequest:NSFetchRequest<Source> = Source.fetchRequest()
              
        do{
            try sources = context.fetch(sourceRequest)
            
            return(sources)
        }
        catch{
            print("Could not load data")
            return []
        }
    }
    
    class func ClearSources(in entity : String){
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print ("There was an error")
        }
    }

}
