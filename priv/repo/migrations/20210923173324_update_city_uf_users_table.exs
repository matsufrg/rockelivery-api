defmodule Rockelivery.Repo.Migrations.UpdateCityUfUsersTable do
  use Ecto.Migration

  def up do
    alter table "users" do
      add :city, :string, size: 40
      add :UF, :string
    end
  end

  def down do
    alter table "users" do
      remove :city,
      remove :UF
    end
  end
end
