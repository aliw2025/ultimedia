//
//  ThumnailCell.swift
//  Ultimedia
//
//  Created by Waseem Ali on 07/06/2022.
//

import Foundation
import TVUIKit
import AVKit


class FileCell : UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.nextFocusedView == self {
            self.contentView.backgroundColor = UIColor.gray
            
            
        }else{
            self.contentView.backgroundColor = UIColor.clear
            
        }
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
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.vedioView.frame
//        self.view.layer.addSublayer(playerLayer)
//        self.view.layer.addSublayer(btnPanel.layer)
//        player.play()
//        focusedElement = progressBar
//        present(vc, animated: true) {
//
//            self.vc.showsPlaybackControls = false
//            self.vc.player?.play()
//        }
        //self.player = player
//        testView.frame = CGRect(x: 0, y: view.frame.height-200, width: view.frame.width, height: 200)

        
     
   }
}
