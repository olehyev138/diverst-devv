class Website::LeadsController < ApplicationController
  before_action :cors_allow_all

  def create
    response = HTTParty.post 'https://api.getbase.com/v2/leads', headers: {
      'Authorization' => "Bearer #{ENV['BASECRM_API_KEY']}",
      'User-Agent' => 'HTTParty since your ruby library doesn\'t allow specifying lead sources ;)',
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    },
    body: {
      data: {
        source_id: 187_166,
        first_name: params['name'].split(' ').length > 1 ? params['name'].split(' ')[0] : params['name'],
        last_name: params['name'].split(' ').length > 1 ? params['name'].split(' ')[1..-1].join('') : '',
        organization_name: params['company'],
        email: params['email'],
        phone: params['phone'],
        address: {
          city: params['visitor_info']['city'],
          state: params['visitor_info']['region'],
          country: params['visitor_info']['country'],
          postal_code: params['visitor_info']['postal']
        },
        custom_fields: {
          'Number of users' => params['nbUsersInput'].to_i,
          'Size of DI department' => params['sizeOfDITeam'].to_i,
          'Turnover rate' => params['turnoverRate'].to_i,
          'Average salary' => params['averageSalaryInput'].to_i,
          'Network group name' => params['networkGroupName'],
          'Number of ERGs' => params['nbERGs'].to_i,
          'Has DI Initiatives' => params['hasDIInitiatives'],
          'Interested in' => params['interestedIn'],
          'Demo request message' => params['message'],
          'Heard about us through' => params['hearAboutUs'],
          'IP Address' => params['visitor_info']['ip']
        }
      }
    }.to_json

    head 201
  end
end
