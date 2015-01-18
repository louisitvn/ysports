json.array!(@tasks) do |task|
  json.extract! task, :id, :pid, :progress, :status
  json.url task_url(task, format: :json)
end
