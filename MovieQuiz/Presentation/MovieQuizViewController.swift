import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - Lifecycle
    
    //    override var preferredStatusBarStyle: UIStatusBarStyle {
    //           .lightContent
    //       }
    //
    
    
    // MARK: - Types
    
    // MARK: - Constants
    
    // MARK: - Public Properties
    
    // MARK: - IBOutlet
    
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    // MARK: - Private Properties
    
    
    private  struct ViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    
    private var quizResults: QuizResultsViewModel?
    private var alert: AlertModel?
    private var alertPresenter: AlertPresenter?
    private var presenter: MovieQuizPresenter!
    // private var statistics: StatisticServiceImplementation?
    
    weak var delegate: UIViewController?
    
    

    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(delegate:self)
        //statistics = StatisticServiceImplementation()
        presenter = MovieQuizPresenter(viewController: self)
        presenter.viewController = self
        //  statistics?.resetStatistics()
        showLoadingIndicator()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    
    // MARK: - IBAction
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - Private Methods
    
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
    
    
    func showResults() {
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: presenter.makeResultMessage(),
            buttonText: "Сыграть еще раз!",
            buttonAction: { [weak self] in
                self?.presenter?.restartGame()
            }
        )
        alertPresenter?.showAlert(alertModel: alertModel)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    func resetBorderAndButtons() {
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let errorAlert = errorAlert(
            title: "Ошибка",
            buttonText: "Сыграть еще раз!"
        )
        
        alertPresenter?.showErrorAlert(errorAlert: errorAlert)
        presenter.restartGame()
    }
    
}
