defmodule RandomReader.Accounts.CheckComplete do
  alias RandomReader.Accounts
  
  def update_users(user_id) do
    master_article_count = Accounts.user_titles(999) |> List.first
    user_title_count = Accounts.user_titles(user_id) |> List.first 

    if user_title_count >= master_article_count, do: Accounts.mark_complete(user_id), else: nil 
  end
end
