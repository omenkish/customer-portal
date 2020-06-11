class ApplicationMailer < ActionMailer::Base
  default from: ENV["COMPANY_EMAIL"] || "noreply@customerportal.com"
  layout 'mailer'
end
