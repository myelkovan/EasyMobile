//
//  system.swift
//  MY Code Generator
//
//  Created by Murat Yelkovan on 25.06.2022.
//

import Foundation
import SwiftUI

func of_getFolderName(pickFolder ab_pickFolder: Bool)-> String{
    let openPanel = NSOpenPanel();
    openPanel.canChooseDirectories = ab_pickFolder;
    openPanel.canChooseFiles = !ab_pickFolder;
    
    if(openPanel.runModal() == NSApplication.ModalResponse.OK) {
        return openPanel.url!.absoluteString 
    }
    return ""
}


func messagebox(_ as_title: String, _ as_message:String ){
    let alert = NSAlert()
    alert.messageText = as_title
    alert.informativeText = as_message
    alert.alertStyle = .warning
    alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn
}
