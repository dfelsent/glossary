require 'test_helper'

class GlossariesControllerTest < ActionController::TestCase
  setup do
    @glossary = glossaries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:glossaries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create glossary" do
    assert_difference('Glossary.count') do
      post :create, glossary: { definition: @glossary.definition, name: @glossary.name, number: @glossary.number }
    end

    assert_redirected_to glossary_path(assigns(:glossary))
  end

  test "should show glossary" do
    get :show, id: @glossary
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @glossary
    assert_response :success
  end

  test "should update glossary" do
    put :update, id: @glossary, glossary: { definition: @glossary.definition, name: @glossary.name, number: @glossary.number }
    assert_redirected_to glossary_path(assigns(:glossary))
  end

  test "should destroy glossary" do
    assert_difference('Glossary.count', -1) do
      delete :destroy, id: @glossary
    end

    assert_redirected_to glossaries_path
  end
end
