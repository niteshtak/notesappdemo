//
//  NoteItemCell.swift
//  notesdemo
//
//  Created by Nitesh Tak on 27/12/20.
//

import UIKit

class NoteItemCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel?
    
    var noteListCellViewModel: NotesListCellViewModel? {
        didSet {
            titleLabel?.text = noteListCellViewModel?.titleText
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
