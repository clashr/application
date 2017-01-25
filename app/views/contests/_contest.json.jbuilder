json.extract! contest, :id, :name, :description, :duedate, :Timeout, :MemLimit, :Command, :Stdin, :created_at, :updated_at
json.url contest_url(contest, format: :json)