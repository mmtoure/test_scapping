require "test_helper"

class SubCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sub_category = sub_categories(:one)
  end

  test "should get index" do
    get sub_categories_url, as: :json
    assert_response :success
  end

  test "should create sub_category" do
    assert_difference("SubCategory.count") do
      post sub_categories_url, params: { sub_category: { category_id: @sub_category.category_id, name: @sub_category.name } }, as: :json
    end

    assert_response :created
  end

  test "should show sub_category" do
    get sub_category_url(@sub_category), as: :json
    assert_response :success
  end

  test "should update sub_category" do
    patch sub_category_url(@sub_category), params: { sub_category: { category_id: @sub_category.category_id, name: @sub_category.name } }, as: :json
    assert_response :success
  end

  test "should destroy sub_category" do
    assert_difference("SubCategory.count", -1) do
      delete sub_category_url(@sub_category), as: :json
    end

    assert_response :no_content
  end
end
