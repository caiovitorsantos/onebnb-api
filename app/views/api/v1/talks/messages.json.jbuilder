json.talks do
  # Mostra as informações do User
  json.user do
    # Filtra para mostrar as informações do outro User da Conversa
    @user = (current_api_v1_user == @api_v1_talks.property.user) ? @api_v1_talks.user : @api_v1_talks.property.user
    json.extract! @user, :id, :name, :photo
  end

  # Mostra as informações da reserva caso existam
  if @api_v1_talks.reservation
    json.reservation do
      json.extract! @api_v1_talks.reservation, :id, :status, :checkin_date, :checkout_date
      # Devolve a quantidade de dias da reserva
      json.interval @api_v1_talks.reservation.interval_of_days
      # Devolve o preço baseado na quantidade de dias e no preço diario da Propriedade
      # TODO: Mudar no futuro para que use o preço que for gerado quando o reserva for aceita
      json.price (@api_v1_talks.reservation.interval_of_days * @api_v1_talks.reservation.property.price)

      json.address do
        json.extract @api_v1_talks.reservation.property.address, :country,
                                                    :state,
                                                    :city,
                                                    :neighborhood,
                                                    :street,
                                                    :number,
                                                    :zipcode,
                                                    :latitude,
                                                    :longitude
      end
    end
  end

  json.messages do
    json.array! @api_v1_talks.messages.order("created_at DESC") do |message|
      json.extract! message, :id, :body, :created_at

      json.user do
        json.extract! message.user, :id, :name, :photo
      end
      # Diz se eu sou o dono da mensagem ou não, isso ajuda a alinharmos as mensagens
      # no front end
      json.message_owner (current_api_v1_user == message.user)
    end
  end
end