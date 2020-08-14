Rails.application.config.middleware.use OmniAuth::Builder do
	provider :linkedin, '75291j3don9dv6', 'GwSLgQ7U08Z2yg1T',
					 :scope => "r_basicprofile r_emailaddress",
					 :field => ["id", "first-name", "last-name", "email-address", "headline", "picture-url", "public-profile-url"]

	provider :google_oauth2, '805591503502-odv2vuev98a3q84fggvok28ikhosfcda.apps.googleusercontent.com', 'Khb_zpppfceunALAxsMFSWM3', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end