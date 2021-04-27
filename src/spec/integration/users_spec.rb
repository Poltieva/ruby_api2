require 'swagger_helper'

RSpec.describe 'Users API' do
  path '/users' do
    get 'Get all users' do
      tags 'user'
      description 'Returns a json with all users (optionally sorted and ordered, default - sorted by salary descending)'
      operationId getUsers
      produces 'application/json'
      parameter name: :sort_by in: :query schema: {
        type: string
        # enum:
        #   - id
        #   - fname
        #   - lname
        #   - ysalary
      }
          description 'sort method (by id, first name, last name, salary)'
          required: false
        # - name: order
        #   in: query
        #   description: 'order method (ascending, descending)'
        #   required: false
        #   schema:
        #     type: string
        #     enum:
        #       - ASC
        #       - DESC
      response '200', 'successful operation' do
              schema:
                type: array,
                items:
                  {$ref: '#/components/schemas/User'}
end
