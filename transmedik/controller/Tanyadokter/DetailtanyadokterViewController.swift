//
//  DetailtanyadokterViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 08/07/21.
//

import UIKit
import Kingfisher
import SkeletonView

class DetailtanyadokterViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var navi: UIView!
    @IBOutlet weak var viewsearch: UIView!
    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var collfilter: UICollectionView!
    @IBOutlet weak var filter: UIImageView!
    @IBOutlet var notconnection: UIView!
    @IBOutlet var notfound: UIView!
    @IBOutlet weak var headerlabel: UILabel!
    var header = ""
    @IBOutlet weak var back: UIImageView!
    var token = ""
    var id = ""
    var lastContentOffset : CGFloat = 0.0
    var filterselected : [String] = []
    var loading = false{
        didSet{
            if loading{
                tables.showGradientSkeleton()
            }else{
                tables.hideSkeleton()
            }
           
        }
    }
    @IBOutlet var funcspesial: Specialist!
    @IBOutlet weak var tables: UITableView!
    var data : [Newdetailtanyadokter]?
    var nextpage:String?
    var getdata = false
    var datafilter  :filterdokter?
    var actions = false
    var isform = false
    var presentPage : PresentPage!

    //tinggi

    @IBOutlet weak var tinggifiltercollection: NSLayoutConstraint!
    var facilityid : String?
    var list : [listformmodel] = []
    
    
    @IBOutlet weak var viewtool: UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        registercell()
        headerlabel.text = header
        headerlabel.textColor = Colors.headerlabel
        tables.showGradientSkeleton()
        collfilter.delegate = self
        collfilter.dataSource = self
        collfilter.backgroundColor = Colors.backgroundmaster
        tables.bounces = false
        print("isform = > \(isform)" )

        
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backacc)))

        navi.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        
        self.view.backgroundColor = Colors.backgroundmaster
        self.tables.backgroundColor = .clear
        tinggifiltercollection.constant = 0
        viewtool.isHidden.toggle()
//        tinggiviewsearch.constant = CGFloat(65)
        viewsearch.layer.cornerRadius = viewsearch.frame.height / 2
        viewsearch.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        
        
//        viewsearch.layer.borderWidth = 1
//        viewsearch.layer.borderColor = UIColor.init(rgb: 0xdfdfdf).cgColor
        
        viewsearch.layer.masksToBounds = false
        viewsearch.layer.shadowColor = UIColor.black.cgColor
        viewsearch.layer.shadowOpacity = 0.2
        viewsearch.layer.shadowRadius = 3
        viewsearch.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        search.returnKeyType = UIReturnKeyType.done
        search.delegate = self
        
//        self.view.layoutIfNeeded()
//        tinggiheader.constant = CGFloat(self.view.frame.width / 8 )
        
        self.view.layoutIfNeeded()
//        layoutopen()
        if CheckInternet.Connection(){
            loading = true
            getdata = true
            if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){

                  
                    self.funcspesial.getfilter(token: token) { ( data ) in
                        
                        if data != nil {
                            
                            self.datafilter = data!
                            print("uuu")
                            for index in data!.experince{
                                print(index.value)
                            }
                           
                            
                        }
                    }
                    self.getdatadokter()
                   
                }
            
        }else{
            tables.backgroundView = notconnection
        }
        
        filter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(filteracc)))
        
        
    }
    
    func registercell(){
        tables.register(TanyaDokterListTableViewCell.nib(), forCellReuseIdentifier: TanyaDokterListTableViewCell.identifier)
    }
  
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "logout"){
            dismiss(animated: false, completion: nil)
            self.presentingViewController?.dismiss(animated: false, completion: nil)
        }
    }
    @IBAction func done(_ sender: Any) {
        
        if self.actions{
            getdatadokter()
        }
      
        
    }
    
    func getdatadokter(){
        if CheckInternet.Connection(){
            data = nil
            loading = true
            getdata = true
            self.tables.reloadData()

            self.funcspesial.specialist1(token: self.token, id: self.id, filter: self.datafilter, search: search.text ?? "", facilityid: self.facilityid ) { (data) in
                
                self.tables.backgroundView = nil
                self.getdata = false
                if data != nil {
                    self.data = data!.data
                    if data!.nextpage == ""{
                        self.nextpage = nil
                        self.loading = false
                    }else{
                        self.loading = true
                        self.nextpage = data!.nextpage
                    }
                    self.tables.backgroundView = nil
                    self.tables.reloadData()
                }else{
                    self.loading = false
                    self.getdata = false
                    self.tables.backgroundView = self.notfound
                    self.tables.reloadData()
                    
                }
                self.actions = true
            }

        }else{
            tables.backgroundView = notconnection
        }
        
        
        
        
    }
    
    
    func layoutopen(){
//        print("layoutopen")
        self.view.layoutIfNeeded()
        collfilter.isHidden = true

        if filterselected.count > 0{
            
            tinggifiltercollection.constant = CGFloat(45)
            if viewtool.isHidden {
                viewtool.isHidden.toggle()
            }
            
//
//            tinggiviewsearch.constant = CGFloat(115)
            collfilter.isHidden = false

        }else{
            tinggifiltercollection.constant = CGFloat(0)
//            tinggiviewsearch.constant = CGFloat(65)
            if !viewtool.isHidden {
                viewtool.isHidden.toggle()
            }
            
            collfilter.isHidden = true
        }


        self.view.layoutIfNeeded()

    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if loading && data != nil {
            let rows = nextpage == nil ? data!.count - 2 : data!.count
            
            
            if indexPath.row == rows  && !getdata{
                self.tables.isScrollEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.add()
                }
            }
        }
        
    }
    
    
    @objc func backacc(){
       keluar(view: presentPage)
    }
    
    
    
    func add(){
        self.getdata = true
        self.funcspesial.specialistwithurl(token: self.token, url: self.nextpage!, filter: datafilter) { (data) in
            self.getdata = false
            if data != nil {
//                self.tables.isScrollEnabled = false
//                self.tables.beginUpdates()
                
                for index in data!.data{
                    self.tables.beginUpdates()
                    self.data!.append(index)
                    self.tables.insertRows(at: [IndexPath(row: self.data!.count-1, section: 0)], with: .bottom)
                    self.tables.endUpdates()

                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                  
                    
                    self.tables.isScrollEnabled = true
                    if data!.nextpage == ""{
                        self.nextpage = nil
                        self.loading = false
                        self.tables.beginUpdates()
                        self.tables.deleteRows(at: [IndexPath(row: self.data!.count, section: 0)], with: .automatic)
                        self.tables.endUpdates()
                    }else{
                        self.loading = true
                        self.nextpage = data!.nextpage
                        
                    }
                    self.tables.backgroundView = nil
                }
                
            }else{
                self.tables.isScrollEnabled = true
            }
        }
    }
    
}
extension DetailtanyadokterViewController :UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterselected.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! selectedfilterCollectionViewCell
        cell.layoutIfNeeded()
        cell.layer.cornerRadius = 15
        cell.name.text = filterselected[indexPath.row]
        cell.backgroundColor  = .clear
        
        return cell
    }
    
    
    
    
}


extension DetailtanyadokterViewController : UITableViewDelegate,UITableViewDataSource,filerdokterViewControllerdelegate,TanyaDokterListTableViewCellDelegate,SkeletonTableViewDelegate,SkeletonTableViewDataSource{
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return TanyaDokterListTableViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 4
    }
    
    func chat(cell: UITableViewCell) {
        guard let indextPath = tables.indexPathForRow(at: cell.center) else {return}

        if  data![indextPath.row].status_docter == "Online"{
            let vc = UIStoryboard(name: "Chat", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "NewCheckConsulVC") as? NewCheckConsulVC
            vc?.header = header
            vc?.list = list
            vc?.isform = isform
            vc?.presentPage = self.presentPage
            vc?.facilityid = facilityid
            vc?.id = id
            vc?.uuid = data![indextPath.row].uuid
            present(vc!, animated: true, completion: nil)
//            openVC(vc!, presentPage)

        }
    }
    
    func detail(cell: UITableViewCell) {
        guard let indextPath = tables.indexPathForRow(at: cell.center) else {return}
       
        let vc = UIStoryboard(name: "Profiledokter", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "NewProfileDokterVC") as? NewProfileDokterVC
        vc?.header = header
        vc?.uuid = data![indextPath.row].uuid
        vc?.list = list
        vc?.isform = isform
        vc?.id = id
        vc?.data = self.data![indextPath.row]
        vc?.facilityid = facilityid!
        vc?.presentPage = self.presentPage
        openVC(vc!, presentPage)

    }
    
//
//
//    func kirimdatavalues(data: [listformmodel]) {
//        self.list = data
//    }
//
//
//
    func sendfilter(data: filterdokter) {
        filterselected.removeAll()
        for index in data.experince{
            if index.check{
                filterselected.append(index.name)
            }
        }
        for index in data.rates{
            if index.check{
                filterselected.append(index.name)
            }
        }
        datafilter = data
        //reload data
        collfilter.reloadData()
//        layoutopen()
        self.getdatadokter()
        UIView.animate(withDuration : 0.5){
            if self.filterselected.count > 0{
                self.tinggifiltercollection.constant = CGFloat(50)
                if self.viewtool.isHidden{
                    self.viewtool.isHidden.toggle()
                }
//                self.tinggiviewsearch.constant = CGFloat(115)
        }else{
            self.tinggifiltercollection.constant = 0
            if !self.viewtool.isHidden{
                self.viewtool.isHidden.toggle()
            }
//            self.tinggiviewsearch.constant = CGFloat(65)
        }
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data == nil ? 0 : data!.count
//        if loading{
//            return data == nil ? 1  : nextpage  == nil ? data!.count : data!.count + 1
//        }else{
//            return data == nil ? 0 : data!.count
//        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TanyaDokterListTableViewCell.identifier, for: indexPath) as! TanyaDokterListTableViewCell
        cell.backgroundColor = .clear
        cell.delegate = self
        cell.config(data: data![indexPath.row], faskes: header)
        return cell
    }
    
    
    @objc func filteracc(){
        if datafilter != nil {
            let vc = UIStoryboard(name: "Tanyadokter", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "filerdokterViewController") as? filerdokterViewController
            vc?.datafilter = datafilter
            vc?.delegate = self
            present(vc!, animated: false, completion: nil)
        }
        
    }
    
  
    
    
    
}
