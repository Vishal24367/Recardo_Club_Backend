# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :environment, "#{Rails.env}"
every 5.minutes do
  # rake "google_sheet_migration:fms_po_upload", output: "log/whenever.log"
  # rake "google_sheet_migration:fms_reject_po_upload", output: "log/whenever.log"
  # rake "google_sheet_migration:fms_update", output: "log/whenever.log"
  # rake "google_sheet_migration:bom_upload", output: "log/whenever.log"
  # rake "google_sheet_migration:product_upload", output: "log/whenever.log"
end

every :sunday, at: '12pm' do
  rake "google_sheet_migration:vendor_upload", output: "log/whenever.log"
  rake "google_sheet_migration:po_upload", output: "log/whenever.log"
  rake "google_sheet_migration:item_upload", output: "log/whenever.log"
  rake "google_sheet_migration:item_sku_upload", output: "log/whenever.log"
  rake "google_sheet_migration:employee_upload", output: "log/whenever.log"
  rake "google_sheet_migration:country_upload", output: "log/whenever.log"
  rake "google_sheet_migration:city_upload", output: "log/whenever.log"
end

every 1.day, at: '4:30 am' do
  # rake "google_sheet_migration:employee_and_roles", output: "log/whenever.log"
end
