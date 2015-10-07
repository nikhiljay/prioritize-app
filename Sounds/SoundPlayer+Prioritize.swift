//
//  SoundPlayer+DesignerNewsApp.swift
//  DesignerNewsApp
//
//  Created by James Tang on 5/2/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

extension SoundPlayer {

    func playRefresh() {
        self.playSound("refresh.wav")
    }
    
    func playDone() {
        self.playSound("done.wav")
    }
    
    func playRejected() {
        self.playSound("rejected.aif")
    }
    
}