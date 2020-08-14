module SocialAccountsHelper

  def fetch_user_data_from_google(token)
    uri = URI.parse('https://www.googleapis.com/oauth2/v1/userinfo')
    args = {:access_token=> token}
    response = send_request(uri, args, true)
    if response.nil?
      return nil
    else
      return JSON.parse response.body
    end
  end

  def fetch_user_data_from_fb(fields,token)
    uri = URI.parse('https://graph.facebook.com/me')
    args = {:access_token => token, :fields => fields.join(',')}
    response = send_request(uri, args)
    if response.nil?
      return nil
    else
      return JSON.parse response.body
    end
  end

  # def fetch_user_data_from_twitter(oauth_verifier)
  #   consumer_key = '0bV98Yv7mFSDvd1bNc2pFQ'
  #   consumer_secret = '9h5s4Rhg8zgtD1pf9Hjhqqz07oDCpnFvznmkehAyByY'
  #   begin
  #     oauth = OAuth::Consumer.new(consumer_key, consumer_secret,{ :site => "https://api.twitter.com" })


  #     request_token = OAuth::RequestToken.new(oauth, session[:request_token],session[:request_token_secret])
  #     access_token = request_token.get_access_token(:oauth_verifier => oauth_verifier)

  #     response = access_token.request(:get, "/1.1/account/verify_credentials.json")
  #   rescue
  #     @oauth_error = true
  #     respond_to do |format|
  #       format.html {render :layout=>false}
  #     end
  #     return
  #   end
  #   if response.nil?
  #     return nil
  #   else
  #     return JSON.parse response.body
  #   end
  # end

  ## For twitter callback to fetch data from twitter

  def send_request(uri, args, verify_http=false)
    uri.query = URI.encode_www_form(args)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    http.verify_mode = OpenSSL::SSL::VERIFY_NONE if verify_http
    begin
     request = Net::HTTP::Get.new(uri.request_uri)
     response = http.request(request)
     return response
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
           Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError, Net::HTTPBadRequest => e
     return nill
    end
  end
end