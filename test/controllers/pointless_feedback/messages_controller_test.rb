require 'test_helper'

module PointlessFeedback
  class MessagesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @message = pointless_feedback_messages(:one)
      @valid_params = {
        message: {
          description: 'Test description',
          email_address: 'test@example.com',
          name: 'Test User',
          topic: 'Question',
          contact_info: '123-456-7890',
          previous_url: 'http://example.com'
        }
      }
    end

    test "should get new" do
      get new_message_url
      assert_response :success
      assert_not_nil assigns(:message)
    end

    test "should create message with valid params and captcha" do
      original_pass = PointlessFeedback::Captcha.method(:pass?)
      PointlessFeedback::Captcha.define_singleton_method(:pass?) { |_| true }
      assert_difference('Message.count') do
        post messages_url, params: @valid_params
      end
      assert_response :redirect
      assert_equal "Thanks for your feedback!", flash[:notice]
    ensure
      PointlessFeedback::Captcha.define_singleton_method(:pass?, original_pass)
    end

    test "should not create message with invalid params" do
      invalid_params = @valid_params.deep_merge(message: { email_address: 'invalid_email' })
      assert_no_difference('Message.count') do
        post messages_url, params: invalid_params
      end
      assert_template :new
    end

    test "should pass captcha when not using captcha" do
      original_using_captcha = PointlessFeedback.method(:using_captcha?)
      PointlessFeedback.define_singleton_method(:using_captcha?) { false }
      assert_difference('Message.count') do
        post messages_url, params: @valid_params
      end
      assert_response :redirect
    ensure
      PointlessFeedback.define_singleton_method(:using_captcha?, original_using_captcha)
    end
  end
end