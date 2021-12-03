//
//  NewCheckConsulVC.swift
//  transmedik
//
//  Created by Idham Kurniawan on 17/11/21.
//

import UIKit
import SkeletonView
import DropDown
import Kingfisher
import Alamofire

public enum PresentPage{
    case present
    case navigation
}


class NewCheckConsulVC: UIViewController,UITextViewDelegate {
  
    @IBOutlet weak var navigation: UIView!

    @IBOutlet weak var spesialis: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var desStatus: UILabel!
    
    @IBOutlet weak var viewInformasi: UIView!
    
    @IBOutlet weak var myUser: UIButton!
    @IBOutlet weak var myPhoto: UIImageView!
    
    @IBOutlet weak var umur: UILabel!
    @IBOutlet weak var BB: UILabel!
    @IBOutlet weak var TB: UILabel!
    
    @IBOutlet weak var editProfileButton: UIView!
    
    @IBOutlet weak var konfirmasiButton: UIButton!
    @IBOutlet weak var viewForm: UIView!
    @IBOutlet weak var radioButton: UIImageView!
    
    @IBOutlet weak var tbtxt: UILabel!
    @IBOutlet weak var bbtxt: UILabel!
    @IBOutlet weak var umurtxt: UILabel!
    var loading  = 0{
        didSet{
            if success && loading == 3 {
                if mdata.count > 0 {
                    setupChooseDropDown()
                    hideskeleton()
                }
                
            }else if (!success && loading == 3){

                Toast.show(message: "Terjadi masalah pada server. coba beberapa saat lagi", controller: self)
            }
        }
    }
    var success = false
    var mdata :[ModelProfile] = []
    var present : PresentPage!
    var statusDoctor = true
    let chooseDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseDropDown,
            
        ]
    }()
    var row = 0
    var selected = 0
    var list : [listformmodel] = []
    var header = ""
    var isform = false
    var facilityid : String?
    var uuid = ""
    var detaildokter:Detaildokter!
    var id = ""
    var presentPage : PresentPage!
    var statussend = false{
        didSet{
            if statussend{
                konfirmasiButton.isUserInteractionEnabled = true
                konfirmasiButton.backgroundColor = Colors.buttonActive
                radioButton.image = UIImage(named: "Check-1", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            }else{
                konfirmasiButton.isUserInteractionEnabled = false
                konfirmasiButton.backgroundColor = Colors.buttonnonActive
                radioButton.image = UIImage(named: "checked", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            }
        }
    }
    
    
    override func viewDidLoad() {
     
        koneksi()
        skeleton()
        setup()
    }
    
    func skeleton(){
        name.showAnimatedSkeleton()
        spesialis.showAnimatedSkeleton()
        myPhoto.showAnimatedSkeleton()
        BB.showAnimatedSkeleton()
        TB.showAnimatedSkeleton()
        umur.showAnimatedSkeleton()
        bbtxt.showAnimatedSkeleton()
        editProfileButton.showAnimatedSkeleton()
        tbtxt.showAnimatedSkeleton()
        umurtxt.showAnimatedSkeleton()
        viewStatus.showAnimatedSkeleton()


    }
 
    func hideskeleton(){
        name.hideSkeleton()
        spesialis.hideSkeleton()
        photo.hideSkeleton()
        BB.hideSkeleton()
        TB.hideSkeleton()
        umur.hideSkeleton()
        bbtxt.hideSkeleton()
        editProfileButton.hideSkeleton()
        tbtxt.hideSkeleton()
        umurtxt.hideSkeleton()
        viewStatus.hideSkeleton()
    }
    
    func selectsending(){
        if list.count > 0{
            for index in list{
                if index.required && index.jawaban == ""{
                    statussend = false
                    return
                }
            }
            statussend = true
          
            
        }
    }
    
    
    func setupChooseDropDown() {
        chooseDropDown.anchorView = myUser
        
        chooseDropDown.bottomOffset = CGPoint(x: 0, y: myUser.bounds.height)
        
        
        let temp = mdata.map{ $0.full_name}
        chooseDropDown.dataSource = temp
        
        chooseDropDown.selectionAction = { [weak self] (index, item) in
            self?.selected = index
            self?.myUser.setTitle(item, for: .normal)
        }
    }
    func setDokter() {
        name.text = detaildokter.full_name
        spesialis.text = header
        if statusDoctor {
            viewStatus.backgroundColor = Colors.buttonActive
            desStatus.text = "Available"
            
        }else{
            viewStatus.backgroundColor = Colors.buttonnonActive
            desStatus.text = "Not Available"
        }
    }
    
    func koneksi(){
       
        if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
            let profile = Profile()
            let dokter = Doctors()

                
                profile.getprofile(token: token) { (data,msg) in
                    if msg.contains("Unauthenticated"){
                        UserDefaults.standard.set(true, forKey: "logout")
                        self.dismiss(animated: false, completion: nil)
                        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
                    }
                    if data != nil {
                        print("my name = >\(data!.full_name)")
                        self.mdata.insert(data!, at: 0)
                        self.success = true
                    }else{
                        self.success = false
                        
                    }
                    self.loading += 1
                }
                
                profile.getkeluarga(token: token) { (keluarga,status,msg) in
                    if msg.contains("Unauthenticated"){
                        UserDefaults.standard.set(true, forKey: "Unauthenticated")
                        self.dismiss(animated: false, completion: nil)
                        self.presentingViewController?.dismiss(animated: false, completion: nil)
                    }
                    if status{
                        if keluarga != nil {
                            for tempkeluarga in keluarga!{
                                self.mdata.append(tempkeluarga)
                            }
                            self.success = true
                            
                        }else{
                            self.success = true
                            
                        }
                    }else{
                        self.success = false

                    }
                    self.loading += 1
                
                }
                
            dokter.getdokter(token:token, id: self.uuid) { (data) in
                   
                    
                    if data != nil {
                        self.detaildokter = data!
                        self.success = true
                        self.setDokter()
                        
                    }else{
                        self.success = false
                        
                    }
                    self.loading += 1
                }
            }
        
        
    }
    
    func setup(){
        konfirmasiButton.isUserInteractionEnabled = false
        konfirmasiButton.backgroundColor = Colors.buttonnonActive
        konfirmasiButton.layer.cornerRadius = 10
        viewForm.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(form)))
        viewInformasi.layer.cornerRadius = 10
        viewForm.layer.cornerRadius = 10
        viewStatus.layer.cornerRadius = 8
        editProfileButton.layer.cornerRadius = 10
        self.view.backgroundColor = Colors.backgroundmaster
       
        


        shadow()
    }
    
    @objc func form() {
        let vc = UIStoryboard(name: "Form", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "newformsViewController") as? newformsViewController
        vc?.list = list
        vc?.delegates = self
        vc?.spesialis = id ?? ""
        vc?.klinik = facilityid ?? ""
        vc?.presentPage = self.presentPage

        
//        openVC(vc!, presentPage)
        present(vc!, animated: true, completion: nil)
    }
    
    func shadow(){
        navigation.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        viewInformasi.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        viewForm.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
    }
    
    @IBAction func backOnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func konfirmasiOnClick(_ sender: Any) {
     
        guard statussend else {
            return Toast.show(message: "Anda belum melengkapi form", controller: self)
        }
        
        let vc = UIStoryboard(name: "pinandpassword", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "insertpinViewController") as? insertpinViewController
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
                 
    }
    
    
    func edit() {
  
        let vc = UIStoryboard(name: "Edituser", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "edit_and_add_phrViewController") as? edit_and_add_phrViewController
        vc?.delegate = self
        
        vc?.uuid = mdata[row].uuid
        vc?.row = row
        vc?.typetambah = false
        vc?.presentPage = self.presentPage
        
        vc?.datauser = mdata[row]
        openVC(vc!, presentPage)
//        vc?.header.text = header

        
    }
    
    
    func chataction(pin : String){
            if UserDefaults.standard.bool(forKey: AppSettings.pin){
                let chatacc = Chat()
               
                
                var stringform = ""
                if self.list.count == 1{
                    
                    stringform = "[{\"answer\":\"\(self.list[0].jawaban)\",\"id\":\"\(self.list[0].id)\",\"question\":\"\(self.list[0].question)\"}]"
                }else{
                    for i in 0..<self.list.count{
                        if stringform == "" {
                            stringform = "[{\"answer\":\"\(self.list[i].jawaban)\",\"id\":\"\(self.list[i].id)\",\"question\":\"\(self.list[i].question)\"}"
                        }else{
                            if i == self.list.count - 1{
                                stringform = stringform + ",{\"answer\":\"\(self.list[i].jawaban)\",\"id\":\"\(self.list[i].id)\",\"question\":\"\(self.list[i].question)\"}]"
                            }else{
                                stringform = stringform + ",{\"answer\":\"\(self.list[i].jawaban)\",\"id\":\"\(self.list[i].id)\",\"question\":\"\(self.list[i].question)\"}"
                            }
                            
                        }
                    }
                    
                }
                
                var params : Parameters!
                if stringform != "" {
                     params  = [
                        "answers": stringform,
                        "medical_facility_id" : facilityid!,
                        "specialist_slug" : id,
                        "complaint" : "",
                        "email_doctor": detaildokter.email,
                        "email_patient" : UserDefaults.standard.string(forKey: AppSettings.email) ?? "",
                        "payment_id" : 2,
                        "payment_name": "Escrow",
                        "rates": detaildokter.rates,
                        "uuid_doctor" : detaildokter.uuid,
                        "uuid_patient" : UserDefaults.standard.string(forKey: AppSettings.uuid) ?? "",
                        "voucher" : "",
                        "voucher_amount" : 0
                    ]
                }else{
                     params  = [
                        
                        "medical_facility_id" : facilityid!,
                        "specialist_slug" : id,
                        "complaint" : "",
                        "email_doctor": detaildokter.email,
                        "email_patient" : UserDefaults.standard.string(forKey: AppSettings.email) ?? "",
                        "payment_id" : 2,
                        "payment_name": "Escrow",
                        "rates": detaildokter.rates,
                        "uuid_doctor" : detaildokter.uuid,
                        "uuid_patient" : UserDefaults.standard.string(forKey: AppSettings.uuid) ?? "",
                        "voucher" : "",
                        "voucher_amount" : 0
                    ]
                }
                print("param>>")
                print(params)
                
                chatacc.newstartkonsultasi(param: params) { (data,merchant_id,url) in
                    
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        
                        if data != nil {
                            
                            
                            print("kosong")
                            let vc = UIStoryboard(name: "Chat", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "WaitingConsulVC") as? WaitingConsulVC
                            
                            vc?.modalPresentationStyle = .fullScreen
                            vc?.modalTransitionStyle = .flipHorizontal
                            vc?.uuid_patient = UserDefaults.standard.string(forKey: AppSettings.uuid) ?? ""
                            vc?.uuid_doctor = self.detaildokter!.uuid
                            vc?.email_patient = UserDefaults.standard.string(forKey: AppSettings.email) ?? ""
                            vc?.email_doctor = self.detaildokter!.email
                            vc?.rates = Int(self.detaildokter!.rates)!
                            vc?.currentConsultation = data!

                            
                            
                            let encoder = JSONEncoder()
                            if let encoded = try? encoder.encode(data!) {
                                UserDefaults.standard.set(encoded, forKey: AppSettings.KEY_CURRENT_CONSULTATION)
                            }
                            
                            //
                            weak var pvc = self.presentingViewController
                            
                            self.dismiss(animated: false) {
                                pvc?.present(vc!, animated: true, completion: nil)
                                
                            }
                        }
                        else {
                            Toast.show(message: "Gagal memulai sesi konsultasi", controller: self)
                        }
                        
                    }
                }
                
                
                
                
                
//                if pin == "" {
//                    print("not pin")
//                    print(email)
//                    let param : Parameters = [
//                        "CHAINMERCHANT":"NA",
//                        "CURRENCY":"360",
//                        "PURCHASECURRENCY":360,
//                        "AMOUNT":"\(harga).00",
//                        "PURCHASEAMOUNT":"\(total).00",
//                        "EMAIL": email,
//                        "NAME": nama,
//                        "BASKET": "\(dokter),\(harga).00,1,\(total).00",
//                        "MOBILEPHONE": tlp
//
//
//                    ]
//
//                    self.chatacc.confirmConsultclinic(token: UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik)!, uuid_patient: UserDefaults.standard.string(forKey: AppSettings.uuid)!, uuid_doctor:  self.detaildokter!.uuid, email_patient: UserDefaults.standard.string(forKey: AppSettings.email)!, email_doctor: self.detaildokter!.email, rates: Int(self.detaildokter!.rates)!, jawab: stringform, medical_facility_id: self.facilityid!, voucher_amount: "\(self.getdiskon().0)", voucher: self.getdiskon().1, pin: pin, payment_id: self.pembayaran!.payment_id, payment_name: self.pembayaran!.payment_name, param: param, trans_merchant_id: "") { (data,merchant_id,url) in
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//
//                        self.delegate.loading(load: false)
//
//                        if data != nil {
//
//                            self.currentConsultationId = data!.consultation_id!
//                            self.consultationPostModel = data!
//                            print("ini print")
//                            print(url)
//                            if url == nil {
//                                print("kosong")
//                                let vc  = ConsultWaitViewController()
//                                vc.modalPresentationStyle = .fullScreen
//                                vc.modalTransitionStyle = .flipHorizontal
//                                vc.uuid_patient = UserDefaults.standard.string(forKey: AppSettings.uuid)!
//                                vc.uuid_doctor = self.detaildokter!.uuid
//                                vc.email_patient = UserDefaults.standard.string(forKey: AppSettings.email)!
//                                vc.email_doctor = self.detaildokter!.email
//                                vc.rates = Int(self.detaildokter!.rates)!
//                                vc.currentConsultation = data!
//
//
//                                let encoder = JSONEncoder()
//                                if let encoded = try? encoder.encode(data!) {
//                                    UserDefaults.standard.set(encoded, forKey: AppSettings.KEY_CURRENT_CONSULTATION)
//                                }
//
//                                //
//                                weak var pvc = self.presentingViewController
//
//                                self.dismiss(animated: false) {
//                                    pvc?.present(vc, animated: true, completion: nil)
//
//                                }
//                            }else{
//                                print("ayaan")
//                                let vc = UIStoryboard(name: "PMR", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "OpenpdfViewController") as? OpenpdfViewController
//                                vc?.headers = "DOKU pembayaran"
//                                vc?.delegate = self
//                                vc?.urlstring = url!
//                                vc?.merchant_id = merchant_id!
//                                self.present(vc!, animated: true, completion: nil)
//                            }
//
//                        }
//                        else {
//                            Toast.show(message: "Gagal memulai sesi konsultasi", controller: self)
//                        }
//                        }
//
//                    }
//                }else{
//
//
//                    print("jol bayar cash")
//                    self.chatacc.confirmConsultclinic(token: UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik)!, uuid_patient: UserDefaults.standard.string(forKey: AppSettings.uuid)!, uuid_doctor:  self.detaildokter!.uuid, email_patient: UserDefaults.standard.string(forKey: AppSettings.email)!, email_doctor: self.detaildokter!.email, rates: Int(self.detaildokter!.rates)!, jawab: stringform, medical_facility_id: self.facilityid!, voucher_amount: "\(self.getdiskon().0)", voucher: self.getdiskon().1, pin: pin, payment_id: "2", payment_name: "Escrow", param: nil, trans_merchant_id: "") { (data,merchant_id,url) in
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//
//                        self.delegate.loading(load: false)
//
//                        if data != nil {
//
//                            self.currentConsultationId = data!.consultation_id!
//
//                            let vc  = ConsultWaitViewController()
//                            vc.modalPresentationStyle = .fullScreen
//                            vc.modalTransitionStyle = .flipHorizontal
//                            //vc.data = self.data
//                            vc.uuid_patient = UserDefaults.standard.string(forKey: AppSettings.uuid)!
//                            vc.uuid_doctor = self.detaildokter!.uuid
//                            vc.email_patient = UserDefaults.standard.string(forKey: AppSettings.email)!
//                            vc.email_doctor = self.detaildokter!.email
//                            vc.rates = Int(self.detaildokter!.rates)!
//                            vc.currentConsultation = data!
//
//
//                            let encoder = JSONEncoder()
//                            if let encoded = try? encoder.encode(data!) {
//                                UserDefaults.standard.set(encoded, forKey: AppSettings.KEY_CURRENT_CONSULTATION)
//                            }
//
//                            //
//                            weak var pvc = self.presentingViewController
//
//
//                            self.dismiss(animated: false) {
//                                pvc?.present(vc, animated: true, completion: nil)
//
//                            }
//
//                        }
//                        else {
//                            Toast.show(message: "Gagal memulai sesi konsultasi", controller: self)
//                        }
//
//                    }
//                }
//                }
                
                
            }
        
    }
}


extension NewCheckConsulVC : edit_and_add_phrViewControllerdelegate,formsViewControllerdelegate,insertpinViewControllerdelegate{
    func lanjutpesanan(pin: String) {
        chataction(pin: pin)
    }
    
    
    
    ///====
    func kirim(list: [listformmodel]) {
        self.list = list
        selectsending()
       
        
    }
    
    
    
    //===
    func ubahtinggi(tinggi: Int, berat: Int, row: Int) {
        mdata[row].height = String(tinggi)
        mdata[row].weight = String(berat)
       
    }
    
    
}
