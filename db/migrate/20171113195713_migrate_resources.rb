class MigrateResources < ActiveRecord::Migration
  def change
    # find all resources currently not belonging to a folder or an initiative
    Resource.where.not(:container_type => "Folder").where.not(:container_type => "Initiative").find_each do |resource|
      # get the container
      container = resource.container
      
      # check if the container has a default folder
      if container.folders.where(:name => "Default").count > 0
        # get the default folder and add the resource
        default_folder = container.folders.where(:name => "Default").first
        default_folder.resources << resource
      else
        # create the default folder and add the resource
        default_folder = container.folders.new(:name => "Default")
        default_folder.save
        
        default_folder.resources << resource
      end
    end
  end
end
