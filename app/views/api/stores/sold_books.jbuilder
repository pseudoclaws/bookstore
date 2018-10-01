if @result.failure?
  json.errors @result.errors.full_messages
else
  json.amount @result.amount
end