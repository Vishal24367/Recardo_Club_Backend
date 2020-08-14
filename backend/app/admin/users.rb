ActiveAdmin.register User do
  menu false
  permit_params :email, :password, :password_confirmation

  config.filters = false
  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions name:"Actions"
  end

  show do
    attributes_table do
      row :firstname
      row :lastname
      row :email
      row :recent_password_sent_at
      row :remember_created_at
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :confirmed_at
      row :confirmation_sent_at
      row :unconfirmed_email
      row :created_at
      row :updated_at
      row :gender
      row :date_of_birth
      row :otp
      row :state
      row :manager
      row :title
      row :employee_code
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
  
end
