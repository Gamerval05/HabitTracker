import UIKit

final class HabitListViewController: UIViewController {

    private let viewModel = HabitListViewModel()

    private let tableView = UITableView()
    private let progressLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .default)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        viewModel.loadHabits()
        updateProgress()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Привычки"

        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        progressLabel.textAlignment = .center
        progressLabel.font = .systemFont(ofSize: 16, weight: .medium)

        view.addSubview(progressLabel)
        view.addSubview(progressView)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            progressLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            progressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            progressView.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 8),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addHabitTapped)
        )
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    private func updateProgress() {
        let completed = viewModel.habits.filter { $0.isCompleted }.count
        let total = viewModel.habits.count
        progressLabel.text = "Выполнено: \(completed) из \(total)"
        progressView.progress = viewModel.progress()
    }

    @objc private func addHabitTapped() {
        let alert = UIAlertController(title: "Новая привычка", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Название" }

        alert.addAction(UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            guard
                let self = self,
                let text = alert.textFields?.first?.text,
                !text.isEmpty
            else { return }

            self.viewModel.addHabit(title: text)
            self.tableView.reloadData()
            self.updateProgress()
        })

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func sortTapped() {
        viewModel.changeSort(to: viewModel.sortType == .byCompletion ? .byStreak : .byCompletion)
        tableView.reloadData()
        updateProgress()
    }
}

extension HabitListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfHabits()
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let habit = viewModel.habit(at: indexPath.row)

        cell.textLabel?.text = "\(habit.title)  🔥 \(habit.streak)"
        cell.accessoryType = habit.isCompleted ? .checkmark : .none

        return cell
    }
}

extension HabitListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let habit = viewModel.habit(at: indexPath.row)
        let detailViewModel = HabitDetailViewModel(habit: habit)
        let detailVC = HabitDetailViewController(viewModel: detailViewModel)

        detailVC.onHabitUpdated = { [weak self] updatedHabit in
            self?.viewModel.updateHabit(updatedHabit)
            self?.tableView.reloadData()
            self?.updateProgress()
        }

        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
