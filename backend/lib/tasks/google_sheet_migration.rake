require "google_drive"
require 'securerandom'
CONFIG = YAML.load_file("#{Rails.root.to_s}/config/google_sheet_config.yml")
google_sheet_config = CONFIG[Rails.env]

namespace :google_sheet_migration do
  desc "Vendor Upload"
  task vendor_upload: :environment do
    begin
      session = GoogleDrive::Session.from_config("#{Rails.root}/config/#{google_sheet_config["credentials"]}")
      ws = session.spreadsheet_by_key(google_sheet_config["vendor_upload"]).worksheets[3]
      organization = Organization.find_by_name(google_sheet_config["organization"])

      (2..ws.num_rows).each do |row|
        if ws[row, 4].present? && !["Cancel", "NOT APPLICABLE", "N/A", "NOT AVAILABLE"].include?(ws[row, 4].strip)
          vendor_type = VendorType.where("lower(name)=?", ws[row, 4].strip.downcase).first_or_create
          vendor_type.update_attributes(
            name: ws[row, 4].strip,
            organization_id: organization.try(:id)
          )
        end
        if ws[row, 17].present? && !["NOT APPLICABLE", "N/A", "NOT AVAILABLE", "Cancel", "NA", "n/a"].include?(ws[row, 17].strip)
          import_export_code = ImportExportCode.where("lower(code)=?", ws[row, 17].strip.downcase).first_or_create
          import_export_code.update_attributes(
            code: ws[row, 17].strip,
            organization_id: organization.try(:id)
          )
        end
        if ws[row, 19].present? && !["Cancel", "N/A","NOT APPLICABLE", "NOT CONFIRM", "NOT CONFIRMED", "not confirm", "NOT AVAILABLE", "n/a", "100 % ADVANCED", "30 DAY", "30DAYS", "30  DAYS", "AGAINST  PERFORMA INVOCE", "AS  PER TERMS", "ASPER TERMS"].include?(ws[row, 19].strip)
          payment_term = PaymentTerm.where("lower(name)=?", ws[row, 19].strip.downcase).first_or_create
          payment_term.update_attributes(
            name: ws[row, 19].strip,
            organization_id: organization.try(:id)
          )
        end

        if ws[row, 1].present?
          vendor_exist = Vendor.find_by(name: ws[row, 5])
          checked_array = ["Cancel",  "NOT AVAILABLE", "NOT APPLICABLE", "#N/A", "N/A"]
          if vendor_exist.blank? && !checked_array.include?(ws[row, 5]) && !checked_array.include?(ws[row, 1])
            gstin = !checked_array.include?(ws[row, 16]) ? ws[row, 16] : "-"

            vendor = Vendor.create!(
              name: ws[row, 5],
              short_name: ws[row, 5],
              code: ws[row, 1],
              gstin: gstin,
              vendor_type_id: vendor_type.try(:id),
              import_export_code_id: import_export_code.try(:id),
              payment_term_id: payment_term.try(:id),
              organization_id: organization.try(:id)
            )

            city = City.where("lower(name)=?", ws[row, 9].downcase).first
            state = State.where("lower(name)=?", ws[row, 8].downcase).first
            country = Country.where("lower(name)=?", ws[row, 7].downcase).first

            if country.present? && state.present? && city.present?
              Address.create!(
                area: ws[row, 6],
                zipcode: ws[row, 11],
                city_id: city.try(:id),
                state_id: state.try(:id),
                country_id: country.try(:id),
                addressable: vendor,
                organization_id: organization.try(:id)
              )
            end

            [ws[row, 12], ws[row, 13], ws[row, 14]].uniq.each do |item|
              if item.present?
                checked_array = ["NOT APPLICABLE", "N/A", "NOT AVAILABLE", "NOY AVAILABLE", "Cancel"]
                contact_name  = !checked_array.include?(ws[row, 15].strip) ? ws[row, 15].strip : ""
                contact_email = !checked_array.include?(ws[row, 18].strip) ? ws[row, 18].strip : ""
                contact_phone = !checked_array.include?(item.strip) ? item.strip : ""

                if contact_name.present? || contact_email.present? || contact_phone.present?
                  Contact.create!(
                    name: contact_name,
                    email: contact_email,
                    phone: contact_phone,
                    contactable: vendor,
                    organization_id: organization.try(:id)
                  )
                end
              end
            end
          end
        end
      end
    rescue Exception => e
      Rails.logger.info e
    end
  end

  desc "Item Upload"
  task item_upload: :environment do
    begin
      session = GoogleDrive::Session.from_config("#{Rails.root}/config/#{google_sheet_config["credentials"]}")
      ws = session.spreadsheet_by_key(google_sheet_config["item_upload"]).worksheets[3]
      organization = Organization.find_by_name(google_sheet_config["organization"])

      (2..ws.num_rows).each do |row|
        if ws[row, 4].present? && !["Cancel"].include?(ws[row, 4].strip)
          type_of_consumption = TypeOfConsumption.where("lower(name)=?", ws[row, 4].strip.downcase).first_or_create
          type_of_consumption.update_attributes(
            name: ws[row, 4].strip,
            organization_id: organization.try(:id)
          )
        end
        if ws[row, 5].present? && !["Cancel"].include?(ws[row, 5].strip)
          type_of_purchase = TypeOfPurchase.where("lower(name)=?", ws[row, 5].strip.downcase).first_or_create
          type_of_purchase.update_attributes(
            name: ws[row, 5].strip,
            organization_id: organization.try(:id)
          )
        end
        if ws[row, 6].present? && !["Cancel", "NOT APPLICABLE", "NOT AVAILABLE", "FALSE"].include?(ws[row, 6].strip)
          material_type = MaterialType.where("lower(name)=?", ws[row, 6].strip.downcase).first_or_create
          material_type.update_attributes(
            name: ws[row, 6].strip,
            organization_id: organization.try(:id)
          )
        end
        if ws[row, 7].present? && !["Cancel", "NOT APPLICABLE", "NOT AVAILABLE"].include?(ws[row, 7].strip)
          raw_material_type = RawMaterialType.where("lower(name)=?", ws[row, 7].strip.downcase).first_or_create
          raw_material_type.update_attributes(
            name: ws[row, 7].strip,
            organization_id: organization.try(:id)
          )
        end
        if ws[row, 8].present? && !["Cancel", "NOT APPLICABLE", "NOT AVAILABLE"].include?(ws[row, 8].strip)
          component_description = ComponentDescription.where("lower(name)=?", ws[row, 8].strip.downcase).first_or_create
          component_description.update_attributes(
            name: ws[row, 8].strip,
            organization_id: organization.try(:id)
          )
        end
        if ws[row, 9].present? && !["Cancel", "NOT APPLICABLE", "NOT AVAILABLE"].include?(ws[row, 9].strip)
          grade = Grade.where("lower(name)=?", ws[row, 9].strip.downcase).first_or_create
          grade.update_attributes(
            name: ws[row, 9].strip,
            organization_id: organization.try(:id)
          )
        end
        if ws[row, 10].present? && !["Cancel", "NOT APPLICABLE", "NOT AVAILABLE"].include?(ws[row, 10].strip)
          dimension_specification = DimensionSpecification.where("lower(name)=?", ws[row, 10].strip.downcase).first_or_create
          dimension_specification.update_attributes(
            name: ws[row, 10].strip,
            organization_id: organization.try(:id)
          )
        end
        if ws[row, 11].present? && !["Cancel", "NOT APPLICABLE", "NOT AVAILABLE"].include?(ws[row, 11].strip)
          drawing = Drawing.where("lower(name)=?", ws[row, 11].strip.downcase).first_or_create
          drawing.update_attributes(
            name: ws[row, 11].strip,
            organization_id: organization.try(:id)
          )
        end
        if ws[row, 12].present? && ["BLACK", "TRANSPARENT", "SILVER", "WHITE", "BLUE", "AQUA GREEN", "GOLDEN", "FEROZE BLUE", "PU PAINTED SILVER", "NATURAL", "CYAN", "YELLOW", "MAGENTA", "RED", "LIGHT GRAY", "BLACK SMOKE", "GREEN", "GRAY", "OXFORD BLUE", "SIEMENS GRAY", "ORANGE", "BROWN", "IVORY", "COPPER", "BASE COAT GOLD", "SPARKLE BROWN", "PEARL WHITE", "TOPAZ GOLD", "MATT BRONZE", "SILVER ASH", "SKY BLUE", "PINK", "PURPLE", "MATT BLUE", "CANDY SILVER", "NAVY BLUE", "METALIC IVORY", "INDIGO BLUE"].include?(ws[row, 12].strip)
          color = Color.where("lower(name)=?", ws[row, 12].strip.downcase).first_or_create
          color.update_attributes(
            name: ws[row, 12].strip,
            organization_id: organization.try(:id)
          )
        end
        if ws[row, 15].present? && ws[row, 13].present? && !["Ele3833"].include?(ws[row, 15])
          item_exist = Item.where("lower(name)=? OR lower(code)=?", ws[row, 13].strip.downcase, ws[row, 15].strip.downcase).first_or_create
          item_exist.update_attributes!(
            name: ws[row, 13],
            description: ws[row, 13],
            code: ws[row, 15],
            type_of_consumption_id: type_of_consumption.try(:id),
            type_of_purchase_id: type_of_purchase.try(:id),
            material_type_id: material_type.try(:id),
            raw_material_type_id: raw_material_type.try(:id),
            component_description_id: component_description.try(:id),
            grade_id: grade.try(:id),
            dimension_specification_id: dimension_specification.try(:id),
            drawing_id: drawing.try(:id),
            color_id: color.try(:id),
            organization_id: organization.try(:id)
          )
        end
      end
    rescue Exception => e
      Rails.logger.info e
    end
  end

  desc "Item SKU Upload"
  task item_sku_upload: :environment do
    begin
      session = GoogleDrive::Session.from_config("#{Rails.root}/config/#{google_sheet_config["credentials"]}")
      ws = session.spreadsheet_by_key(google_sheet_config["item_upload"]).worksheets[5]
      organization = Organization.find_by_name(google_sheet_config["organization"])

      (2..ws.num_rows).each do |row|
        item = Item.where(code: ws[row, 4].strip)
        vendor = Vendor.where(name: ws[row, 6].strip)
        if ws[row, 5].present? && !["Cancel", "NOT APPLICABLE", "NOT AVAILABLE", "N/A", "AGNI CONTOL", "AMRON", "D - Link", "DSM INIDA PRIVATE LIMITED", "DSM", "EURO", "FOAMPACK INDIA", "KAESER COMPRESSOR", "KAESER", "M. M MOULDS", "NOT APLLICABLE", "NOT AVAILBALE", "N", "MR ENTERPRISES", "NOT AVALIBALE", "NOT AVIALABLE"].include?(ws[row, 5].strip)
          manufacturing_company = ManufacturingCompany.where("lower(name)=?", ws[row, 5].strip.downcase).first_or_create
          manufacturing_company.update_attributes(
            name: ws[row, 5].strip,
            organization_id: organization.try(:id)
          )
        end

        item_sku = ItemSku.where(
          vendor_id: vendor.first.try(:id),
          manufacturing_company_id: manufacturing_company.try(:id)
        )

        if item_sku.blank? && !(["#N/A"].include?(ws[row, 7]))
          if item.first.present? && vendor.first.present?
            ItemSku.create!(
              item_id: item.first.try(:id),
              sku_code: ws[row, 7],
              vendor_id: vendor.first.try(:id),
              manufacturing_company_id: manufacturing_company.try(:id),
              organization_id: organization.try(:id),
              state: 'approved'
            )
          end
        end
      end
    rescue Exception => e
      Rails.logger.info e
    end
  end

  desc "Employee Upload"
  task employee_upload: :environment do
    begin
      session = GoogleDrive::Session.from_config("#{Rails.root}/config/credentials.json")
      ws = session.spreadsheet_by_key(google_sheet_config["employee_upload"]).worksheets[1]
      organization = Organization.find_by_name(google_sheet_config["organization"])
      ws.reload

      (2..ws.num_rows).each do |row|
        dept_name = ws[row, 7]
        if dept_name.present? && !["Cancel", "NOT APPLICABLE", "NOT AVAILABLE"].include?(dept_name.strip)
          department = Department.where("lower(name)=?", dept_name.strip.downcase).first_or_create
          department.update_attributes(
            name: dept_name.strip,
            organization_id: organization.try(:id)
          )
        end
        pv_name = ws[row, 6]
        if pv_name.present? && !["Cancel", "NOT APPLICABLE", "NOT AVAILABLE"].include?(pv_name.strip)
          product_vertical = ProductVertical.where("lower(name)=?", pv_name.strip.downcase).first_or_create
          product_vertical.update_attributes(
            name: pv_name.strip,
            organization_id: organization.try(:id)
          )
        end

        if ws[row, 8].present? && !["Cancel", "NOT APPLICABLE", "NOT AVAILABLE", "SUPERVISIOR"].include?(ws[row, 8])
          role = Role.where("lower(name)=?", ws[row, 8].strip.downcase).first_or_create
          role.update_attributes(
            name: ws[row, 8],
            organization_id: organization.try(:id),
            department_id: department.try(:id)
          )

          employee = Employee.where(employee_code: ws[row, 4]).first_or_create
          lastname = ws[row, 2].present? ? ws[row, 2] : "User"
          employee.update_attributes(
            firstname: ws[row, 1],
            lastname: lastname,
            email: "#{ws[row, 1]}#{lastname}@sujatamail.com",
            password: 'new life',
            organization_id: organization.id,
            employee_code: ws[row, 4]
          )

          EmployeeRecord.create!(
            timestamp_update: ws[row, 13],
            timestamp_hiring: ws[row, 14],
            resume_id: ws[row, 15],
            hiring_code: ws[row, 18],
            mobile: ws[row, 16],
            address: ws[row, 17],
            joining_date: ws[row, 10],
            releaving_date: ws[row, 11],
            trigger_status: ws[row, 9],
            location: ws[row, 5],
            employee_id: employee.id
          ) if employee.present?

          employee_and_roles = EmployeeRole.where(user_id: employee.id, role_id: role.id).first_or_create
          employee_and_roles.update_attributes(
            user_id: employee.id,
            role_id: role.id
          )
        end
      end
    rescue Exception => e
      Rails.logger.info e
    end
  end

  desc "Country Upload"
  task country_upload: :environment do
    begin
      session = GoogleDrive::Session.from_config("#{Rails.root}/config/credentials.json")
      co = session.spreadsheet_by_key(google_sheet_config["country_city_upload"]).worksheets[0]
      organization = Organization.find_by_name(google_sheet_config["organization"])
      co.reload

      (2..co.num_rows).each do |row|
        if co[row, 1].present?
          country = Country.where("lower(name)=?", co[row, 1].strip.downcase).first_or_create
          country.update_attributes(
            name: co[row, 1],
            iso_code: co[row, 2],
            dialing_code: co[row, 5]
          )
        end
      end
    rescue Exception => e
      Rails.logger.info e
    end
  end

  desc "City Upload"
  task city_upload: :environment do
    begin
      session = GoogleDrive::Session.from_config("#{Rails.root}/config/credentials.json")
      ws = session.spreadsheet_by_key(google_sheet_config["country_city_upload"]).worksheets[1]
      organization = Organization.find_by_name(google_sheet_config["organization"])
      country = Country.find_by_name("India")
      ws.reload

      (2..ws.num_rows).each do |row|
        if ws[row, 1].present?
          state = State.where("lower(name)=? OR lower(code)=?", ws[row, 1].strip.downcase, ws[row, 2].strip.downcase).first_or_create
          state.update_attributes(
            name: ws[row, 3],
            code: ws[row, 2],
            country_id: country.try(:id)
          )
          district = District.where("lower(name)=?", ws[row, 5].strip.downcase).first_or_create
          district.update_attributes(
            name: ws[row, 5],
            code: ws[row, 4],
            state_id: state.try(:id),
            country_id: country.try(:id)
          )
          city = City.where("lower(name)=?", ws[row, 1].strip.downcase).first_or_create
          city.update_attributes(
            name: ws[row, 1],
            state_id: state.try(:id),
            district_id: district.try(:id),
            country_id: country.try(:id)
          )
        end
      end
    rescue Exception => e
      Rails.logger.info e
    end
  end

  desc "Payment Term Upload"
  task payment_term_upload: :environment do
    begin
      organization = Organization.find_by_name(google_sheet_config["organization"])
      [
        "PURCHASE", "BILL PAYMENT", "IN ACCOUNT PAYMENT ( 30 DAYS)",
        "IN ACCOUNT PAYMENT ( 20 DAYS)", "IN ACCOUNT PAYMENT ( 15 DAYS)",
        "IN ACCOUNT PAYMENT ( 45 DAYS)", "IN ACCOUNT PAYMENT ( 60 DAYS)",
        "IN ACCOUNT PAYMENT ( 70 DAYS)", "ADVANCE (AS APPROVAL)"
      ].each do |payment|
        payment_term = PaymentTerm.where("lower(name)=?", payment).first_or_create
        payment_term.update_attributes(
          name: payment,
          organization_id: organization.try(:id)
        )
      end
    rescue Exception => e
      Rails.logger.info e
    end
  end

  desc "Unit Upload"
  task unit_upload: :environment do
    begin
      session = GoogleDrive::Session.from_config("#{Rails.root}/config/#{google_sheet_config["credentials"]}")
      ws = session.spreadsheet_by_key(google_sheet_config["item_upload"]).worksheets[12]
      organization = Organization.find_by_name(google_sheet_config["organization"])
      ws.reload
      (2..ws.num_rows).each do |row|
        unit_name = ws[row, 3]
        if unit_name.present? && !["Cancel", "NOT APPLICABLE", "NOT AVAILABLE", "YES", "ROLL @ 304 METER", "PIECES EACH", "NYLON WHITE", "BANDLE", "BOTTELS", "BANDAL", "BUNDAL", "LETER", "LITRE", "METRE", "LENGHT"].include?(unit_name.strip)
          unit = Unit.where("lower(name)=?", unit_name.strip.downcase).first_or_create
          unit.update_attributes(
            name: unit_name.strip,
            organization_id: organization.try(:id)
          )
        end
      end
    rescue Exception => e
      Rails.logger.info e
    end
  end

  desc "Employee role"
  task employee_role: :environment do
    begin
      Employee.all.each do |e|
        EmployeeRole.create!([
          { user_id: e.id, role_id: 5 },
          { user_id: e.id, role_id: 6 },
          { user_id: e.id, role_id: 7 },
          { user_id: e.id, role_id: 8 }
        ])
      end
    rescue Exception => e
      Rails.logger.info e
    end
  end
end
