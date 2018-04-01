defmodule RandomReader.Mailer.Email do
  use Bamboo.Phoenix, view: Reader.EmailView
  import Bamboo.Email

  def new_email(body, email, title) do
    new_email()
    |> to(email)
    |> from("Random Paul Graham")
    |> subject(title)
    |> html_body(body)
  end


end
