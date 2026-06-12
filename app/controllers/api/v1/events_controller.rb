# frozen_string_literal: false

module Api
  module V1
    class EventsController < ApiController 
      before_action :set_event, only: [:show, :update, :destroy]
      respond_to :json
    
      def index
        user_organized_events = Event.organized_by_user(current_user)
        if user_organized_events.present?
          render json: EventSerializer.new(user_organized_events).serializable_hash[:data].pluck(:attributes)
        else
          render json: [], status: 204
        end
      end
    
      def create
        event = Event.new(event_params)
        if event.save
          render json: EventSerializer.new(event).serializable_hash[:data][:attributes], status: :created
        else
          render json: event.errors, status: :unprocessable_entity
        end
      end
    
      def update
        if @event.update(event_params)
          render json: EventSerializer.new(@event).serializable_hash[:data][:attributes]
        else
          render json: @event.errors, status: :unprocessable_entity
        end
    
      end
    
      def show
        render json: EventSerializer.new(@event).serializable_hash[:data][:attributes]
      end
      
      def destroy
       @event.destroy
       head :no_content
      end
    
      def add_user_to_events
        begin 
          raise ActionController::ParameterMissing.new("event_id") unless params["event_id"].present?
          event = Event.find_by(id: params["event_id"])
          if event.present?
            event_user = EventUser.new(event_id: event.id, user_id: current_user.id)
            if event_user.save
              render json: EventUserSerializer.new(event_user).serializable_hash[:data][:attributes], status: :created
            else
              render json: event_user.errors, status: :unprocessable_entity
            end
          else
            render json: 'Event Not Found', status: :unprocessable_entity
          end
        rescue ActionController::ParameterMissing => exception
          render json: exception
        end
      end
    
      def get_events
        not_joined_events = Event.not_joined_by_user(current_user).upcoming_events

        if not_joined_events.present?
          render json: EventSerializer.new(not_joined_events).serializable_hash[:data].pluck(:attributes), status: 200
        else
          render json: [], status: 204
        end
      end
    
      def joined_events
        events = current_user.events
        if events.present?
          render json: EventSerializer.new(events).serializable_hash[:data].pluck(:attributes)
        else
          render json: [], status: 204
        end
      end
    
      private
    
      def set_event
      begin
        @event = Event.find(params[:id])
      rescue ActiveRecord::RecordNotFound => exception
        render json: exception
      end
      end

      def event_params
        params.require(:event).permit(:name, :description, :date, :location).with_defaults(organizer_id: current_user.id)
      end
    end
  end
end
