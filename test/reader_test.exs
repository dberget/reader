defmodule RandomReader.ReaderTest do
  use RandomReader.DataCase

  alias RandomReader.Reader
  alias RandomReader.Reader.Article

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:article, attrs \\ @create_attrs) do
    {:ok, article} = Reader.create_article(attrs)
    article
  end

  test "list_articles/1 returns all articles" do
    article = fixture(:article)
    assert Reader.list_articles() == [article]
  end

  test "get_article! returns the article with given id" do
    article = fixture(:article)
    assert Reader.get_article!(article.id) == article
  end

  test "create_article/1 with valid data creates a article" do
    assert {:ok, %Article{} = article} = Reader.create_article(@create_attrs)
  end

  test "create_article/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Reader.create_article(@invalid_attrs)
  end

  test "update_article/2 with valid data updates the article" do
    article = fixture(:article)
    assert {:ok, article} = Reader.update_article(article, @update_attrs)
    assert %Article{} = article
  end

  test "update_article/2 with invalid data returns error changeset" do
    article = fixture(:article)
    assert {:error, %Ecto.Changeset{}} = Reader.update_article(article, @invalid_attrs)
    assert article == Reader.get_article!(article.id)
  end

  test "delete_article/1 deletes the article" do
    article = fixture(:article)
    assert {:ok, %Article{}} = Reader.delete_article(article)
    assert_raise Ecto.NoResultsError, fn -> Reader.get_article!(article.id) end
  end

  test "change_article/1 returns a article changeset" do
    article = fixture(:article)
    assert %Ecto.Changeset{} = Reader.change_article(article)
  end
end
