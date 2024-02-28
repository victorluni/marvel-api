import UIKit

protocol ErrorViewDelegate: AnyObject {
    func retryButtonTapped()
}

class ErrorView: UIView {
    
    weak var delegate: ErrorViewDelegate?
    
    private lazy var errorImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "multiply.circle.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(errorImageView)
        addSubview(errorLabel)
        addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            errorImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            errorImageView.widthAnchor.constraint(equalToConstant: 100),
            errorImageView.heightAnchor.constraint(equalToConstant: 100),
            
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 20),
            
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 20),
            retryButton.widthAnchor.constraint(equalToConstant: 100),
            retryButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func retryButtonTapped() {
        delegate?.retryButtonTapped()
    }
    
    func configure(with viewModel: NetworkError) {
        errorLabel.text = viewModel.message
        errorImageView.image = UIImage(systemName: viewModel.image)
    }
}
