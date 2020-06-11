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

    it { should belong_to(:user) }
    it { should have_many(:user_tickets).dependent(:destroy) }
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

  describe 'Ticket#owner' do
    let(:ticket) { create(:ticket, user_id: user.id)}
    let(:user) { create(:user) }

    it 'validates delegation of name to ticket' do
      expect(ticket.owner).to eq(user.name)
    end
  end

  describe 'Ticket#assigned' do
    let(:ticket) { create(:ticket, user_id: user.id)}
    let(:user) { create(:user) }

    context 'when ticket is not assigned' do
      it 'should return false on querying assign' do
        expect(ticket.assigned?).to be(false)
      end
    end

    context 'when ticket is assigned' do
      it 'assign ticket' do
        ticket.assign
        expect(ticket.assigned?).to be(true)
      end
    end
  end
end
