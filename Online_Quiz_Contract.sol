// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract OnlineQuiz {
    struct Question {
        string text;
        string[] options;
        string correctAnswer;
    }

    Question[] public questions;
    mapping(address => uint256) public scores;
    mapping(address => bool) public hasParticipated; // Track if a user has already participated

    constructor() {
        // Initialize the quiz with questions and options
        addQuestion(
            "What is the capital of France?",
            createOptions("Paris", "Berlin", "Madrid"),
            "Paris"
        );

        addQuestion(
            "What is 2 + 2?",
            createOptions("3", "4", "5"),
            "4"
        );

        addQuestion(
            "Who wrote 'Hamlet'?",
            createOptions("Charles Dickens", "William Shakespeare", "Jane Austen"),
            "William Shakespeare"
        );

        addQuestion(
            "What is the chemical symbol for water?",
            createOptions("H2O", "O2", "H2"),
            "H2O"
        );

        addQuestion(
            "What is the square root of 16?",
            createOptions("3", "4", "5"),
            "4"
        );

        addQuestion(
            "In which year did the Titanic sink?",
            createOptions("1912", "1905", "1920"),
            "1912"
        );

        addQuestion(
            "What is the largest planet in our Solar System?",
            createOptions("Earth", "Mars", "Jupiter"),
            "Jupiter"
        );

        addQuestion(
            "What is the freezing point of water in Celsius?",
            createOptions("-32", "0", "100"),
            "0"
        );

        addQuestion(
            "Who painted the Mona Lisa?",
            createOptions("Leonardo da Vinci", "Pablo Picasso", "Vincent van Gogh"),
            "Leonardo da Vinci"
        );

        addQuestion(
            "What is the speed of light in vacuum (in m/s)?",
            createOptions("300000000", "299792458", "150000000"),
            "299792458"
        );
    }

    // Helper function to create dynamic array of options
    function createOptions(string memory option1, string memory option2, string memory option3) internal pure returns (string[] memory options) {
        options = new string[](3) ; // Initialize the dynamic array with 3 slots
        options[0] = option1;
        options[1] = option2;
        options[2] = option3;
        return options;
    }

    // Function to add a new question
    function addQuestion(
        string memory _text,
        string[] memory _options,
        string memory _correctAnswer
    ) internal {
        questions.push(Question(_text, _options, _correctAnswer));
    }

    // Function to submit answers
    function submitAnswers(string[] memory _answers) public {
        require(!hasParticipated[msg.sender], "You have already participated.");
        require(_answers.length == questions.length, "Answer count does not match question count");
        
        uint256 score = 0;
        for (uint256 i = 0; i < _answers.length; i++) {
            if (keccak256(bytes(_answers[i])) == keccak256(bytes(questions[i].correctAnswer))) {
                score++;
            }
        }
        scores[msg.sender] = score;
        hasParticipated[msg.sender] = true; // Mark participant as having participated
    }

    // Function to get a user's score
    function getScore() public view returns (uint256) {
        require(hasParticipated[msg.sender], "You have not participated in this quiz.");
        return scores[msg.sender];
    }

    // Function to get a question with its options
    function getQuestion(uint256 _index) public view returns (string memory text, string[] memory options) {
        require(_index < questions.length, "Question does not exist");
        Question storage q = questions[_index];
        return (q.text, q.options);
    }
}

