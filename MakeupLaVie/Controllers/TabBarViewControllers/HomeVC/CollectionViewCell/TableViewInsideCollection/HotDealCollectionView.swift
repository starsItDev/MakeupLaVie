import UIKit

class HotDealCollectionView: UICollectionViewCell {
    
    weak var delegate: HotDealCollectionViewDelegate?
    var wishlistproducts: [ResponseWishlist] = []
    var selectedID: Int?
    var favoriteState: Bool = false
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var rsLbl: UILabel!
    @IBOutlet var disLbl: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var favImg: UIImageView!
    @IBOutlet var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowOpacity = 0.5
        cellView.layer.shadowOffset = CGSize(width: 2, height: 2)
        cellView.layer.shadowRadius = 4
    }
    override func prepareForReuse() {
        favoriteState = false
               favImg.image = UIImage(named: "like")
    }
    func configureCell(with favoriteState: Bool) {
        self.favoriteState = favoriteState
        
        if favoriteState {
            favImg.image = UIImage(named: "like")
        } else {
            favImg.image = UIImage(named: "heart (4)")
        }
    }

    @IBAction func favBtnPressed(_ sender: Any) {
        favoriteState = !favoriteState
        
        if favoriteState {
            favImg.image = UIImage(named: "like")
        } else {
            favImg.image = UIImage(named: "heart (4)")
        }
        
        delegate?.Wishlist(selectedID: selectedID)
    }
}
