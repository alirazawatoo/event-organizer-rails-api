require 'rails_helper'

RSpec.describe Api::V1::EventsController, type: :request do
  describe 'GET /api/v1/events' do
    it 'returns a list of events for the authenticated user' do
      user = create(:user)
      event = create(:event, organizer: user)

      sign_in user
      get '/api/v1/events'

      expect(response).to have_http_status(:success)
      expect(response.body).to include(event.name)
    end

    it 'returns unauthorized for unauthenticated user' do
      get '/api/v1/events'

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST /api/v1/events' do
    it 'creates a new event for the authenticated user' do
      user = create(:user)

      sign_in user
      post '/api/v1/events', params: { event: attributes_for(:event) }

      expect(response).to have_http_status(:created)
      expect(Event.count).to eq(1)
    end

    it 'returns unprocessable_entity for invalid event data' do
      user = create(:user)

      sign_in user
      post '/api/v1/events', params: { event: { name: '' } }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns unauthorized for unauthenticated user' do
      post '/api/v1/events', params: { event: attributes_for(:event) }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /api/events/:id' do
    it 'returns the details of a specific event for the authenticated user' do
      user = create(:user)
      event = create(:event, organizer: user)

      sign_in user
      get "/api/v1/events/#{event.id}"

      expect(response).to have_http_status(:success)
      expect(response.body).to include(event.name)
    end

    it 'returns unauthorized for unauthenticated user' do
      event = create(:event)

      get "/api/v1/events/#{event.id}"

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'PUT /api/v1/events/:id' do
    it 'updates the details of a specific event for the authenticated user' do
      user = create(:user)
      event = create(:event, organizer: user)

      sign_in user
      put "/api/v1/events/#{event.id}", params: { event: { name: 'Updated Name' } }

      expect(response).to have_http_status(:success)
      expect(event.reload.name).to eq('Updated Name')
    end

    it 'returns unauthorized for unauthenticated user' do
      event = create(:event)

      put "/api/v1/events/#{event.id}", params: { event: { name: 'Updated Event Name' } }

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unprocessable_entity if event name is too long' do
      user = create(:user)
      event = create(:event, organizer: user)

      sign_in user
      put "/api/v1/events/#{event.id}", params: { event: { name: 'The Historical Development of the Heart from Its Formation From Conference' } }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /api/v1/events/:id' do
    it 'deletes a specific event for the authenticated user' do
      user = create(:user)
      event = create(:event, organizer: user)

      sign_in user
      delete "/api/v1/events/#{event.id}"

      expect(response).to have_http_status(:no_content)
      expect(Event.count).to eq(0)
    end

    it 'returns unauthorized for unauthenticated user' do
      event = create(:event)

      delete "/api/v1/events/#{event.id}"

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST /api/v1/events/add_user_to_events' do
    it 'adds the authenticated user to a specific event' do
      user = create(:user)
      event = create(:event)
  
      sign_in user
      post '/api/v1/events/add_user_to_events', params: { event_id: event.id }
  
      expect(response).to have_http_status(:created)
      expect(EventUser.count).to eq(1)
    end
  
    it 'returns unprocessable_entity if the event is not found' do
      user = create(:user)
  
      sign_in user
      post '/api/v1/events/add_user_to_events', params: { event_id: 999 }
  
      expect(response).to have_http_status(:unprocessable_entity)
    end
  
    it 'returns unauthorized for unauthenticated user' do
      event = create(:event)
  
      post '/api/v1/events/add_user_to_events', params: { event_id: event.id }
  
      expect(response).to have_http_status(:unauthorized)
    end
  end
  
  describe 'GET /api/v1/events/get_events' do
    it 'returns events not joined by the authenticated user' do
      user = create(:user)
      event1 = create(:event)
      event2 = create(:event)
  
      sign_in user
      get '/api/v1/events/get_events'
  
      expect(response).to have_http_status(:success)
      expect(response.body).to include(event1.name)
      expect(response.body).to include(event2.name)
    end
  
    it 'returns 204 status if all events are joined by the authenticated user' do
      user = create(:user)
      event = create(:event)
  
      sign_in user
      create(:event_user, user: user, event: event)
      get '/api/v1/events/get_events'
  
      expect(response).to have_http_status(:success)
      expect(response.status).to eq(204)
    end
  
    it 'returns unauthorized for unauthenticated user' do
      get '/api/v1/events/get_events'
  
      expect(response).to have_http_status(:unauthorized)
    end
  end
  
  describe 'GET /api/v1/events/joined_events' do
    it 'returns events joined by the authenticated user' do
      user = create(:user)
      event1 = create(:event)
      event2 = create(:event)
  
      sign_in user
      create(:event_user, user: user, event: event1)
      create(:event_user, user: user, event: event2)
  
      get '/api/v1/events/joined_events'
  
      expect(response).to have_http_status(:success)
      expect(response.body).to include(event1.name)
      expect(response.body).to include(event2.name)
    end
  
    it 'returns 204 status if the authenticated user has not joined any events' do
      user = create(:user)
  
      sign_in user
      get '/api/v1/events/joined_events'
      expect(response).to have_http_status(:success)
      expect(response.status).to eq(204)
    end
  
    it 'returns unauthorized for unauthenticated user' do
      get '/api/v1/events/joined_events'
  
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
