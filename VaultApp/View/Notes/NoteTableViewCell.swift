//
//  NoteTableViewCell.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 8.04.2024.
//

import Foundation
import UIKit
import NeonSDK

class NoteTableViewCell: NeonTableViewCell<NoteModel> {
    
//    // Variables
//    var note: NoteModel?
//    
    // UI Components
    var titleLabel = NeonLabel()
    var contentLabel = NeonLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
          setupSubviews()
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
      
    func setupSubviews() {
        
        backgroundColor = .styledWhite1
        
        // Cell for blank spaces
        let cellView = UIView()
        addSubview(cellView)
        cellView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.9)
            make.centerY.centerX.equalToSuperview()
            
        }
        // shadow
        let shadowView = UIView()
        shadowView.getShadow()
        shadowView.layer.cornerRadius = 8
        cellView.addSubview(shadowView)
        sendSubviewToBack(shadowView)
        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(cellView.snp.edges)
        }

        // Left Image
        
        imageView?.image = UIImage(named: "listBlue")?.withRenderingMode(.alwaysOriginal)
        cellView.addSubview(imageView!)
        imageView?.layer.masksToBounds = true
        imageView!.layer.cornerRadius = 10
        imageView!.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(contentView.snp.width).multipliedBy(0.15)
            make.left.equalToSuperview().offset(20)
        }
        // Title Label
        titleLabel.font = Font.custom(size: 20, fontWeight: .Medium)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .styledGray
        titleLabel.sizeToFit()
        cellView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.left.equalTo(imageView!.snp.right).offset(30)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        // Note Content
        contentLabel.font = Font.custom(size: 11, fontWeight: .Light)
        contentLabel.numberOfLines = 1
        contentLabel.textColor = .styledGray
        contentLabel.sizeToFit()
        cellView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(imageView!.snp.right).offset(30)
            make.width.equalToSuperview().multipliedBy(0.54)
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        
    
    }
    // Configure cell
    override func configure(with note: NoteModel) {
        super.configure(with: note)
        titleLabel.text = note.noteTitle
        contentLabel.text = note.noteContent
        
       
        
        
    }
    
    
}
