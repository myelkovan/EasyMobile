//
//  storyboard.swift
//  MY Code Generator
//
//  Created by Murat Yelkovan on 3.07.2022.
//

import Foundation






func of_update_storyboard(){
    var ls_template = ""
    var ls_object_name = ""
    var ls_connection = ""
    var ls_object_id = ""
    var ls_obj_template = ""
    var ls_objects = ""
    var li_y = 14, li_add = 0
    var ls_file = ""

    if (gs_template_folder == ""){
        return
    }

    if gb_create_view == false{
        return
    }
  
    //create edilecek objelerin default kodlari
    let ls_textfield = "<textField opaque=\"NO\" enabled=\"NO\" contentMode=\"scaleToFill\" contentHorizontalAlignment=\"left\" contentVerticalAlignment=\"center\" " +
        "borderStyle=\"roundedRect\" textAlignment=\"natural\" minimumFontSize=\"17\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"#ID30#\">\r\n\t\t\t\t" +
        "<rect key=\"frame\" x=\"20\" y=\"14\" width=\"340\" height=\"34\"/>\r\n\t\t\t\t" +
        "<fontDescription key=\"fontDescription\" type=\"system\" pointSize=\"14\"/>\r\n\t\t\t\t" +
        "<textInputTraits key=\"textInputTraits\"/>\r\n\t\t\t\t" +
        "</textField>\r\t\t\t\t"


    let ls_label = "<label opaque=\"NO\" userInteractionEnabled=\"NO\" contentMode=\"left\" horizontalHuggingPriority=\"251\"  verticalHuggingPriority=\"251\" fixedFrame=\"YES\"\r\n" +
           "text=\"Label\" textAlignment=\"natural\" lineBreakMode=\"tailTruncation\" numberOfLines=\"0\" baselineAdjustment=\"alignBaselines\" adjustsFontSizeToFit=\"NO\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"#ID30#\">\r\n\t\t\t\t" +
           "<rect key=\"frame\" x=\"20\" y=\"14\" width=\"374\" height=\"35\"/>\r\n\t\t\t\t" +
           "<autoresizingMask key=\"autoresizingMask\" flexibleMaxX=\"YES\" flexibleMaxY=\"YES\"/>\r\n\t\t\t\t" +
           "<fontDescription key=\"fontDescription\" type=\"system\" pointSize=\"17\"/>\r\n\t\t\t\t" +
           "<nil key=\"textColor\"/>\r\n\t\t\t\t" +
           "<nil key=\"highlightedColor\"/>\r\n\t\t\t\t" +
       "</label>\r\n"

    let ls_searchbar = "<searchBar key=\"tableHeaderView\" contentMode=\"redraw\" id=\"#ID100#\">\r\n\t\t\t\t" +
        "<rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"414\" height=\"44\"/>\r\n\t\t\t\t" +
        "<autoresizingMask key=\"autoresizingMask\" widthSizable=\"YES\" flexibleMaxY=\"YES\"/>\r\n\t\t\t\t" +
        "<textInputTraits key=\"textInputTraits\"/>\r\n\t\t\t\t" +
        "<connections>\r\n\t\t\t\t" +
        "    <outlet property=\"delegate\" destination=\"#IDVIEW#\" id=\"#ID101#\"/>\r\n\t\t\t\t" +
        "</connections>\r\n\t\t\t\t" +
    "</searchBar>\r\n"

    let ls_textview = "<textView clipsSubviews=\"YES\" multipleTouchEnabled=\"YES\"" + "contentMode=\"scaleToFill\" fixedFrame=\"YES\" textAlignment=\"natural\"" + "translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"#ID30#\">\r\n\t\t\t\t" +
        "<rect key=\"frame\" x=\"9\" y=\"14\" width=\"374\" height=\"100\"/>\r\n\t\t\t\t" +
        "<autoresizingMask key=\"autoresizingMask\" flexibleMaxX=\"YES\" flexibleMaxY=\"YES\"/>\r\n\t\t\t\t" +
        "<color key=\"backgroundColor\" systemColor=\"systemBackgroundColor\"/>\r\n\t\t\t\t" +
        "<color key=\"textColor\" systemColor=\"labelColor\"/>\r\n\t\t\t\t" +
        "<fontDescription key=\"fontDescription\" type=\"system\" pointSize=\"14\"/>\r\n\t\t\t\t" +
        "<textInputTraits key=\"textInputTraits\" autocapitalizationType=\"sentences\"/>\r\n\t\t\t\t" +
    "</textView>\r\n"

    let ls_imageview = "<imageView clipsSubviews=\"YES\" userInteractionEnabled=\"NO\" contentMode=\"scaleAspectFit\" " + "horizontalHuggingPriority=\"251\" verticalHuggingPriority=\"251\" fixedFrame=\"YES\"\r\n\t\t\t\t" + "translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"#ID30#\">\r\n\t\t\t\t" +
        "<rect key=\"frame\" x=\"20\" y=\"14\" width=\"142\" height=\"100\"/>\r\n\t\t\t\t" +
        "<autoresizingMask key=\"autoresizingMask\" flexibleMaxX=\"YES\" flexibleMaxY=\"YES\"/>\r\n\t\t\t\t" +
        "</imageView>\r\n"

    
    
    //template dosyayı oku
    switch gi_viewtype{
    case 1:
        ls_file = gs_template_folder + "/storyboard_tableview.txt"
    case 2:
        ls_file = gs_template_folder + "/storyboard_collectionview.txt"
    case 3:
        ls_file = gs_template_folder + "/storyboard_view.txt"
        li_y += 100
    default:
        print("")
    }

    ls_template = file().of_read(ls_file)
    if ls_template == ""{
        return
    }

    //default yapılması gereken değişiklikleri yap
    ls_template = ls_template.replacingOccurrences(of: "#ID1#", with: of_generateID())
    ls_template = ls_template.replacingOccurrences(of: "#ID2#", with: of_generateID())
    ls_template = ls_template.replacingOccurrences(of: "#ID3#", with: of_generateID())
    ls_template = ls_template.replacingOccurrences(of: "#ID4#", with: of_generateID())
    ls_template = ls_template.replacingOccurrences(of: "#ID5#", with: of_generateID())
    ls_template = ls_template.replacingOccurrences(of: "#ID6#", with: of_generateID())
    ls_template = ls_template.replacingOccurrences(of: "#ID7#", with: of_generateID())
    ls_template = ls_template.replacingOccurrences(of: "#ID8#", with: of_generateID())
    ls_template = ls_template.replacingOccurrences(of: "#ID9#", with: of_generateID())
    ls_template = ls_template.replacingOccurrences(of: "#ID10#", with: of_generateID())
    ls_template = ls_template.replacingOccurrences(of: "#ID11#", with: of_generateID())
    ls_template = ls_template.replacingOccurrences(of: "#ID12#", with: of_generateID())
    ls_template = ls_template.replacingOccurrences(of: "#IDCELL#", with: of_generateID())
    ls_template = ls_template.replacingOccurrences(of: "#PROJECTNAME#", with: "")
    ls_template = ls_template.replacingOccurrences(of: "#VIEVNAME#", with: "v_" + gs_appName)
    ls_template = ls_template.replacingOccurrences(of: "#CELLNAME#", with: "c_" + gs_appName)
    

    // Outlet objeler için tüm column'ları dolaş stroty board da obje oluştur
    for row in SqlColumns{
        
        // Sıradaki column image olarak görünsün diye seçildiyse imageview,
        // column updatatable ise textfield, 50 den büyükse textview updatable değilse label
        if row.column_name! == gs_picture_field{
            ls_object_name = "p_" + row.column_name!
            ls_obj_template = ls_imageview
            li_add = 100
        }else{
           if gsA_updatable_columns.contains(row.column_name!){
                if row.column_lenght! < 50{
                    ls_object_name = "tf_" + row.column_name!
                    ls_obj_template = ls_textfield
                    li_add = 45
                }else{
                    ls_object_name = "lv_" + row.column_name!
                    ls_obj_template = ls_textview
                    li_add = 100
                }
            }else{
                ls_object_name = "lb_" + row.column_name!
                ls_obj_template = ls_label
                li_add = 45
            }
        }
        
        //sıradaki column için ilgili objeyi templatten oluştur, y değerini ata
        ls_object_id = of_generateID()
        ls_obj_template=ls_obj_template.replacingOccurrences(of: "#ID30#", with: ls_object_id)
        ls_obj_template=ls_obj_template.replacingOccurrences(of: "y=\"14\"", with: "y=\""+String(li_y)+"\"")
        ls_objects += ls_obj_template + "\r\t\t\t\t"
        li_y += li_add
        
        //üretilen obje için cell için bağlantı linklerini oluştur
        ls_connection += "<outlet property=\"" + ls_object_name + "\" destination=\"" + ls_object_id + "\" id=\"" + of_generateID() + "\"/>\r\t\t\t\t"
    }

    //yeni obje ve connection'ları asıl template içine yerleştir
    ls_connection = "<connections>\r" + ls_connection + "</connections>"
    ls_template = ls_template.replacingOccurrences(of: "#CONNECTIONS#", with: ls_connection)
    ls_template = ls_template.replacingOccurrences(of: "#OBJECTS#", with: ls_objects)

    //search field seçilmişse searchbar templatinden obje oluştur
    ls_obj_template = ""
    ls_connection = ""
    if gs_search_fields.count > 0{
        ls_obj_template = ls_searchbar
        let ls_searchbar_id = of_generateID()
        ls_obj_template=ls_obj_template.replacingOccurrences(of: "#ID100#", with: ls_searchbar_id)
        ls_obj_template=ls_obj_template.replacingOccurrences(of: "#ID101#", with: of_generateID())
        
        //searchbar view objemize outlet olarak ekleniyor
        ls_connection = "<outlet property=\"searchbar\" destination=\"" + ls_searchbar_id + "\" id=\"" + of_generateID() + "\"/>\r\t\t\t\t"
        ls_connection = "<connections>\r" + ls_connection + "</connections>"

        //collectionview için küçük bir değişiklik
        if gi_viewtype == 2{
            ls_obj_template=ls_obj_template.replacingOccurrences(of: "tableHeaderView", with: "sectionHeaderView")
        }
    }
    
    ls_template = ls_template.replacingOccurrences(of: "#SEARCHBAR#", with: ls_obj_template)
    ls_template = ls_template.replacingOccurrences(of: "#IDVIEW#", with: of_generateID())
    ls_template = ls_template.replacingOccurrences(of: "#CONNECTION_SEARCHBAR#", with: ls_connection)

    
    //gerçek storyboard içeriğini al
    var ls_storyboard_path = ""
    if gs_storyboard_path == "" {
        messagebox("Select StoryBoard File","Please select storyboard file in your target Xcode project. If you don't select a file, no view will be created for storyboard.")
        ls_storyboard_path = of_getFolderName(pickFolder :false)
        gs_storyboard_path = ls_storyboard_path

        if ls_storyboard_path == "" || ls_storyboard_path == nil{
            return
        }
     }
    
      
    if gb_reset_storyboard {
        ls_storyboard_path = gs_storyboard_path
    }else{
        ls_storyboard_path = gs_created_storyboard_path
    }

    ls_file = ls_storyboard_path.right(find: "/")
    var ls_content = file().of_read(ls_storyboard_path )
    
    //temlateden alıp düzenlediğimizi gerçeğin içine </scenes> sonrasina ekle
    ls_content = ls_content.of_left("</scenes>")! + "\r" + ls_template + "\r</scenes>" +  ls_content.of_right("</scenes>")!
    
    // hedef dosyaya yaz
    let documentsPath = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true)[0] as NSString?
    gs_created_storyboard_path = "file://" + documentsPath!.appendingPathComponent("SWIFT/" + gs_appName + "/" + ls_file)
    file().of_write(filename: "SWIFT/" + gs_appName + "/" + ls_file, content :ls_content)
    
    print("SWIFT/" + gs_appName + "/" + ls_file)
    print(gs_created_storyboard_path)
}

    


    
//Object id üret Ör: mCJ-hg-J39
func of_generateID()-> String{
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    return randomString(length: 3) + "-" + randomString(length: 2) + "-" + randomString(length: 3)
}
