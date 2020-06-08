require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    it 'should be a valid model' do
      expect(Comment.new).to_not be_valid
    end

    it { should validate_presence_of(:content) }
  end
end
