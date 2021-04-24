defmodule LouChat.Chat.Lobby do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "lobbies" do
    field :description, :string
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :public, :boolean, default: false

    belongs_to :owner, LouChat.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(lobby, %{ "public" => public, "owner" => owner } = attrs) when public do
    lobby
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
    |> unique_constraint(:name, message: "There is already a lobby with this name")
    |> put_assoc(:owner, owner)
  end

  def changeset(lobby, %{ "owner" => owner } = attrs) do
    lobby
    |> cast(attrs, [:name, :description, :password])
    |> validate_required([:name, :description, :password])
    |> PasswordValidator.validate(
      :password,
      [
        length: [
          min: 4,
          max: 32
        ],
        character_set: [
          lower_case: 1,
          upper_case: 1,
          numbers: 1,
        ]
      ]
    )
    |> unique_constraint(:name, message: "There is already a lobby with this name")
    |> put_assoc(:owner, owner)
    |> put_pass_hash()
  end

  defp put_pass_hash(
    %Ecto.Changeset{
      valid?: true,
      changes: %{password: password}
    } = changeset
  ) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
