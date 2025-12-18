import UIKit

// MARK: - Habit Detail Screen

final class HabitDetailViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: HabitDetailViewModel
    var onHabitUpdated: ((Habit) -> Void)?

    private let titleLabel = UILabel()
    private let statusLabel = UILabel()
    private let streakLabel = UILabel()
    private let actionButton = UIButton(type: .system)

    // MARK: - Init

    init(viewModel: HabitDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        bind()
    }

    // MARK: - Setup UI

    private func setupUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        streakLabel.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.text = "Привычка"

        statusLabel.font = .systemFont(ofSize: 16, weight: .regular)
        statusLabel.textAlignment = .center
        statusLabel.textColor = .secondaryLabel
        statusLabel.text = "Статус"

        streakLabel.font = .systemFont(ofSize: 20, weight: .medium)
        streakLabel.textAlignment = .center
        streakLabel.text = "🔥 0 дней"

        actionButton.setTitle("Отметить", for: .normal)
        actionButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)

        view.addSubview(titleLabel)
        view.addSubview(statusLabel)
        view.addSubview(streakLabel)
        view.addSubview(actionButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            statusLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            streakLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            streakLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            streakLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            actionButton.topAnchor.constraint(equalTo: streakLabel.bottomAnchor, constant: 40),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - Bind

    private func bind() {
        titleLabel.text = viewModel.titleText
        statusLabel.text = viewModel.statusText
        streakLabel.text = viewModel.streakText

        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        viewModel.toggleCompletion()
        onHabitUpdated?(viewModel.currentHabit())
        bind()
    }
}
