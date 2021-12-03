//
//  historiescellkonsulTableViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 28/07/21.
//

import UIKit
protocol historiescellkonsulTableViewCelldelegate{
    func chatulang(row:Int)
    func nilai(row:Int)
}

class historiescellkonsulTableViewCell: UITableViewCell {

    
//    @IBOutlet weak var penilaian: UIView!
    @IBOutlet weak var wobat: NSLayoutConstraint!
    @IBOutlet weak var wwaktu: NSLayoutConstraint!
    @IBOutlet weak var wresep: NSLayoutConstraint!
    @IBOutlet weak var headerHistory: UILabel!
    
    @IBOutlet weak var viewItem: UIView!
    
    @IBOutlet weak var reChat: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var totalharga: UILabel!
    var delegate :historiescellkonsulTableViewCelldelegate!
    @IBOutlet weak var views: UIView!
    @IBOutlet weak var waktu: UILabel!
    @IBOutlet weak var namedokter: UILabel!
    @IBOutlet weak var obat: UIImageView!
    @IBOutlet weak var calender: UIImageView!
    @IBOutlet weak var edit: UIImageView!
    @IBOutlet weak var headerTitle: UILabel!
    var row = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        views.layer.cornerRadius  = 13
        reChat.layer.cornerRadius = 10

        views.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @objc func nilai(){
        delegate.nilai(row: row)
    }
    @objc func ulang(){
        delegate.chatulang(row: row)
    }
  
    func historyOne(data  : ModelHistories){
        headerTitle.text = "Nama Obat"

        headerHistory.text = "Pembelian Obat"
        namedokter.text = data.detail_medicine[0].name
        backgroundColor = UIColor.clear
        statustext(status: data.status)
        totalharga.text = "Rp. \(data.total.formattedWithSeparator)"
        waktu.text = getday(waktu: data.transaction_date)
        viewItem.isHidden = true
        reChat.isHidden = true
        
    }
    
    func historyTwo(data  : ModelHistories){
        viewItem.isHidden = false
        reChat.isHidden = false
        headerHistory.text = "Konsultasi"
        headerTitle.text = "Nama Dokter"
        backgroundColor = UIColor.clear
        namedokter.text = data.name
        totalharga.text = "Rp. \(data.total.formattedWithSeparator)"
        waktu.text = getday(waktu: data.transaction_date)
        if data.status ==  "FINISHED" || data.status ==  "SESI BERAKHIR"{
            status.text = " Selesai"
            
        }else{
            status.text = " Ditolak"
           
        }
    
      
        
        if data.detail_consultation?.doctor_note.next_schedule == "" {
            wobat.constant = 0
        }else{
            wobat.constant = 36.5
        }
        
        if data.detail_consultation?.prescription.consultation_id == "" {
            wresep.constant = 0
        }else{
            wresep.constant = 36.5
        }
        //
        
        if !(data.detail_consultation?.spa ?? false) {
            wwaktu.constant = 0
        }else{
            wwaktu.constant = 36.5
            
        }
        
        self.layoutIfNeeded()
        
    }
    
    
    func getday(waktu : String)->String{
        let dateFormatters = DateFormatter()
        dateFormatters.dateFormat = "yyyy'-'MM'-'dd'"
        let dates = dateFormatters.date(from: waktu)!
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: dates)
        
        var bulanstring = ""
        let bulanformat = DateFormatter()
        bulanformat.dateFormat = "MM"
        let bulan = bulanformat.string(from: dates)
        
        let tahunformat = DateFormatter()
        tahunformat.dateFormat = "yyyy"
        let taun = tahunformat.string(from: dates)
        
        let tglformat = DateFormatter()
        tglformat.dateFormat = "dd"
        let tgl = tglformat.string(from: dates)
        
        print( "ini bulan \(bulan)")
        
        switch Int(bulan) {
        case 1:
            bulanstring = "Jan"
        case 2:
            bulanstring = "Feb"
        case 3:
            bulanstring = "Mar"
        case 4:
            bulanstring = "Apr"
        case 5:
            bulanstring = "Mei"
        case 6:
            bulanstring = "Jun"
        case 7:
            bulanstring = "Jul"
        case 8:
            bulanstring = "Agu"
        case 9:
            bulanstring = "Sep"
        case 10:
            bulanstring = "Okt"
        case 11:
            bulanstring = "Nov"
        case 12:
            bulanstring = "Des"
            
        default:
            print("Error")
        }
        
        let tanggals = "\(tgl)-\(bulanstring)-\(taun)"
        switch dayInWeek {
        case "Monday":
          return "Sen, \(tanggals)"
        case "Tuesday":
          return "Sel, \(tanggals)"
        case "Wednesday":
          return "Rab, \(tanggals)"
        case "Thursday":
          return "Kam, \(tanggals)"
        case "Friday":
          return "Jum, \(tanggals)"
        case "Saturday":
          return "Sab, \(tanggals)"
        case "Sunday":
          return "Min, \(tanggals)"
        default:
            return "\(dayInWeek), \(tanggals)"
        }
        
        
       
    }
    
    
      func statustext(status : String){
          
          switch status {
          case "Unpaid":
              self.status.text = "Menunggu Pembayaran"
//              self.status.textColor = .red
              break
          case "Paid":
              self.status.text = "Transaksi berhasil"
//              self.status.textColor = .init(hexString: "FFD600")
              break
          case "Accepted":
              self.status.text = "Pesanan diterima Apotik"
//              self.status.textColor = UIColor.init(hexString: "005377")
              break
          case "Delivery":
              self.status.text = "Pesanan dikirim Apotik"
//              self.status.textColor = UIColor.init(hexString: "70C900")
              break
          case "Delivered":
              self.status.text = " Pesanan Diterima"
//              self.status.textColor = UIColor.init(hexString: "4080F0")
              break
          case "Cancel By System":
              self.status.text = "Pesanan Gagal"
//              self.status.textColor = .red
              break
          case "Rejected":
              self.status.text = "Pesanan Ditolak Apotik"
//              self.status.textColor = UIColor.init(hexString: "E75656")
              break
          case "Payment Failed":
              self.status.text = "Pembayaran Gagal"
//              self.status.textColor = .red
              break
          case "Complained":
              self.status.text = "Kendala diterima"
//              self.status.textColor = UIColor.init(hexString: "FFD600")
              break
          case "Handled":
              self.status.text = "Kendala Diproses"
//              self.status.textColor = UIColor.init(hexString: "005377")
              break
              
          case "Solved":
              self.status.text = "Kendala Selesai"
//              self.status.textColor = UIColor.init(hexString: "4080F0")
              break
          case "Canceled":
              self.status.text = "Pemesanan Obat Batal"
//              self.status.textColor = UIColor.init(hexString: "4080F0")
              break
          default:
              self.status.text = "Pesanan Gagal"
//              self.status.textColor = .red
              
          }
          
      }
}
