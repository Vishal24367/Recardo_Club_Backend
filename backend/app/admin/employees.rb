ActiveAdmin.register Employee do
  # menu false

  permit_params :firstname, :lastname, :email, :password, :designation, :status, :department_id, :organization_id, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :employee_code,
  employee_roles_attributes: [:id, :role_id, :user_id, :ar_class_id, :_destroy]

  index do
    selectable_column
    column "Sr. No." do |user|
      user.id
    end
    column "Name" do |fullname|
      best_in_place fullname, 
        :fullname,
        as: :input, 
        url: [:admin, fullname]
      # best_in_place user.fullname, :fullname, :as => :input
    end
    column :department do |department|
      best_in_place department, 
        :department_id,
        as: :select, 
        url: [:admin, department],
        :collection => Department.all.map{|dep| [dep.id,dep.name]}.to_h
    end
    column :designation do |designation|
      best_in_place designation, 
        :designation, 
        url: [:admin, designation]
    end
    column :email do |email|
      best_in_place email, 
        :email, 
        url: [:admin, email]
    end
    actions name: "Permissions"
    column :status do |status|
      best_in_place status, 
        :status,
        as: :select, 
        url: [:admin, status],
        :collection => [['Active','Active'],['Inactive','Inactive']].to_h
    end
  end

  show do 
    emp_roles = resource.employee_roles
    attributes_table do
      row :name
      row :email
      row :designation
      row :status
      row :department
      row :organization
      row :employee_code
    end
    unless emp_roles.empty?
      panel "Roles" do 
        table_for emp_roles do
          column "School Name" do |emp|
            # byebugemp
            emp.ar_class.organization unless emp.ar_class.nil?
          end
          column "Department Name" do |emp|
            emp.ar_class.department unless emp.ar_class.nil?
          end
          column "Role" do |emp|
            emp.role.name.titleize
          end
          column "Class" do |emp|
            emp.ar_class unless emp.ar_class.nil?
          end
        end
      end
    end
  end

  form partial: 'partial_form'

  scope :all
  scope :Active
  scope :Inactive

  controller do 

    def scoped_collection
      super.includes(:roles, :employee_roles)
    end

  end
  
end
