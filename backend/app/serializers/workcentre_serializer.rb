class WorkcentreSerializer < ActiveModel::Serializer
  attributes :id, :serial_number, :name, :level, :description, :type, :stage_id, :step_id, 
  :wip_limit, :state, :capacity, :configurations, :grid_id, :tat_in_mins, :generated_idn_number
  # , :very_critical_job_count, :critical_job_count, :need_attention_job_count, :normal_job_count, :bottleneck_count, :is_follow_up_workcentre

  # has_one :role
  has_one :accountable
  has_many :checklists, polymorphic: true
  has_many :jobs

  # def is_follow_up_workcentre
  #   object.tags.where(name: 'follow up workcentre').count > 0
  # end

  

  # def jobs
  #   object.jobs.order('complete_on asc')
  # end

  def generated_idn_number
    serialization_options[:idn_number] rescue nil
  end

end
