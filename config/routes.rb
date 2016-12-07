Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  # ROLLBAR
  get 'verify' => 'rollbar_test#verify', :as => 'verify'

  # FACEBOOK MESSENGER WEBHOOK
  Rails.application.routes.draw do
    mount Facebook::Messenger::Server, at: 'bot'
  end
end
