//
//  ViewController.swift
//  Stocks
//
//  Created by Иван Лизогуб on 30.01.2021.
//

import UIKit

class StockViewController: UIViewController {
    private let output: StockViewOutput

    private let titleLabel = UILabel()

    private let generalStack = UIStackView()

    private let companyNameStack = UIStackView()
    private let companyNameLabel = UILabel()
    private let companyName = UILabel()

    private let symbolStack = UIStackView()
    private let symbolLabel = UILabel()
    private let symbol = UILabel()

    private let priceStack = UIStackView()
    private let priceLabel = UILabel()
    private let price = UILabel()

    private let priceChangeStack = UIStackView()
    private let priceChangeLabel = UILabel()
    private let priceChange = UILabel()

    private let logo = UIImageView()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private let companyPickerView = UIPickerView()
    
    private lazy var companies: [String: String] = [:]

    init(output: StockViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented StockViewController")
    }

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(logo)
        self.view = view
        setup()
        setupConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        output.requestCompanies()
    }

    
    private func setup() {
        setupTitle()
        setupGeneral()
        setupCompanyName()
        setupSymbol()
        setupPrice()
        setupPriceChange()
        setupActivityIndicator()
        setupPicker()
    }
    
    private func setupConstraints() {
        [titleLabel,
         generalStack,
         companyPickerView,
         logo,
         activityIndicator
        ].forEach {$0.translatesAutoresizingMaskIntoConstraints = false}
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40.0),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            generalStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40.0),
            generalStack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 40.0),
            generalStack.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -40.0),

            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.topAnchor.constraint(equalTo: generalStack.bottomAnchor, constant: 40.0),
            logo.bottomAnchor.constraint(lessThanOrEqualTo: companyPickerView.topAnchor, constant: 40.0),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            companyPickerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            companyPickerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            companyPickerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            companyPickerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
            
        ])
    }

    private func requestQuoteUpdate() {
        activityIndicator.startAnimating()
        [companyName, symbol, price, priceChange].forEach{$0.text = "-"}
        priceChange.textColor = .black

        logo.isHidden = true

        let selectedRow = companyPickerView.selectedRow(inComponent: 0)
        let selectedSymbol = Array(companies.values)[selectedRow]
        output.requestQuoteUpdate(with: selectedSymbol)
        output.requestLogo(with: selectedSymbol)
    }

    private func getImageByUrl(url: URL?) {
        guard let url = url else {
            print("Error incorrect image url")
            return
        }
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                logo.image = image
            }
        }
    }

    private func setupTitle() {
        view.addSubview(titleLabel)

        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30.0)
        titleLabel.numberOfLines = 0
        titleLabel.text = "Company information"
    }

    private func setupGeneral() {
        view.addSubview(generalStack)

        generalStack.axis = .vertical
        generalStack.distribution = .fillEqually
        generalStack.alignment = .fill
        generalStack.spacing = 40.0
    }

    private func setupCompanyName() {
        generalStack.addArrangedSubview(companyNameStack)

        buildStack(stack: companyNameStack)
        companyNameStack.spacing = 10.0
        companyNameStack.addArrangedSubview(companyNameLabel)
        companyNameStack.addArrangedSubview(companyName)

        companyNameLabel.text = "Company name"
        buildRightLabel(label: companyName)
    }

    private func setupSymbol() {
        generalStack.addArrangedSubview(symbolStack)

        buildStack(stack: symbolStack)
        symbolStack.addArrangedSubview(symbolLabel)
        symbolStack.addArrangedSubview(symbol)

        symbolLabel.text = "Symbol"
        buildRightLabel(label: symbol)
    }

    private func setupPrice() {
        generalStack.addArrangedSubview(priceStack)

        buildStack(stack: priceStack)
        priceStack.addArrangedSubview(priceLabel)
        priceStack.addArrangedSubview(price)

        priceLabel.text = "Price"
        buildRightLabel(label: price)
    }

    private func setupPriceChange() {
        generalStack.addArrangedSubview(priceChangeStack)

        buildStack(stack: priceChangeStack)
        priceChangeStack.addArrangedSubview(priceChangeLabel)
        priceChangeStack.addArrangedSubview(priceChange)

        priceChangeLabel.text = "Price change"
        buildRightLabel(label: priceChange)
    }

    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)

        activityIndicator.hidesWhenStopped = true
    }

    private func setupPicker() {
        view.addSubview(companyPickerView)

        companyPickerView.dataSource = self
        companyPickerView.delegate = self
    }
}

extension StockViewController: StockViewInput {

    func updateCompanies(with companies: [String: String]) {
        activityIndicator.stopAnimating()
        self.companies = companies
        companyPickerView.reloadAllComponents()
        requestQuoteUpdate()
    }

    func updateDisplay(with stock: Stock, color: Color) {
        activityIndicator.stopAnimating()
        companyName.text = stock.companyName
        symbol.text = stock.symbol
        price.text = "\(stock.price)"
        priceChange.text = "\(stock.priceChange)"
        switch color {
        case Color.red:
            priceChange.textColor = .systemRed
        case Color.green:
            priceChange.textColor = .systemGreen
        case Color.black:
            priceChange.textColor = .black
        }
    }

    func updateLogo(with logo: String) {
        getImageByUrl(url: URL(string: logo))
        self.logo.isHidden = false
    }

    func showAlert(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

extension StockViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        companies.keys.count
    }
    
    
}

extension StockViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Array(companies.keys)[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        requestQuoteUpdate()
    }
}

private extension StockViewController {
    func buildStack(stack: UIStackView) {
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .fill
    }

    func buildRightLabel(label: UILabel) {
        symbol.text = "-"
        symbol.textAlignment = .right
    }
}