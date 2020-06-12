require 'rails_helper'

RSpec.describe "Tickets", type: :request do

  let!(:ticket) { create(:ticket, user_id: user.id) }
  let!(:user) { create(:user) }

  describe "GET #index" do
    it "renders index template" do
      post login_path, params: { email: user.email, password: user.password  }
      get tickets_path

      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    it "renders show template" do
      post login_path, params: { email: user.email, password: user.password  }
      get ticket_path(ticket)

      expect(response).to be_successful
      expect(response).to render_template(:show)
    end
  end

  describe "DELETE #destroy" do
    it "redirects to index template with 204 status code" do
      post login_path, params: { email: user.email, password: user.password  }
      delete ticket_path(ticket)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(tickets_url)
    end
  end

  describe "GET #close_ticket" do
    it "marks a ticket as closed" do
      user.agent!

      post login_path, params: { email: user.email, password: user.password  }
      get close_ticket_path(ticket)
      expect {
        expect(response).to redirect_to(tickets_path)
        ticket.reload
      }.to change {
        ticket.closed?
      }.to(true)
    end

    context "ticket is already closed" do
      it "returns 400 status code" do
        post login_path, params: { email: user.email, password: user.password  }
        ticket.update_attribute("status", 1)

        get close_ticket_path(ticket)
        expect {
          expect(response).to redirect_to(tickets_path)
          ticket.reload
        }.to_not change {
          ticket.closed?
        }
      end
    end
  end

  describe "GET #reopen_ticket" do
    context "ticket is already active" do
      it "returns 400 status code" do
        post login_path, params: { email: user.email, password: user.password  }
        get reopen_ticket_path(ticket)
        expect {
          expect(response).to redirect_to(tickets_path)
          ticket.reload
        }.to_not change {
          ticket.active?
        }
      end
    end

    it "marks ticket as active" do
      user.admin!
      ticket.update_attribute("status", 1)


      post login_path, params: { email: user.email, password: user.password  }

      get reopen_ticket_path(ticket)
      expect {
        expect(response).to redirect_to(tickets_path)
        ticket.reload
      }.to change {
        ticket.active?
      }.to(true)
    end
  end
end
