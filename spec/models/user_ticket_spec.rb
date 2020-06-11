require 'rails_helper'

RSpec.describe UserTicket, type: :model do
  describe "Validations and relationships" do
    it { should belong_to(:ticket) }

    it { should belong_to(:user) }
  end
end
