//
//  ViewController.swift
//  Ultimedia
//
//  Created by William Alexander on 4/22/22.
//

import UIKit
import AVKit
import TVVLCKit


class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, VLCMediaPlayerDelegate {
    
    @IBOutlet weak var vlcView: UIView!
    @IBOutlet weak var filesCollection: UICollectionView!
    // vlc player instance
    let vedioPlayer = VLCMediaPlayer();
    // to store names of files
    var names : [String] = []
    var types : [String:URLFileResourceType] = [:]
    // keep track of path
    var pathStack : [String] = []
    // focus views
    var focusedElement: UIView!{
        didSet{
            setNeedsFocusUpdate()
            updateFocusIfNeeded()
        }
    }
    // start of the app
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("before")
        let source = SourceProvider.Save(name: "abc",
                            endpoint: "smb://192.168.0.102",
                            share: "eapple",
                            port: nil,
                            sourceType: SourceType.SMB,
                            username: "waseem ali",
                            password: "1234")
        //print(SourceProvider.LoadSources())
        //test = SMBProvider(source: SourceProvider.sources[0])
        //test.listDirectory(path: "/")
        //print(SourceProvider.sources.count)
        SourceProvider.activeSource = source
        pathStack.append("/")
        filesCollection.delegate = self
        filesCollection.dataSource = self
        
        getDirectory(path: pwd())
        focusedElement = filesCollection
       
        SourceProvider.ClearSources(in: "Source")
//        streamSMb(path: "/Downloads/agent/bond.mp4")
        // mb://user_name:password@server_name
//        startStream(url: "smb://92.168.0.101/eapple/downloads/pushpa.mkv")
        //var x = startStream(url: "smb://192.168.0.102/eapple/downloads/pushpa")
        //print(x)
        //playVideo(url: "smb://waseem ali:1234@192.168.0.101/eapple/downloads/pushpa" as! URL)
        
    }
    // stream media from url in vlc
    func startStream(url:URL)  {
//        print("playing")
//        guard let url = URL(string: url) else {print("url is not correct"); return};
        
        let movieView = UIView()
        movieView.backgroundColor = UIColor.gray
        movieView.frame = UIScreen.screens[0].bounds
        vlcView.backgroundColor = UIColor.gray
        vlcView.frame = UIScreen.screens[0].bounds
        //Add movieView to view controller
        view.addSubview(movieView)
        vedioPlayer.delegate = self
        vedioPlayer.drawable = movieView
        vedioPlayer.media =  VLCMedia(url: url)
        vedioPlayer.play()
        print("here")
    }
    func streamSMb(path : String){
        
        print("pathxx is \(path)");
        
        
        let provider = SMBProvider.init(source: SourceProvider.activeSource!)
        provider.connect { result in
            switch result {
            case .success( let client):
                print("geetting ")
        
                
                var f : String?
                do {
                    let appSupportDir = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    print(appSupportDir)
                    let filePath = appSupportDir.appendingPathComponent("av.mp4").path
                    f = filePath
                }
                catch  {
                    
                }
                
                
//                guard let fileUrl = Bundle.main.path(forResource: "temp", ofType: "mp4") else{
//                    print("url1 is not correct");
//                    return
//                }
               
                let url = URL(fileURLWithPath: f!)
                print("lalal \(f!)")
                client.downloadItem(atPath: path, to: url) { bytes, total in
                    print("bytes \(bytes)")
                   
//                    self.startStream(url: url)
                    return true
                } completionHandler: { error in
                    print("error of steam\(error)")
                    DispatchQueue.main.async {
                        self.startStream(url: url)
                    }
                    
                }

                


            case .failure(_):
                print("failed")
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "filesCollection", for: indexPath) as! FileCell
        cell.label.text = names[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)  as! FileCell
       
        if let path = cell.label.text{
            if(types[path] != URLFileResourceType.directory){
                streamSMb(path: pwd()+path)
                
            }else {
                pathStack.append(path)
                getDirectory(path: pwd())
            }
            
        }
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        if(pathStack.count != 0){
            pathStack.removeLast()
        }
        getDirectory(path: pwd())
    }
    
    
    func getDirectory(path:String)  {
        names = []
        types.removeAll();
        
        
        let provider = SMBProvider.init(source: SourceProvider.activeSource!)
        provider.connect { result in
            switch result {
            case .success(let client):
                print("clinet url is \(client.url)")
                client.contentsOfDirectory(atPath: path) { result in
                
                    switch result {
                    case .success(let files):
                        
                        for entry in files {
                            
                            print(" name ",entry[.nameKey] as! String,"type:", entry[.fileResourceTypeKey] as! URLFileResourceType)
                            if((entry[.nameKey] as! String).first != "."){
                                self.names.append(entry[.nameKey] as! String)
                                self.types[entry[.nameKey] as! String] = entry[.fileResourceTypeKey] as! URLFileResourceType;
                            }
                           
                            
                        }
                        DispatchQueue.main.async {
                            self.filesCollection.reloadData()
                        }
                    case .failure(let error):
                        print("error Message")
                        print(error)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
       

    }
    
    
    @IBAction func pathTextView(_ sender: Any) {
        
        
    }
    
    @IBOutlet weak var pathText: UITextField!
    
    func pwd() ->String  {
        var path = "";
        for dir in pathStack {
            if(dir == "/"){
                path = "\(path)\(dir)"
            }else{
                path = "\(path)\(dir)/"
            }
        }
        print("path is \(path)");
        pathText.text = path
        return path
    }
    
   
    
    let vc = AVPlayerViewController()
    func playVideo(url: URL) {
        
        guard let path = Bundle.main.path(forResource: "testVedio", ofType:"mp4") else {
            debugPrint("video.m4v not found")
            return
        }
        let newurl = URL(fileURLWithPath: path)
        let player = AVPlayer(url:url)
        print("playing")
        vc.player = player
        vc.player?.play()
    

   }
}
    


//                client.contents(atPath: path) { offset, total, data in
//                    print("data")
//                    print(data)
//                    return true
//                } completionHandler: { error in
//                    print("error occureed :\(String(describing: error))")
//
//                }
