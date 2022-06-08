//
//  SMB_Provider.swift
//  Ultimedia
//
//  Created by William Alexander on 4/26/22.
//

import Foundation
import CoreData
import AMSMB2

class SMBProvider : SourceProvider {
    
    var serverURL : URL
    var credential: URLCredential
    var share: String
    
    init(source: Source){
        self.serverURL = URL(string: source.endpoint!)!
        self.credential = URLCredential(user: source.credentials!.username!,
                                        password: source.credentials!.password!,
                                        persistence: URLCredential.Persistence.forSession)
        self.share = source.share!
    }
    
    lazy private var client = AMSMB2(url: self.serverURL, credential: self.credential)!
    
    func connect(handler: @escaping (Result<AMSMB2, Error>) -> Void) {
        // AMSMB2 can handle queueing connection requests
        client.connectShare(name: self.share) { error in
            if let error = error {
                handler(.failure(error))
            } else {
                handler(.success(self.client))
            }
        }
    }
   
    func listDirectory(path: String) {
        
        connect { result in
            switch result {
            case .success(let client):
                client.contentsOfDirectory(atPath: path) { result in
                    switch result {
                    case .success(let files):
                    print(files)
                        for entry in files {
                            print("name:", entry[.nameKey] as! String,
                                  ", path:", entry[.pathKey] as! String,
                                  ", type:", entry[.fileResourceTypeKey] as! URLFileResourceType,
                                  ", size:", entry[.fileSizeKey] as! Int64,
                                  ", created:", entry[.creationDateKey] as! Date)
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
