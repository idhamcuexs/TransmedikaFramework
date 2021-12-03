//
//  WaitingConsulVC.swift
//  transmedik
//
//  Created by Idham Kurniawan on 22/11/21.
//

import Foundation
import UIKit
import CDAlertView
import Parse
import ParseLiveQuery

class WaitingConsulVC: UIViewController {
    
    
    @IBOutlet weak var images: UIImageView!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblbody: UILabel!
    @IBOutlet weak var btnKembali: UIButton!
    
//    var pageOrigin : PageOrigin?
    
    var profile: ModelProfile!
    var doctor: Detaildokter!
    var chatAPICall = Chat()
    var token: String = ""
    var uuid_patient: String = ""
    var uuid_doctor: String = ""
    var email_patient: String = ""
    var email_doctor: String = ""
    var rates: Int = 0
    var currentConsultation: ConsultationPostModel?
    var counter: Int = AppSettings.WAIT_COUNTER
    var pause: Bool = false
    var _timer: Timer?
    var query: PFQuery<PFObject>!
    var pfuser : PFUser?
    var pfdoctor : PFUser?
    var subscription: Subscription<PFObject>!
    var timechecking = 1
    var timertx = Timer()
    var timereconnect = 1
    var open = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTimer()
        setupParse()
        btnKembali.layer.cornerRadius = 10
        btnKembali.isHidden = true
        btnKembali.backgroundColor = Colors.buttonActive
        
        
    }
    
    var isconnection = true{
        didSet{
            if !isconnection{
                let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "notifViewController") as? notifViewController
                self.present(vc!, animated: false, completion: nil)
            }
        }
    }
    
    @objc func timerAction() {
        timechecking -= 1
        if timechecking == 0{
            if  CheckInternet.Connection() != isconnection {
                
                isconnection = CheckInternet.Connection()
                if isconnection{
                    dismiss(animated: false, completion: nil)
                }
            }
            timechecking = 5
            timertx.invalidate()
            self.timertx = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        }
    }
    
    func setupParse() {
        
        print("currentConsultationId : \(Int(self.currentConsultation!.consultation_id!))")
        self.query = ConsultationModel.query()
        self.query = self.query.whereKey("consultation_id", equalTo: Int(self.currentConsultation!.consultation_id!)).whereKey("apps", contains: "transmedika")
        getdata()
        initializeParseListener()
    }
    
    func setupTimer() {
        _timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    
    
    @IBAction func kembaliOnClick(_ sender: Any) {
        
    
//                Int(self.currentConsultation!.consultation_id)!
                if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
                    self.chatAPICall.statusConsult(token: token, status: "NOT ANSWERED", consultation_id: self.currentConsultation!.consultation_id! ) { status in
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                }
               
            }
        
        
    
    
    
    
    func getdata(){
        guard !open else{ return }
        
        self.query.findObjectsInBackground(block: { (results, error) in
            if error == nil {
                
                if let chat = results as? [ConsultationModel] {
                    print("chat => \(chat.count)")
                    if chat.count > 0{
                        let consultation = chat[0]
                        self.pfdoctor = consultation.doctor
                        self.pfuser = consultation.patient
                        
                        print("status updated! : \(consultation.status)")
                        if (consultation.status == AppSettings.ON_CHAT) {
                            print("on chat")
                            Client.shared.unsubscribe(self.query)
                            self.open = true
                            DispatchQueue.main.async {
                                let vc = DetailChatViewController()
                                self.updateDeviceId()
                                UserDefaults.standard.set(true, forKey: AppSettings.ON_CHAT)
                                self.timertx.invalidate()
                                vc.uuid_patient = (self.currentConsultation?.patient?.uuid)!
                                vc.uuid_doctor = (self.currentConsultation?.doctor?.uuid)!
                                vc.email_patient = (self.currentConsultation?.patient?.email)!
                                vc.email_doctor = (self.currentConsultation?.doctor?.email)!
                                vc.currentConsultation = self.currentConsultation
                                vc.currentDoctor = self.pfdoctor
                                vc.currentUser = self.pfuser
//                                vc.pageOrigin = self.pageOrigin
                                
                                
                                
                                self.timertx.invalidate()
                                
                                let nav = UINavigationController(navigationBarClass: UICustomNavigationBar.self, toolbarClass: nil)
                                nav.modalPresentationStyle = .fullScreen
                                let parent = self.presentingViewController!
                                nav.pushViewController(vc, animated: false)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    self.dismiss(animated: false, completion: nil)
                                    parent.present(nav, animated: true, completion: nil)
                                }
                                
                            }
                        }
                    }
                    
                }
            }
        })
    }
    
    
    func initializeParseListener() {
        self.subscription = Client.shared.subscribe(self.query)
        self.subscription.handle(Event.updated) { (query, obj) in
            let consultation = obj as! ConsultationModel
            print("status updated! : \(consultation.status)")
            if (consultation.status == AppSettings.ON_CHAT) {
                print("on chat")
                Client.shared.unsubscribe(self.query)
                
                DispatchQueue.main.async {
                    let vc = DetailChatViewController()
                    UserDefaults.standard.set(true, forKey: AppSettings.ON_CHAT)
                    self.open = true
                    
                    vc.uuid_patient = (self.currentConsultation?.patient?.uuid)!
                    vc.uuid_doctor = (self.currentConsultation?.doctor?.uuid)!
                    vc.email_patient = (self.currentConsultation?.patient?.email)!
                    vc.email_doctor = (self.currentConsultation?.doctor?.email)!
                    vc.currentConsultation = self.currentConsultation
                    vc.currentDoctor = self.pfdoctor
                    vc.currentUser = self.pfuser
//                    vc.pageOrigin = self.pageOrigin
                    
                    self.updateDeviceId()
                    
                    self.timertx.invalidate()
                    let nav = UINavigationController(navigationBarClass: UICustomNavigationBar.self, toolbarClass: nil)
                    nav.modalPresentationStyle = .fullScreen
                    let parent = self.presentingViewController!
                    nav.pushViewController(vc, animated: false)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        self.dismiss(animated: false, completion: nil)
                        parent.present(nav, animated: true, completion: nil)
                    }
                    
                }
            }
            else if (consultation.status == AppSettings.FINISHED || consultation.status == AppSettings.REJECTED_BY_DOCTOR) {
                
                Client.shared.unsubscribe(self.query)
                
                DispatchQueue.main.async {
                    Toast.show(message: LocalizationHelper.getInstance().consultation_no_response, controller: self.presentingViewController ?? self)
                    self._timer?.invalidate()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    func updateDeviceId(){
        guard let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) else { return }
        let api = Profile()
        api.sendiddevice(device: UserDefaults.standard.string(forKey: AppSettings.FCM_TOKEN) ?? "", token: token)
    }
    
    @objc func updateCounter() {
        if counter > 0 {
            if (!pause) {
                if counter < 10 {
                    lblbody.text = "\(LocalizationHelper.getInstance().consultation_wait) 00:0\(counter) \(LocalizationHelper.getInstance().second)"
                }
                else {
                    lblbody.text = "\(LocalizationHelper.getInstance().consultation_wait) 00:\(counter) \(LocalizationHelper.getInstance().second)"
                }
                counter -= 1
            }
        }
        else {
            images.image = UIImage(named: "img_failed", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)
            lblbody.text = "Maaf belum ada respon dari dokter, silahkan menghubungi dokter lain."
            self.isconnection = CheckInternet.Connection()
            timertx.invalidate()
            timertx = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            if (!pause) {
                let pf = Profile()
                guard  let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) else {
                    return
                }
                pf.sendiddevice(device: UserDefaults.standard.string(forKey: AppSettings.FCM_TOKEN) ?? "", token: token)
                Client.shared.unsubscribe(self.query)
                _timer?.invalidate()
                getdata()
                btnKembali.isHidden = false
                
                
                
                
            }
        }
    }
}
