require 'test_helper'

class RepetitionsControllerTest < ActionController::TestCase
  setup do
    @repetition = repetitions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:repetitions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create repetition" do
    assert_difference('Repetition.count') do
      post :create, repetition: { correct: @repetition.correct, count: @repetition.count, form_id: @repetition.form_id, last: @repetition.last, mistake: @repetition.mistake, user_id: @repetition.user_id }
    end

    assert_redirected_to repetition_path(assigns(:repetition))
  end

  test "should show repetition" do
    get :show, id: @repetition
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @repetition
    assert_response :success
  end

  test "should update repetition" do
    patch :update, id: @repetition, repetition: { correct: @repetition.correct, count: @repetition.count, form_id: @repetition.form_id, last: @repetition.last, mistake: @repetition.mistake, user_id: @repetition.user_id }
    assert_redirected_to repetition_path(assigns(:repetition))
  end

  test "should destroy repetition" do
    assert_difference('Repetition.count', -1) do
      delete :destroy, id: @repetition
    end

    assert_redirected_to repetitions_path
  end
end
