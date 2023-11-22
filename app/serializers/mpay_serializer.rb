class MpaySerializer < ActiveModel::Serializer
  attributes :id, :checkoutRequestID, :merchantRequestID, :amount, :mpesaReceiptNumber, :phoneNumber
end
