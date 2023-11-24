class MpaysController < ApplicationController
  require 'rest-client'
  @consumer_key = '2jHLG0U8uezHWOJTDaQd3U3KIFxSaQ5T'
  @consumer_secret = 'HhVfmPEt3Mj6OZxL'
  @passkey = 'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919'

  def stkpush
    phone_number = params[:phoneNumber]
    amount = params[:amount]

    url = "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest"
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    business_short_code = '174379'
    lipa_na_mpesa_online_passkey = Base64.strict_encode64("#{business_short_code}#{@passkey}#{timestamp}")

    payload = {
      BusinessShortCode: business_short_code,
      Password: lipa_na_mpesa_online_passkey,
      Timestamp: timestamp,
      TransactionType: "CustomerPayBillOnline",
      Amount: amount,
      PartyA: phone_number,
      PartyB: business_short_code,
      PhoneNumber: phone_number,
      CallBackURL: "https://webhook.site/2aa27f02-5cb4-4104-aaec-b9b89b34a479",
      AccountReference: 'YourAccountReference',
      TransactionDesc: 'Payment Description'
    }.to_json
    

    headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer #{get_access_token}"
    }
    puts "Payload: #{payload}"
  puts "Headers: #{headers}"

    response = RestClient::Request.execute(
      method: :post,
      url: url,
      payload: payload,
      headers: headers
    )

    render json: response.body
  rescue RestClient::ExceptionWithResponse => e
    render json: { error: "Failed to initiate STK push. #{e.response}" }, status: :unprocessable_entity #{e.response}" }, status: :unprocessable_entity
  end

  private

  def get_access_token
    # Set up the URL and credentials for OAuth token generation
    url = "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials"
    credentials = Base64.strict_encode64("#{@consumer_key}:#{@consumer_secret}")
  
    # Set up headers with the encoded credentials
    headers = {
      'Authorization': "Basic #{credentials}"
    }
  
    # Make a request to the Safaricom OAuth endpoint
    response = RestClient::Request.execute(
      method: :get,
      url: url,
      headers: headers
    )
  
    # Parse the response and extract the access token
    body = JSON.parse(response.body, symbolize_names: true)
    access_token = body[:access_token]
  
    # Assuming you have an AccessToken model to store the token
    AccessToken.destroy_all
    AccessToken.create!(token: access_token)
  
    # Return the access token
    access_token
  end
  
end
