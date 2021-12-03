//
//  TanyaDokterListTableViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 19/11/21.
//

import UIKit
import Kingfisher
protocol  TanyaDokterListTableViewCellDelegate {
    func chat(cell : UITableViewCell)
    func detail(cell : UITableViewCell)
}

class TanyaDokterListTableViewCell: UITableViewCell {

    static let identifier = "TanyaDokterListTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "TanyaDokterListTableViewCell", bundle: AppSettings.bundleframework)
    }

    
    @IBOutlet weak var Backgound: UIView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var pengalaman: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var spesialis: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var waktu: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var viewStatus: UIImageView!
    var delegate : TanyaDokterListTableViewCellDelegate?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photo.layer.cornerRadius = 40
        Backgound.layer.cornerRadius = 10
        chatButton.layer.cornerRadius = 7
        viewStatus.layer.cornerRadius = 10
        
        photo.isUserInteractionEnabled = true
        photo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(detailOnClick)))
        shadow()
        
    }
    
    func shadow(){
        Backgound.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func config(data: Newdetailtanyadokter,faskes : String){
        name.text = data.full_name
        spesialis.text = faskes
        rating.text = data.rating
        pengalaman.text = data.experience
        status.text = data.status_docter == "Online" ? "Available" : "Not Available"
        price.text = "Rp \(Int(data.rates)!.formattedWithSeparator)"
        viewStatus.backgroundColor = data.statuscolor
        chatButton.backgroundColor = data.statuscolor
        if data.profile_picture != "" {
            photo.kf.setImage(with: URL(string: data.profile_picture))
        }
        
    }
    
    @IBAction func chatOnClick(_ sender: Any) {
        print("kampreset")
        delegate?.chat(cell: self)
    }
    
    @objc func detailOnClick(){
        delegate?.detail(cell: self)
    }
    
}
