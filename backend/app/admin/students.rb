ActiveAdmin.register Student do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :email, :year, :roll_no, :section, :language, :skills, :contact_no, :codingPlatform, :handleNames, :dataStructureKnowledge, :department_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :email, :year, :roll_no, :section, :language, :skills, :contact_no, :codingPlatform, :handleNames, :dataStructureKnowledge, :department_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
