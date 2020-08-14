ActiveAdmin.register Department do

  permit_params :name, :organization_id

  index do 
    selectable_column
    column "Sr. No." do |dep|
      dep.id
    end
    column "Name" do |name|
      best_in_place name, 
        :name,
        as: :input, 
        url: [:admin, name]
      # best_in_place dep.name, :name, :as => :input
    end
    column :organization do |organization|
      best_in_place organization, 
        :organization_id,
        as: :select, 
        url: [:admin, organization],
        :collection => Organization.all.map{|org| [org.id,org.name]}.to_h
    end
    actions name: "Permissions"
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :organization_id, as: :select, collection: Organization.all
    end
    f.actions
  end
  
end
