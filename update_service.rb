#app/services/affiliates/update_service.rb
module Affiliates
  class UpdateService
    
    #gem interactor
    include Interactor
    
    def call
      return if affiliate.update(update_params)

      context.fail!(errors: affiliate.errors.full_messages)
    end

    private

    def affiliate
      context.object
    end

    def update_params
      context.params
    end
  end
end
