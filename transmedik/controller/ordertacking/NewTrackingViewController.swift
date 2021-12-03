//
//  NewTrackingViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 02/12/21.
//

import UIKit
import Kingfisher
import SkeletonView

class NewTrackingViewController: UIViewController {

    
    @IBOutlet weak var nav: UIView!
    @IBOutlet weak var back: UIImageView!
    
    @IBOutlet weak var point1: UIImageView!
    @IBOutlet weak var point2: UIImageView!
    @IBOutlet weak var point3: UIImageView!
    @IBOutlet weak var point4: UIImageView!
    
    @IBOutlet weak var imagestatus: UIImageView!
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var Tables: UITableView!
    @IBOutlet weak var jumlahObat: UILabel!
    
    @IBOutlet weak var TotalBelanja: UILabel!
    @IBOutlet weak var biayaPengiriman: UILabel!
    @IBOutlet weak var diskon: UILabel!
    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var pembayaran: UILabel!
    
    @IBOutlet weak var penerima: UILabel!
    @IBOutlet weak var tlp: UILabel!
    
    @IBOutlet weak var alamat: UILabel!
    
    @IBOutlet weak var viewkurir: UIView!
    @IBOutlet weak var kurir: UILabel!
    @IBOutlet weak var namaDriver: UILabel!
    @IBOutlet weak var plat: UILabel!
    @IBOutlet weak var photoDriver: UIImageView!
    @IBOutlet weak var lacakDriver: UIButton!
    
    @IBOutlet weak var terimaButton: UIButton!
    @IBOutlet weak var tinggitable: NSLayoutConstraint!
    
    @IBOutlet weak var kurirHeader: UIView!
    @IBOutlet weak var kurirDetail: UIView!
    @IBOutlet weak var kurirViewButton: UIView!
    
    
    var id = ""
    var api = historiesobject()
    var data : ordertrackingtransaksimodel!
    var list :[detailobattraking] = []
    var obat = Obat()
    var page : PresentPage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        getData()
    }
    
    
    @objc func kembali(){
        keluar(view: page)
    }
    
    func layout(){
        self.Tables.delegate = self
        self.Tables.dataSource = self
        self.view.layoutIfNeeded()
        self.view.backgroundColor = Colors.backgroundmaster
        kurirHeader.isHidden.toggle()
        kurirDetail.isHidden.toggle()
        
        kurirViewButton.isHidden.toggle()
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        lacakDriver.layer.borderWidth = 1
        lacakDriver.layer.borderColor = UIColor.init(hexString: "F08A23").cgColor
        lacakDriver.layer.cornerRadius = 5
        Tables.estimatedRowHeight = 300
        terimaButton.layer.cornerRadius = 10
        viewDetail.layer.cornerRadius = 10
        nav.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        viewDetail.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        point1.layer.cornerRadius =  point1.frame.height / 2
       point2.layer.cornerRadius = point1.frame.height / 2
        point3.layer.cornerRadius = point1.frame.height / 2
        point4.layer.cornerRadius = point1.frame.height / 2
    }

    func getData(){
        if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
                self.api.getdetailhistory(token: token, id: self.id) { (data, msg) in
                    print("brsz")
                    if msg.contains("Unauthenticated"){
                        UserDefaults.standard.set(true, forKey: "logout")
                        self.dismiss(animated: false, completion: nil)
                        self.presentingViewController?.dismiss(animated: false, completion: nil)
                    }
                    if data != nil {
                        self.list = data!.medicines!
                        self.data = data
                        self.jumlahObat.text = "\(data?.medicines?.count ?? 0)"
                        self.statustext(status: data!.order_status ?? "")
                        self.total.text = data!.total_order
                        self.biayaPengiriman.text  = data!.shipping_fee
                        let diskons = data!.voucher_amount ?? 0
                        self.namaDriver.text = data!.couriers?.name ?? "kurir name"
                        self.plat.text = data!.couriers?.vehicle_number ?? "D12313DF"
                        self.diskon.text = "Rp.\(diskons.formattedWithSeparator)"
                        self.total.text = data!.total
                        self.penerima.text = data!.consignee
                        self.tlp.text = data!.phone_number
                        self.alamat.text = data!.address
                        self.kurir.text = data!.courier
                        self.pembayaran.text = data!.payment_name
                        self.pembayaran.text = data!.payment_status
                        self.TotalBelanja.text = data!.subtotal
                        self.Tables.reloadData()
                    }
                }
            }
    }
    
    
    func statustext(status : String){
          
        print("statustext >>>" + status )
        switch status {
        case "Unpaid":
            self.status.text = "Menunggu Pembayaran"
            self.status.textColor = .red
            point1.image = UIImage(named: "Subtract", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            imagestatus.image =  UIImage(named: "Order ditolak", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            break
            
            
        case "Paid":
            self.status.text = "Transaksi berhasil"
            self.status.textColor = .init(hexString: "FFD600")
            point1.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            imagestatus.image =  UIImage(named: "Order Berhasil", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!


            break
        case "Accepted":
            self.status.text = "Pesanan diterima Apotik"
            self.status.textColor = UIColor.init(hexString: "005377")
            point1.image = UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point2.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            imagestatus.image =  UIImage(named: "Order diterima Apotik", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!

            break
        case "Delivery":
            self.status.text = "Pesanan dikirim"
            self.status.textColor = UIColor.init(hexString: "70C900")
            point1.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point2.image = UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point3.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            imagestatus.image =  UIImage(named: "Order Dikirim", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            kurirHeader.isHidden.toggle()
            kurirDetail.isHidden.toggle()
            if kurirViewButton.isHidden {
                kurirViewButton.isHidden.toggle()
            }
            break
        case "Delivered":
            self.status.text = " Pesanan Tiba"
            self.status.textColor = UIColor.init(hexString: "4080F0")
            point1.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point2.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point3.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point4.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            imagestatus.image =  UIImage(named: "Order diterima", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            kurirHeader.isHidden.toggle()
            kurirDetail.isHidden.toggle()
            if !kurirViewButton.isHidden {
                kurirViewButton.isHidden.toggle()
            }
            break
        case "Cancel By System":
            self.status.text = "Pesanan Gagal"
            self.status.textColor = .red
            point1.image = UIImage(named: "Subtract", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            imagestatus.image =  UIImage(named: "Order ditolak", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!

            break
        case "Rejected":
            self.status.text = "Pesanan Ditolak Apotik"
            self.status.textColor = UIColor.init(hexString: "E75656")
            point1.image = UIImage(named: "Subtract", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            imagestatus.image =  UIImage(named: "Order ditolak", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
           

            break
        case "Payment Failed":
            self.status.text = "Pembayaran Gagal"
            self.status.textColor = .red
            point1.image = UIImage(named: "Subtract", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            imagestatus.image =  UIImage(named: "Order ditolak", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
           

            break
        case "Complained":
            self.status.text = "Kendala diterima"
            self.status.textColor = UIColor.init(hexString: "FFD600")
            point1.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point4.isHidden.toggle()
       

            break
        case "Handled":
            self.status.text = "Kendala Diproses"
            self.status.textColor = UIColor.init(hexString: "005377")
            point1.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point2.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point4.isHidden.toggle()
           

            break
            
        case "Solved":
            self.status.text = "Kendala Selesai"
            self.status.textColor = UIColor.init(hexString: "4080F0")
            point1.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point2.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point3.image =  UIImage(named: "Check", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            point4.isHidden.toggle()

            
            break
        case "Canceled":
            self.status.text = "Pemesanan Obat Batal"
            self.status.textColor = UIColor.init(hexString: "4080F0")
            point1.image = UIImage(named: "Subtract", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            imagestatus.image =  UIImage(named: "Order ditolak", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            
            break
        default:
            self.status.text = "Pesanan Gagal"
            self.status.textColor = .red
            imagestatus.image =  UIImage(named: "Order ditolak", in: Bundle.init(identifier: AppSettings.frameworkBundleID), compatibleWith: nil)!
            
        }
        
        
        
    }
}

extension NewTrackingViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.medicines?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row].name
//        cell.namaobat.text = list[indexPath.row].name
        return cell
    }
    
    private func tableView(tableView: UITableView, willDisplayMyCell myCell: ResepObatTableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        print("willDisplay2")

        tableView.layoutIfNeeded()
        
        self.tinggitable.constant = tableView.contentSize.height
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

        print("waehs")
        return  UITableViewAutomaticDimension
    }
    
}
