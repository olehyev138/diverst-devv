namespace :themes do
  desc 'Recompiles all themes for all enterprises'
  task recompile: :environment do
    Enterprise.joins(:theme).find_each do |enterprise|
      enterprise.theme.compile
    end
  end
end
