
if Rails.env.development?
    # organization_id = Organization.first.id
    department = Department.create!(name:"Science")
    department_id = Department.first.id
    admin = Employee.create!(firstname: "Vishal", lastname: "Yadav", email: "vishal@yadav.com" , password:'arclasses', department_id:department_id, designation:"Admin")
    admin.confirm
    teacher = Employee.create!(firstname: "Yashasvi", lastname: "Sinha", email:"yashasvi@sinha.com", password:'arclasses', department_id:department_id, designation:"Teacher")
    teacher.confirm
    principal = Employee.create!(firstname: "K.B", lastname: "Dubey", email:"kb@dubey.com", password:'arclasses', department_id:department_id, designation:"Teacher")
    principal.confirm
    teacher_role = Role.create!(name:'teacher' )
    principal_role = Role.create!(name:'principal')
    admin_role = Role.create!(name:'admin' )

    EmployeeRole.create!(role: admin_role, employee: admin)
    EmployeeRole.create!(role: teacher_role, employee: teacher)
    EmployeeRole.create!(role: principal_role, employee: principal)

    employee = Employee.first
end
