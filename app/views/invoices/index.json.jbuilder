json.array!(@invoices) do |invoice|
  json.extract! invoice, :id, :rise, :content
  json.url invoice_url(invoice, format: :json)
end
