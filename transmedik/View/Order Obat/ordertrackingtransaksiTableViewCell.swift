//
//  ordertrackingtransaksiTableViewCell.swift
//  transmedik
//
//  Created by Idham Kurniawan on 22/08/21.
//

import UIKit
protocol  ordertrackingtransaksiTableViewCelldelegate {
    func tinggi(t : CGFloat)
}

class ordertrackingtransaksiTableViewCell: UITableViewCell {

    
    @IBOutlet weak var views: UIView!
    @IBOutlet weak var namaobat: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.views.layoutIfNeeded()
      
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
