//
//  v_connect.swift
//  MY Code Generator
//
//  Created by Murat Yelkovan on 17.06.2022.
//

import Foundation
import SwiftUI







class v_main: ViewController, NSTableViewDelegate, NSTableViewDataSource{
    @IBOutlet weak var cb_next: NSButton!
    @IBOutlet weak var cb_back: NSButton!
    @IBOutlet weak var cb_generate: NSButton!
    var ii_page = 1
   
    private lazy var v_sql: v_sql = {
        let storyboard = NSStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateController(withIdentifier: "v_sql") as! v_sql
    }()
    
    private lazy var v_updatable: v_updatable = {
        let storyboard = NSStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateController(withIdentifier: "v_updatable") as! v_updatable
    }()
 
    private lazy var v_viewtype: v_viewtype = {
        let storyboard = NSStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateController(withIdentifier: "v_viewtype") as! v_viewtype
    }()

    
    private func add(asChildViewController viewController: NSViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
    }
    
    private func remove(asChildViewController viewController: NSViewController) {
        viewController.viewWillDisappear()
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //template klasorlerini global degiskene al
        gs_template_folder = UserDefaults.standard.string(forKey: "template_folder") ?? ""
        gs_default_folder = UserDefaults.standard.string(forKey: "default_folder") ?? ""
        
        //ncere resize yapilamasinpe
        self.view.window?.styleMask.remove(NSWindow.StyleMask.resizable)
        preferredContentSize = view.frame.size
        //sql ekraniniekrana goster
        add(asChildViewController: v_sql)
    }
    
    
    
    @IBAction func cb_next_clicked(_ sender: Any) {
        
         if ii_page == 1{
             if v_sql.of_finish() == -1 {
                 return
             }
             
            if (gb_delete || gb_insert){
                ii_page = 2
                of_showUpdatable()
            }else{
               ii_page = 3
               of_showViewtype()
            }
         } else if ii_page == 2{
             if v_updatable.of_finish() == -1{
                 return
             }
            ii_page = 3
            of_showViewtype()
        }
    }
  
    @IBAction func cb_back_clicked(_ sender: Any) {
        if ii_page == 2{
            ii_page = 1
            of_showSql()
        }else if ii_page == 3{
            if (gb_delete || gb_insert){
                ii_page = 2
                of_showUpdatable()
            }else{
                ii_page = 1
                of_showSql()
            }
        }
    }
    
  
    func of_showSql(){
        v_sql.view.isHidden = false
        v_viewtype.view.isHidden = true
        v_updatable.view.isHidden = true
        cb_back.isEnabled = false
        cb_next.isEnabled = true
        cb_generate.isEnabled = false
        remove(asChildViewController: v_updatable)
        remove(asChildViewController: v_viewtype)
      }
  
    func of_showUpdatable(){
        add(asChildViewController: v_updatable)
        v_updatable.view.isHidden = false
        v_sql.view.isHidden = true
        v_viewtype.view.isHidden = true
        cb_back.isEnabled = true
        cb_back.isEnabled = true
        cb_next.isEnabled = true
        cb_generate.isEnabled = false
        remove(asChildViewController: v_viewtype)
    }
    
    func of_showViewtype(){
        add(asChildViewController: v_viewtype)
        v_viewtype.view.isHidden = false
        cb_generate.isEnabled = true
        cb_back.isEnabled = true
        cb_next.isEnabled = false
        v_updatable.view.isHidden = true
        v_sql.view.isHidden = true
        remove(asChildViewController: v_updatable)
      }

    
    
  
    
    
    @IBAction func cb_generate_clicked(_ sender: Any) {
        if v_viewtype.of_finish() == -1{
            return 
        }
        
        if gs_storyboard_path != ""{
            let alert = NSAlert()
            alert.messageText = "Be Careful!"
            alert.informativeText = "Do you want to add this view in the last generated storyboard or start with original storyboard again?"
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Add to the last generated storyboard.")
            alert.addButton(withTitle: "Start again with the one you lastly selected.")
            if alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn{
                gb_reset_storyboard = false
            }else{
                gb_reset_storyboard = true
            }
        }

        // onceki projeye ait degiskenleri resetle
        gs_search_fields = []
        gs_last_appName = gs_appName
        of_create_php()
        of_create_swift()
        of_update_storyboard()
        messagebox("Code Generation","Done")

    }
    
        
    
    
}
