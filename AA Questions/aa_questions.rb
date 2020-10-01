require "singleton"
require "sqlite3"
require 'byebug'

class QuestionsDatabase < SQLite3::Database
    include Singleton
    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class Question
    attr_accessor :id, :title, :body, :associated_author_id
    def initialize(options)
        @id = options["id"]
        @title = options["title"]
        @body = options["body"]
        @associated_author_id = options["associated_author_id"]
    end

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
        data.map {|datum| Question.new(datum)}

    end

    def self.find_by_id(id)
        found_id = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT 
                *
            FROM
                questions
            WHERE 
                questions.id = ?
        SQL
        found_id.map {|data| Question.new(data)}
    end
    # Question::find_by_author_id(author_id)
    def self.find_by_author_id(author_id)
        found_author_id = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT 
                *
            FROM
                questions
            WHERE 
                questions.associated_author_id = ?
        SQL
        found_author_id.map {|data| Question.new(data)}
    end

# Question#author
    def author
        User.find_by_id(self.id)
    end
# Question#replies (use Reply::find_by_question_id)
    def replies
        Reply.find_by_question_id(self.id)
    end
end

class User
    attr_accessor :id, :first_name, :last_name
    def initialize(options)
        @id = options["id"]
        @first_name = options["first_name"]
        @last_name = options["last_name"]
    end

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM users")
        data.map {|datum| User.new(datum)}

    end

    def self.find_by_id(id)
        found_id = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT 
                *
            FROM
                users
            WHERE 
                users.id = ?
        SQL
        found_id.map {|data| User.new(data)}
    end
# User::find_by_name(fname, lname)
    def self.find_by_name(first_name, last_name)
        found_name = QuestionsDatabase.instance.execute(<<-SQL, first_name, last_name)
            SELECT 
                *
            FROM
                users
            WHERE 
                users.first_name = ? AND users.last_name = ?
        SQL
        found_name.map {|data| User.new(data)}
    end

# User#authored_questions (use Question::find_by_author_id)
    def authored_questions
        Question.find_by_author_id(self.id)
    end
# User#authored_replies (use Reply::find_by_user_id)
    def authored_replies
        Reply.find_by_user_id(self.id)
    end
end

class QuestionFollows
    attr_accessor :id, :user_id, :question_id
    def initialize(options)
        @id = options["id"]
        @user_id = options["user_id"]
        @question_id = options["question_id"]
    end

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows")
        data.map {|datum| QuestionFollows.new(datum)}

    end

    def self.find_by_id(id)
        found_id = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT 
                *
            FROM
                question_follows
            WHERE 
                question_follows.id = ?
        SQL
        found_id.map {|data| QuestionFollows.new(data)}
    end
end
class Reply
    attr_accessor :id, :question_id, :user_id, :parent_reply_id, :body
    def initialize(options)
        @id = options["id"]
        @question_id = options["question_id"]
        @user_id = options["user_id"]
        @parent_reply_id = options["parent_reply_id"]
        @body = options["body"]
    end

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
        data.map {|datum| Reply.new(datum)}

    end

    def self.find_by_id(id)
        found_id = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT 
                *
            FROM
                replies
            WHERE 
                replies.id = ?
        SQL
        found_id.map {|data| Reply.new(data)}
    end

# Reply::find_by_user_id(user_id)
    def self.find_by_user_id(user_id)
        found_user_id = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT 
                *
            FROM
                replies
            WHERE 
                replies.user_id = ?
        SQL
        found_user_id.map {|data| Reply.new(data)}
    end

# Reply::find_by_question_id(question_id)
    def self.find_by_question_id(question_id)
        found_question_id = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT 
                *
            FROM
                replies
            WHERE 
                replies.question_id = ?
        SQL
        found_question_id.map {|data| Reply.new(data)}
    end
# All replies to the question at any depth.

# Reply#author
    def author
        User.find_by_id(self.author_id)
    end
# Reply#question
# Reply#parent_reply
# Reply#child_replies
# Only do child replies one-deep; don't find grandchild comments.
# Test out your newly written queries in the console. Don't move on until you have everything working.
end

class QuestionLike
    attr_accessor :id, :user_id, :question_id
    def initialize(options)
        @id = options["id"]
        @user_id = options["user_id"]
        @question_id = options["id"]
    end

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM question_likes")
        data.map {|datum| QuestionLike.new(datum)}

    end

    def self.find_by_id(id)
        found_id = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT 
                *
            FROM
                question_likes
            WHERE 
                question_likes.id = ?
        SQL
        found_id.map {|data| QuestionLike.new(data)}
    end
end

