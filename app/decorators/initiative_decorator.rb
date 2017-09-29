class InitiativeDecorator < Draper::Decorator
    decorates_association :updates

    def progress_percentage
        return nil if !initiative.start || !initiative.end
        return 100 if Time.current >= initiative.end
        (Time.current - initiative.start) / (initiative.end - initiative.start) * 100
    end

    def budget_percentage
        #Show empty bar if no funds is allocated
        return 0 if initiative.estimated_funding == 0

        #Show just barely visible bar if expences are expected but not published yet.
        initiative_expences = initiative.expenses.sum(:amount).to_f

        return 2 if initiative_expences == 0

        initiative_expences / initiative.estimated_funding * 100
    end
end
