//
//  v_connect.swift
//  MY Code Generator
//
//  Created by Murat Yelkovan on 4.07.2022.
//

import Foundation
import SwiftUI


class v_connect: ViewController, NSTextFieldDelegate, NSTextDelegate{

    @IBOutlet weak var tf_ip: NSTextField!
    @IBOutlet weak var tf_port: NSTextField!
    @IBOutlet weak var tf_database: NSTextField!
    @IBOutlet weak var tf_username: NSTextField!
    @IBOutlet weak var tf_password: NSTextField!
    @IBOutlet weak var tf_1: NSTextField!
    @IBOutlet weak var tf_2: NSTextField!
    @IBOutlet weak var tf_3: NSTextField!
    @IBOutlet weak var tf_4: NSTextField!
    @IBOutlet weak var tf_5: NSTextField!
    @IBOutlet weak var tf_6: NSTextField!
    @IBOutlet weak var tf_7: NSTextField!
    var is_last_selected = "0"
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tf_1.delegate = self
        tf_2.delegate = self
        tf_3.delegate = self
        tf_4.delegate = self
        tf_5.delegate = self
        tf_6.delegate = self
        tf_7.delegate = self
        
       
        //soldaki labellara tıklanırsa diye bir event ekle daha iyi bir yol bulamadım
        let gesture = NSClickGestureRecognizer()
        gesture.buttonMask = 0x1 // left mouse
        gesture.numberOfClicksRequired = 1
        gesture.target = self
        gesture.action = #selector(self.clicked1(_:))
        tf_1.addGestureRecognizer(gesture)

        let gesture2 = NSClickGestureRecognizer()
        gesture2.buttonMask = 0x1 // left mouse
        gesture2.numberOfClicksRequired = 1
        gesture2.target = self
        gesture2.action = #selector(self.clicked2(_:))
        tf_2.addGestureRecognizer(gesture2)
        
        let gesture3 = NSClickGestureRecognizer()
        gesture3.buttonMask = 0x1 // left mouse
        gesture3.numberOfClicksRequired = 1
        gesture3.target = self
        gesture3.action = #selector(self.clicked3(_:))
        tf_3.addGestureRecognizer(gesture3)

        let gesture4 = NSClickGestureRecognizer()
        gesture4.buttonMask = 0x1 // left mouse
        gesture4.numberOfClicksRequired = 1
        gesture4.target = self
        gesture4.action = #selector(self.clicked4(_:))
        tf_4.addGestureRecognizer(gesture4)

        let gesture5 = NSClickGestureRecognizer()
        gesture5.buttonMask = 0x1 // left mouse
        gesture5.numberOfClicksRequired = 1
        gesture5.target = self
        gesture5.action = #selector(self.clicked5(_:))
        tf_5.addGestureRecognizer(gesture5)

        let gesture6 = NSClickGestureRecognizer()
        gesture6.buttonMask = 0x1 // left mouse
        gesture6.numberOfClicksRequired = 1
        gesture6.target = self
        gesture6.action = #selector(self.clicked6(_:))
        tf_6.addGestureRecognizer(gesture6)

        let gesture7 = NSClickGestureRecognizer()
        gesture7.buttonMask = 0x1 // left mouse
        gesture7.numberOfClicksRequired = 1
        gesture7.target = self
        gesture7.action = #selector(self.clicked7(_:))
        tf_7.addGestureRecognizer(gesture7)


        //soldaki connection adlarını oku ekrana yaz
        tf_1.stringValue = UserDefaults.standard.string(forKey: "label1") ?? ""
        tf_2.stringValue = UserDefaults.standard.string(forKey: "label2") ?? ""
        tf_3.stringValue = UserDefaults.standard.string(forKey: "label3") ?? ""
        tf_4.stringValue = UserDefaults.standard.string(forKey: "label4") ?? ""
        tf_5.stringValue = UserDefaults.standard.string(forKey: "label5") ?? ""
        tf_6.stringValue = UserDefaults.standard.string(forKey: "label6") ?? ""
        tf_7.stringValue = UserDefaults.standard.string(forKey: "label7") ?? ""
  
         
    }
 
    override func viewDidDisappear() {
        of_save(is_last_selected)
    }

    override func viewWillAppear() {
        //son seçilen adı seç
        is_last_selected = UserDefaults.standard.string(forKey: "Last_Connected") ?? "1"
        switch is_last_selected{
        case "1":
            select(tf_1, save:false)
        case "2":
            select(tf_2, save:false)
        case "3":
            select(tf_3, save:false)
        case "4":
            select(tf_4, save:false)
        case "5":
            select(tf_5, save:false)
        case "6":
            select(tf_6, save:false)
        case "7":
            select(tf_7, save:false)
        default:
            select(tf_1, save:false)
        }
 
    }

    
    @IBAction func clicked1(_ sender: NSGestureRecognizer) {
        select(tf_1)
    }
    @IBAction func clicked2(_ sender: NSGestureRecognizer) {
        select(tf_2)
    }
    @IBAction func clicked3(_ sender: NSGestureRecognizer) {
        select(tf_3)
    }
    @IBAction func clicked4(_ sender: NSGestureRecognizer) {
        select(tf_4)
    }
    @IBAction func clicked5(_ sender: NSGestureRecognizer) {
        select(tf_5)
    }
    @IBAction func clicked6(_ sender: NSGestureRecognizer) {
        select(tf_6)
    }
    @IBAction func clicked7(_ sender: NSGestureRecognizer) {
        select(tf_7)
    }

    
    func select(_ tf_selected: NSTextField, save : Bool = true){
        //renkleri ayarla seçilen görünür olsun
        tf_1.alphaValue = 0.2
        tf_2.alphaValue = 0.2
        tf_3.alphaValue = 0.2
        tf_4.alphaValue = 0.2
        tf_5.alphaValue = 0.2
        tf_6.alphaValue = 0.2
        tf_7.alphaValue = 0.2
        tf_selected.alphaValue = 1
        view.window?.makeFirstResponder(tf_selected)
 
   
        
        //son seçilenin verilerini kaydet
        if save{
            of_save(is_last_selected)
        }

        //yeni seçilenin bilgilerini al ekrana yaz
        is_last_selected = String(tf_selected.tag)
        tf_ip.stringValue = UserDefaults.standard.string(forKey: "ip" + is_last_selected) ?? ""
        tf_port.stringValue = UserDefaults.standard.string(forKey: "port" + is_last_selected) ?? ""
        tf_database.stringValue = UserDefaults.standard.string(forKey: "database" + is_last_selected) ?? ""
        tf_username.stringValue = UserDefaults.standard.string(forKey: "username" + is_last_selected) ?? ""
        tf_password.stringValue = UserDefaults.standard.string(forKey:  "password" + is_last_selected) ?? ""
  
        
    }
 
   
    
    func of_save(_ selected : String){
        //tüm database adlarını label'ları kayded
        UserDefaults.standard.set(tf_1.stringValue, forKey: "label1")
        UserDefaults.standard.set(tf_2.stringValue, forKey: "label2")
        UserDefaults.standard.set(tf_3.stringValue, forKey: "label3")
        UserDefaults.standard.set(tf_4.stringValue, forKey: "label4")
        UserDefaults.standard.set(tf_5.stringValue, forKey: "label5")
        UserDefaults.standard.set(tf_6.stringValue, forKey: "label6")
        UserDefaults.standard.set(tf_7.stringValue, forKey: "label7")
        
        //son seçilenin verilerini kaydet
        UserDefaults.standard.set(tf_ip.stringValue, forKey: "ip" + selected)
        UserDefaults.standard.set(tf_port.stringValue, forKey: "port" + selected)
        UserDefaults.standard.set(tf_database.stringValue, forKey: "database" + selected)
        UserDefaults.standard.set(tf_username.stringValue, forKey: "username" + selected)
        UserDefaults.standard.set(tf_password.stringValue, forKey:  "password" + selected)
    }
    
    
    
    
    @IBAction func cb_connect_clicked(_ sender: Any) {
        //son seçilen database adı ve bağlantı bilgileri diskte kayıtlı
        UserDefaults.standard.set(is_last_selected, forKey: "Last_Connected")
        of_save(is_last_selected)
        
        if let con = database().of_connect(){
            try! con.close()
            DbColumns = [column]()   //resetlemezsek tablo adları tekrar okunmaz
            messagebox("Database Connection", "Success")
        }
    }

        
   
    
}
