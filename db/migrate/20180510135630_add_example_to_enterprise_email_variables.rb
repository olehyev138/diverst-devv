class AddExampleToEnterpriseEmailVariables < ActiveRecord::Migration
  def change
    add_column :enterprise_email_variables, :example, :text
    
    EnterpriseEmailVariable.where(:key => "user.name").update_all(:example => "John Smith")
    EnterpriseEmailVariable.where(:key => "group.name").update_all(:example => "Women's Advisory Group")
    EnterpriseEmailVariable.where(:key => "group_names").update_all(:example => "Women's Advisory Group, African Affinity Association")
    EnterpriseEmailVariable.where(:key => "campaign.title").update_all(:example => "Diverst Recruiting")
    EnterpriseEmailVariable.where(:key => "enterprise.id").update_all(:example => "20")
    EnterpriseEmailVariable.where(:key => "enterprise.name").update_all(:example => "Microsoft")
    EnterpriseEmailVariable.where(:key => "survey.title").update_all(:example => "Weekly Survey")
    EnterpriseEmailVariable.where(:key => "click_here").update_all(:example => "<a href=\"https://www.diverst.com\" target=\"_blank\">Click here</a>")
    EnterpriseEmailVariable.where(:key => "custom_text.erg_text").update_all(:example => "Inclusion Network")
    EnterpriseEmailVariable.where(:key => "user.name").update_all(:example => "John Smith") if EnterpriseEmailVariable.where(:key => "count").count > 0
    
    if EnterpriseEmailVariable.where(:key => "count").count < 1
      Enterprise.find_each do |enterprise|
        enterprise.email_variables.create!(:key => "count", :example => "4", :description => "Display a count of resources")
      end
    end
  end
end
