require 'rails_helper'

Capybara.app_host = 'http://localhost:3000/'


RSpec.describe UsersController, :type => :controller do

  let(:valid_user) do
    {
      "user":
    {
      "fname":"bbb",
      "lname":"vv",
      "ysalary":33333
    }
  }
  end
  let(:invalid_user) do
    {
      "user":
    {
      "fname":nil,
      "lname":"nil",
      "ysalary":nil
    }
  }
  end
  let(:existing_id) do
    {
      "id":"24"
    }
  end

  let(:nonexisting_id) do
    {
      "id": (User.last[:id] + 1).to_s
    }
  end
  after(:example, response_renders_new: true) do
    expect(response).to render_template("new")
  end

  after(:example, check_json: true) do
    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response.status).to eq(200)
    expect(response.body).to include('"id":' + existing_id[:id])
    expect(response.body).to include('"fname":')
    expect(response.body).to include('"lname":')
    expect(response.body).to include('"ysalary":')
  end


  describe "GET users#index" do
    it 'should return json with all users', check_json: true do
      get :index
    end
  end

  describe "GET users#show" do
    context 'valid user id' do
      it 'should return json with the specified user', check_json: true do
        get :show, params: existing_id
      end
    end
    context 'invalid user id' do
      it 'should raise ActiveRecord::RecordNotFound' do
        expect{get :show, params: nonexisting_id}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "POST users#create" do
    context 'valid user' do
      it 'should save a user' do
        valid_user[:user].merge!(nonexisting_id)
        expect{post :create, params: valid_user}.to change{User.count}.by(1)
        expect(response).to redirect_to "/users/" + nonexisting_id[:id]
      end
    end
    context 'invalid user' do
      it 'should render users#new template', response_renders_new: true do
        invalid_user[:user].merge!(nonexisting_id)
        post :create, params: invalid_user
      end
    end
  end

  describe "GET users#new" do
    it 'should render users#new template', response_renders_new: true do
      get :new
    end
  end

  describe "DELETE users#destroy" do
    context 'existing user' do
      it "should delete a user" do
        expect{ delete :destroy, params: existing_id }.to change{User.count}.by(-1)
        expect(response.status).to eq(204)
      end
    end
    context 'nonexisting user' do
      it "should raise ActiveRecord::RecordNotFound" do
        expect{delete :destroy, params: nonexisting_id}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "UPDATE users#update" do
    context 'valid user' do
      it 'should update a user' do
        patch :update, params: valid_user.merge!(existing_id)
        user = User.find_by(id: existing_id[:id])
        expect(user.fname).to eq 'bbb'
        expect(user.lname).to eq 'vv'
        expect(user.ysalary).to eq 33333
        expect(response).to redirect_to "/users/" + existing_id[:id]
      end
    end
    context 'invalid user params' do
      it 'should render users#new template', response_renders_new: true do
        patch :update, params: invalid_user.merge!(existing_id)
      end
    end

    context 'invalid id' do
      it 'raise ActiveRecord::RecordNotFound' do
        expect{patch :update, params:
          valid_user.merge!(nonexisting_id)}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
