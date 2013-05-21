require 'test_helper'

class CareerSitesControllerTest < ActionController::TestCase
  setup do
    @career_site = career_sites(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:career_sites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create career_site" do
    assert_difference('CareerSite.count') do
      post :create, career_site: { name: @career_site.name }
    end

    assert_redirected_to career_site_path(assigns(:career_site))
  end

  test "should show career_site" do
    get :show, id: @career_site
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @career_site
    assert_response :success
  end

  test "should update career_site" do
    put :update, id: @career_site, career_site: { name: @career_site.name }
    assert_redirected_to career_site_path(assigns(:career_site))
  end

  test "should destroy career_site" do
    assert_difference('CareerSite.count', -1) do
      delete :destroy, id: @career_site
    end

    assert_redirected_to career_sites_path
  end
end
