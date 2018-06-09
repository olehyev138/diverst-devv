class Expense < ActiveRecord::Base

    belongs_to :enterprise
    belongs_to :category, class_name: "ExpenseCategory"
    has_many :answer_expenses

    validates :name,        presence: true
    validates :enterprise,  presence: true
    validates :category,    presence: true
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

    def signed_price
        self.price * (self.income ? 1 : -1)
    end
end
