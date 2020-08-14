module JobService
  class Job

    STATIC_ROUTING = {
      wc1: {yes:'wc2', no:'wc4'},
      wc2: {yes:'wc5', no:'wc3'},
      wc3: {yes:'wc4', no:'wc2'},
      wc4: {yes:'wc-on-hold', no:'wc1'},
      wc5: {yes:'wc6', no:'wc3'},
      wc6: {yes:'wc7', no:'wc3'},
      wc7: {no:'wc3'},
      wc8: {yes:'wc9'},
      wc9: {yes:'wc10', no:'wc8'},
      wc10: {yes:'wc11', no:'wc9'},
      wc11: {yes:'wc12', no:'wc10'},
      wc12: {yes:'wc13', no:'wc11'},
      wc13: {yes:'wc14'},
      wc14: {yes:'wc15', no:'wc16'},
      wc15: {yes:'wc20', no:'wc14'},
      wc16: {yes:'wc17', no:'wc14'},
      wc17: {yes:'wc18', no:'wc16'},
      wc18: {yes:'wc20', no:'wc17'},
      wc19: {yes:'wc20', no:'wc18'},
      wc20: {yes:'wc21', no:'wc19'},
      wc21: {yes:'wc22', no:'wc20'},
      wc22: {yes:'wc23', no:'wc21'},
      wc23: {yes:'wc24', no:'wc22'},
      wc24: {yes:'wc-completed', no:'wc23'}
    }

    def initialize(job,current_user)
      @job = job
      @current_user = current_user
    end

    def self.get_all_unassigned_jobs(current_user)
      unassigned_jobs = ::Job.where(organization_id: current_user.organization_id, :state => "new").includes(:purchase_order, :job_logs, comments:[:employee])
    end

    def route_job(action, last_job_log)
      wc_sym = @job.workcentre.name.to_sym
      next_wc_name = STATIC_ROUTING[wc_sym][action]
      next_wc = Workcentre.find_by(name: next_wc_name)
      if next_wc.present? and (next_wc_name == 'wc-on-hold' or next_wc_name == 'wc-completed')
        ActiveRecord::Base.transaction do
          last_job_log.completed_at = DateTime.now
          last_job_log.mark_complete
          comment_text = "#{@current_user.fullname.titleize} marked this job to #{last_job_log.state} state on #{last_job_log.workcentre.step.name} by choosing #{action.to_s} action"
          Comment.create!(:comment_text => comment_text, :employee_id => @current_user.id, :job_log_id => last_job_log.id, :job_id => @job.id, :organization_id => @current_user.organization_id, :is_editable => false)
          last_job_log.save!
          @job.workcentre = next_wc
          if next_wc_name == 'wc-on-hold'
            @job.mark_on_hold
          elsif next_wc_name == 'wc-completed'
            @job.mark_complete
            @job.completed_at = DateTime.now
          end
          @job.save!
        end
        return true, nil
      elsif next_wc.present?
        ActiveRecord::Base.transaction do
          last_job_log.completed_at = DateTime.now
          last_job_log.mark_complete
          @job.update!(workcentre: next_wc)
          last_comment = @job.comments.last
          last_comment.set_uneditable if last_comment
          comment_text = "#{@current_user.fullname.titleize} marked this job to #{last_job_log.state} state on #{last_job_log.workcentre.step.name} by choosing #{action.to_s} action"
          Comment.create!(:comment_text => comment_text, :employee_id => @current_user.id, :job_log_id => last_job_log.id, :job_id => @job.id, :organization_id => @current_user.organization_id, :is_editable => false)
          last_job_log.save!

          new_job_log = JobLog.new(job_id: @job.id, workcentre_id: next_wc.id, accountable: next_wc.accountable, organization_id: @current_user.organization_id)
          new_job_log.mark_active
          new_job_log.save!

          comment_text = "System moved the job to #{next_wc.step.name} in #{new_job_log.state} state"
          Comment.create!(:comment_text => comment_text, :employee_id => @current_user.id, :job_log_id => new_job_log.id, :job_id => @job.id, :organization_id => @current_user.organization_id, :is_editable => false)
        end
        return true, next_wc
      else
        return false, nil
      end
    end

    def update_core_object
      workcentre = @job.workcentre
      if @job.is_indent_job? and workcentre.present?
        if ["wc1","wc2","wc5"].include?(workcentre.name) and !@job.core_objectable.open?
          @job.core_objectable.open!
        elsif  ["wc3"].include?(workcentre.name) and !@job.core_objectable.on_hold?
          @job.core_objectable.on_hold!
        elsif  ["wc4"].include?(workcentre.name) and !@job.core_objectable.rejected?
          @job.core_objectable.rejected!
        elsif  ["wc6"].include?(workcentre.name) and !@job.core_objectable.accepted?
          @job.core_objectable.accepted!
        elsif  ["wc7"].include?(workcentre.name) and !@job.core_objectable.consignments_created?
          @job.core_objectable.consignments_created!
        end
      end
    end

  end
end
