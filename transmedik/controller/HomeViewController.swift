//
//  HomeViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 28/07/21.
//

import FSPagerView
import CoreLocation
import BubbleShowCase
import Kingfisher
import Parse


struct modelmenuinhome {
    var background,icon,text : String
}

class HomeViewController: UIViewController {

    @IBOutlet weak var collmenu: UICollectionView!
    @IBOutlet weak var back: UIView!
    @IBOutlet weak var viewnavigation: UIView!
    var presentPage : PresentPage!
    var query: PFQuery<PFObject>!
    var menuhome : [modelmenuinhome] = [
        modelmenuinhome(background: "klinikbackground", icon: "ic_klinik", text: "Klinik"),
        modelmenuinhome(background: "phrbackground", icon: "ic_riwayat_konsultasi", text: "Riwayat Konsultasi"),
        modelmenuinhome(background: "beliobatbackground", icon: "ic_riwayat_obat", text: "Riwayat Obat"),
      ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collmenu.delegate = self
        collmenu.dataSource = self
        viewnavigation.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        
        
    }
    @objc func kembali(){
       keluar(view: presentPage)
    }


    
    func getdata(id : Int,data: ConsultationPostModel,uuid : String,email : String){
        
        self.query = ConsultationModel.query()
        self.query = self.query.whereKey("consultation_id", equalTo: id)
        
        self.query.findObjectsInBackground(block: { (results, error) in
            if error == nil {
                self.closeloading(self)

                if let chat = results as? [ConsultationModel] {
                    
                    let vc = DetailChatViewController()
                    vc.uuid_patient = uuid
                    vc.uuid_doctor = data.doctor!.uuid!
                    vc.email_patient = email
                    vc.email_doctor = data.doctor!.email!
                    vc.currentConsultation = data
                    vc.currentDoctor = chat[0].doctor
                    vc.currentUser = chat[0].patient
                    
                    print("uhuy")
                    
                    let nav = UINavigationController(navigationBarClass: UICustomNavigationBar.self, toolbarClass: nil)
                    nav.modalPresentationStyle = .fullScreen
                    nav.pushViewController(vc, animated: false)
                    self.present(nav, animated: true, completion: nil)
                }
            }
        })
    }

}


extension HomeViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sets =  CGFloat((self.view.frame.width - (15 * 5)) / 3)
         return CGSize(width:  sets , height:  (( sets / 5 ) * 6.5 ))
       
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("jumlah")
        print("menuhome.count")
        return menuhome.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            switch indexPath.row {
            case 0:
                print("case 00")
                if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
                    let chat = Chat()
                    Loading.show()
                    chat.checkkonsul(token: token) { (data) in
                        Loading.dismiss()
                        if data != nil {
                            self.getdata(id: Int(data!.consultation_id!), data: data!, uuid: UserDefaults.standard.string(forKey: AppSettings.uuid)!, email: UserDefaults.standard.string(forKey: AppSettings.email) ?? "")
      
                        }
                        else {
                           

                            UserDefaults.standard.removeObject(forKey: AppSettings.ON_CHAT)
                            Toast.show(message: "Konsultasi sudah berakhir", controller: self)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

                                let vc = UIStoryboard(name: "Fasilitaskesehatan", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "fasilitaskesehatanViewController" ) as? fasilitaskesehatanViewController
                            
                                vc?.presentPage = self.presentPage
                                self.openVC(vc!, self.presentPage)
//                                        self.present(vc!, animated: false, completion: nil)
                                
                            }
                        }
                        
                    }

                }else{
                    print("not token")
                }
            
            
            
                
                
//                if UserDefaults.standard.bool(forKey: AppSettings.ON_CHAT){
//                    Loading.show()
//                        if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
//                            let chat = Chat()
//                            print("token on")
//                            chat.checkkonsul(token: token) { (data) in
//                                Loading.dismiss()
//                                if data != nil {
//                                    self.getdata(id: Int(data!.consultation_id!), data: data!, uuid: UserDefaults.standard.string(forKey: AppSettings.uuid)!, email: UserDefaults.standard.string(forKey: AppSettings.email) ?? "")
//
//                                }
//                                else {
//
//
//                                    UserDefaults.standard.removeObject(forKey: AppSettings.ON_CHAT)
//                                    Toast.show(message: "Konsultasi sudah berakhir", controller: self)
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//
//                                        let vc = UIStoryboard(name: "Fasilitaskesehatan", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "fasilitaskesehatanViewController" ) as? fasilitaskesehatanViewController
//
//                                        vc?.presentPage = self.presentPage
//                                        self.openVC(vc!, self.presentPage)
////                                        self.present(vc!, animated: false, completion: nil)
//
//                                    }
//                                }
//
//                            }
//
//                        }
//
//
//
//                }else{
////                    let vc = UIStoryboard(name: "Fasilitaskesehatan", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "fasilitaskesehatanViewController" ) as? fasilitaskesehatanViewController
////                    vc?.presentPage = self.presentPage
////                    openVC(vc!, self.presentPage)
//
////                    present(vc!, animated: false, completion: nil)
//                    keluar(view: presentPage)
//                }
            
                break
                
           
            case 1:
                let vc = UIStoryboard(name: "History", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "historypembelianViewController" ) as? historypembelianViewController
                vc?.select = 2
                vc?.presentPage = self.presentPage
                openVC(vc!, self.presentPage)

//                present(vc!, animated: false, completion: nil)
                break
                
                
            case 2:
                let vc = UIStoryboard(name: "History", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "historypembelianViewController" ) as? historypembelianViewController
                vc?.select = 1
                vc?.presentPage = self.presentPage
                openVC(vc!, self.presentPage)

//                present(vc!, animated: false, completion: nil)
                break
          
            default:
                fatalError()
            }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! cellmenuinhomeCollectionViewCell

        cell.layer.cornerRadius = 10
        cell.icon.image = UIImage(named: menuhome[indexPath.row].icon, in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!

        cell.background.backgroundColor = UIColor.red
        cell.text.text = menuhome[indexPath.row].text
        return cell
        
    }
    
    
}
