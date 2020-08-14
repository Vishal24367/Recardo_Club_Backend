ActiveAdmin.register Organization do

  permit_params :name

  index do
    selectable_column
    column "Sr. No." do |ar_class|
      ar_class.id
    end
    column "Name" do |name|
      best_in_place name, 
        :name,
        as: :input, 
        url: [:admin, name]
    end
    actions name: "Permissions"
  end
  
end
