//
//  ViewController.swift
//  FundooDraw
//
//  Created by Admin on 08/08/20.
//  Copyright © 2020 nikhiljain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let canvas = Canvas()
    private var lineColor : CGColor = UIColor.black.cgColor {
        didSet {
            self.canvas.setStrokeColor(color: lineColor)
        }
    }
    
    private var lineWidth : CGFloat = 1 {
        didSet {
            self.canvas.setLineWidth(width: lineWidth)
        }
    }
    
    private let undoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Undo", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleUndoAction), for: .touchUpInside)
        return button
    }()
    
    private let clearButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleClearAction), for: .touchUpInside)
        return button
    }()
    
    private let shareButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Share", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleShareAction), for: .touchUpInside)
        return button
    }()
    
    private let paintSettingsButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Paint Settings", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(navigateToPaintSettings), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.addSubview(canvas)
        canvas.frame = self.view.frame
        canvas.setStrokeColor(color : lineColor)
        setUpLayout()
    }
    
    private func setUpLayout(){
        let optionsStackView = UIStackView(arrangedSubviews: [
            undoButton, clearButton, paintSettingsButton
            
        ])
        self.view.addSubview(optionsStackView)
        optionsStackView.distribution = .fillEqually
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        optionsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        optionsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        setUpShareButton()
    }
    
    private func setUpShareButton() {
        self.view.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        shareButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
    }
    
    @objc private func handleUndoAction(){
        canvas.undo()
    }
    
    @objc private func handleClearAction(){
        canvas.clear()
    }
    
    @objc private func handleShareAction(){
        guard let image = canvas.toImage() else {
            showShareErrorAlert()
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func navigateToPaintSettings() {
        let settingsViewController = SettingsViewController()
        settingsViewController.color = lineColor
        settingsViewController.lineWidth = lineWidth
        settingsViewController.onColorChange = { [weak self] color in
            self?.lineColor = color
        }
        settingsViewController.onLineWidthChange = { [weak self] lineWidth in
            self?.lineWidth = lineWidth
        }
        present(settingsViewController, animated: true, completion: nil)
    }
    
    private func showShareErrorAlert() {
        let alertController = UIAlertController(title: "Error while sharing", message: "Something went wrong while sharing the image", preferredStyle: .alert)
        alertController.addAction(.init(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
