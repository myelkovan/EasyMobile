import Foundation
import SwiftUI




class v_viewtype: ViewController{
    
    

    @IBOutlet weak var cb_tableview: NSButton!
    @IBOutlet weak var cb_collectionview: NSButton!
    @IBOutlet weak var cb_singleview: NSButton!
    @IBOutlet weak var cbx_search: NSButton!
    @IBOutlet weak var cb_search_field: NSButton!
    @IBOutlet weak var cb_picture: NSButton!
    @IBOutlet weak var cb_picture_field: NSButton!
    
    
    override func viewWillAppear() {
        if gs_search_field.count > 0{
            cb_search_field.title = gs_search_field
        }
    }
    
    @IBAction func cb_tableview_clicked(_ sender: Any) {
        cb_tableview.alphaValue = 1
        cb_collectionview.alphaValue = 0.2
        cb_singleview.alphaValue = 0.2
        cbx_search.isEnabled = true
        cb_search_field.isEnabled = true
        gi_viewtype = 1

   }
    
    @IBAction func cb_collectionview_clicked(_ sender: Any) {
        cb_tableview.alphaValue = 0.2
        cb_collectionview.alphaValue = 1
        cb_singleview.alphaValue = 0.2
        cbx_search.isEnabled = true
        cb_search_field.isEnabled = true
        gi_viewtype = 2

  }
    
    
    @IBAction func cb_singleview_clicked(_ sender: Any) {
        cb_tableview.alphaValue = 0.2
        cb_collectionview.alphaValue = 0.2
        cb_singleview.alphaValue = 1
        cbx_search.isEnabled = false
        cb_search_field.isEnabled = false
        gi_viewtype = 3
    }
    
    
  
    @IBAction func cbx_search_clicked(_ sender: NSButton) {
        if sender.state == NSButton.StateValue.on{
            cb_search_field.isEnabled = true
        }else{
            cb_search_field.isEnabled = false
            gs_search_field = ""
        }
     }

    
    @IBAction func cb_picture_clicked(_ sender: NSButton) {
        if sender.state == NSButton.StateValue.on{
            cb_picture_field.isEnabled = true
        }else{
            cb_picture_field.isEnabled = false
            gs_picture_field = ""
        }

    }
    
    @IBAction func cb_search_field_clicked(_ sender: NSButton) {
        performSegue(withIdentifier: "toColumn", sender: 1)
    }
    
    
    @IBAction func cb_picture_field_clicked(_ sender: NSButton) {
        performSegue(withIdentifier: "toColumn", sender: 2)
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any? ) {
        let target = segue.destinationController as! v_columns
        target.ii_search_picture = sender as! Int
    }
    
    
}
