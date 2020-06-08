require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe 'validations' do
    it 'should be a valid model' do
      expect(Ticket.new).to_not be_valid
    end

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }

    it { should define_enum_for(:status).
        with_values(
            active: 0,
            closed: 1
        ).backed_by_column_of_type(:integer) }

    it { should allow_values(:active, :closed).for(:status) }
  end

  describe 'Ticket#close' do
    let!(:user) { create(:user)}
    let(:ticket) { create(:ticket, user_id: user.id)}

    it 'marks ticket as closed' do
      expect {
        ticket.close
        ticket.reload
      }.to change {
        ticket.closed?
      }.to(true)
    end
  end

  describe 'Ticket#reopen' do
    let(:ticket) { create(:ticket, status: Ticket.statuses['closed'])}

    it 'marks ticket as active' do
      expect {
        ticket.reopen
        ticket.reload
      }.to change {
        ticket.active?
      }.to(true)
    end
  end
end
