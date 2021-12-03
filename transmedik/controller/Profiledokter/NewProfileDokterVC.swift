//
//  NewProfileDokterVC.swift
//  transmedik
//
//  Created by Idham Kurniawan on 18/11/21.
//

import UIKit
import Kingfisher

class NewProfileDokterVC: UIViewController {

    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var nameDokter: UILabel!
    @IBOutlet weak var specialist: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var pengalaman: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var alumni: UILabel!
    @IBOutlet weak var praktek: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var viewInformation: UIView!
    @IBOutlet weak var nostr: UILabel!
    

    
    var data : Newdetailtanyadokter!
    var uuid = ""
    var profil = Doctors()
    var presentPage : PresentPage!
    var isform = false
    var list : [listformmodel] = []
    var header = ""
    var facilityid = ""
    var id = ""
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        layout()
        getdatadokter()
        self.view.layoutIfNeeded()
    }
    
    
    func getdatadokter(){
        if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
            let param : [String : Any ] = ["specialist_slug" : self.specialist,
                                           "uuid_doctor" : self.uuid]
            self.profil.getdokter(token: token, id: self.uuid) { (data) in
                if data != nil {
                    let edu = data!.educations.map{ $0.education}
                    self.alumni.text =  edu.joined(separator: ",").count == 0 ? "-" : edu.joined(separator: ",")
                    self.praktek.text = data!.facilitiesstring
                    self.nostr.text = data!.no_str
                    
                }
                
             
            }
        }
        
     
    }
    func layout(){
        let url = URL(string: data.profile_picture ?? "")
        photo.kf.setImage(with: url)
        viewStatus.layer.cornerRadius = 6
        nameDokter.text = data.full_name
        specialist.text = header
        chatButton.layer.cornerRadius = 10
        price.text = "Rp 0"
        rate.text = "Rp \(Int(data!.rates)!.formattedWithSeparator)"
        pengalaman.text = data.experience
        viewInformation.layer.cornerRadius = 10
        viewInformation.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        
     
        if data.status_docter == "Online"{
            chatButton.backgroundColor = Colors.buttonActive
            viewStatus.backgroundColor = Colors.buttonActive
            status.text = "Available"
        }else{
            chatButton.backgroundColor = Colors.buttonnonActive
            viewStatus.backgroundColor = Colors.buttonnonActive
            status.text = "Not Available"


        }
        
    }
    
    
    
    @IBAction func chatOnClick(_ sender: Any) {
        
//        let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "NewCheckConsulVC") as? NewCheckConsulVC
//        vc?.presentPage = presentPage
//
////        vc?.pageOrigin = .consulProfile
////        vc?.fromprofile = true
////        vc?.specialisttxt = data.specialist
////        vc?.ratetxt = Int(data.rates)!
////        vc?.uuiddoctor = data.uuid
//        openVC(vc!, presentPage)
////        present(vc!, animated: true, completion: nil)
//
        let vc = UIStoryboard(name: "Chat", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "NewCheckConsulVC") as? NewCheckConsulVC
        vc?.header = header
        vc?.list = list
        vc?.isform = isform
//        vc?.presentPage = self.presentPage
        vc?.facilityid = facilityid
        vc?.id = id
        vc?.uuid = data.uuid
        present(vc!, animated: true, completion: nil)
//        openVC(vc!, presentPage)

    }
    
    @IBAction func backOnClick(_ sender: Any) {
       keluar(view: presentPage)
    }
    
}




