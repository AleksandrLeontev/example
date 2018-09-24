# app/services/affiliates/approve_service.rb
module Affiliates
  class ApproveService
    
    #gem interactor
    include Interactor
    
    def call
      check_already_approved

      ActiveRecord::Base.transaction do
        approve_affiliate
        synchronize
        log_activity
      end
    rescue ActiveRecord::RecordInvalid
      context.fail!(errors: affiliate.errors.full_messages)
    end

    private

    def check_already_approved
      context.fail!(errors: 'Already approved') if affiliate.approved?
    end

    def approve_affiliate
      affiliate.update!(state: Affiliate.states[:approved], approved_at: Time.current)
    end

    def log_activity
      Activity::AffiliateApproved.create!(subject: affiliate, payload: { user_id: current_user.id })
    end

    def synchronize
      client = SpecialClient.new(name: ssp_account.name, apikey: ssp_account.apikey)
      client.approve_affiliate(affiliate, current_user.fullname)
    end
    
    def affiliate
      context.object
    end
    
    def current_user
      context.user
    end

    def ssp_account
      affiliate.ssp_account
    end
  end
end
