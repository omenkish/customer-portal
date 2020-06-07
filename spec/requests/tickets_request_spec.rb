require 'rails_helper'

RSpec.describe "Tickets", type: :request do
  # include ApplicationHelper
  # include TicketsHelper

  let!(:ticket) { create(:ticket, user_id: user.id) }
  let(:user) { create(:user) }

  describe "GET #index" do
    it "renders index template" do
      get tickets_path

      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    it "renders show template" do
      get ticket_path(ticket)

      expect(response).to have_http_status(200)
      expect(response).to render_template(:show)
    end
  end

  describe "DELETE #destroy" do
    it "redirects to index template with 204 status code" do
      delete ticket_path(ticket)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(tickets_url)
    end
  end

  describe "GET #close_ticket" do
    it "marks a ticket as closed" do
      get close_ticket_path(ticket)
      expect {
        expect(response).to have_http_status(200)
        ticket.reload
      }.to change {
        ticket.closed?
      }.to(true)
    end

    context "ticket is already closed" do
      it "returns 400 status code" do
        ticket.update_attribute("status", 1)

        get close_ticket_path(ticket)
        expect {
          expect(response).to have_http_status(400)
          ticket.reload
        }.to_not change {
          ticket.closed?
        }
      end
    end
  end

  describe "GET #make_ticket_active" do
    context "ticket is already active" do
      it "returns 400 status code" do
        get activate_ticket_path(ticket)
        expect {
          expect(response).to have_http_status(400)
          ticket.reload
        }.to_not change {
          ticket.active?
        }
      end
    end

    it "marks ticket as active" do
      ticket.update_attribute("status", 1)

      get activate_ticket_path(ticket)
      expect {
        expect(response).to have_http_status(200)
        ticket.reload
      }.to change {
        ticket.active?
      }.to(true)
    end
  end
end
