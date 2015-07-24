Rails.application.routes.draw do

  # Change the line below to handle every request through a subdomain
  #namespace :api, constraints: { subdomain: 'api' }, path: '/' do

  namespace :api, defaults: { format: :json}, path: '/api' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
    end
  end
  # namespace :api, path: '/api' do
  #   api_version(:module => "V1", :header => {:name => "Accept",
  #                                            :value => "application/vnd.twenty_one.com+json; version=1"},
  #                                            :defaults => {:format => :json}, :default => true) do
  #   end
  # end

end
