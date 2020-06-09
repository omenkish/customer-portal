require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user)}

  describe 'validations' do
    it 'should be a valid model' do
      expect(User.new).to_not be_valid
    end

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }

    it { should define_enum_for(:role).
        with_values(
            customer: "customer",
            agent: "agent",
            admin: "admin"
        ).backed_by_column_of_type(:string) }

    it { should allow_values(:customer, :agent, :admin).for(:role) }
  end

  describe 'User#become_an_admin' do
    it 'make user an admin' do
      expect {
        user.become_an_admin
        user.reload
      }.to change {
        user.admin?
      }.to(true)
    end
  end

  describe 'User#become_an_agent' do
    it 'make user an agent' do
      expect {
        user.become_an_agent
        user.reload
      }.to change {
        user.agent?
      }.to(true)
    end
  end

  describe 'User#revoke_admin_or_agent_privilege' do
    it 'return admin or agent to customer role' do
      user.admin!
      expect {
        user.revoke_admin_or_agent_privilege
        user.reload
      }.to change {
        user.customer?
      }.to(true)
    end
  end
end
