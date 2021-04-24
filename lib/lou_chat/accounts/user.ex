defmodule LouChat.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    has_many :lobbies, LouChat.Chat.Lobby, foreign_key: :owner_id
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:name, min: 3, max: 16)
    |> PasswordValidator.validate(
      :password,
      [
        length: [
          min: 6,
          max: 32
        ],
        character_set: [
          lower_case: 1,
          upper_case: 1,
          numbers: 1,
        ]
      ]
    )
    |> unique_constraint(:email, message: "There is already a user with this email")
    |> unique_constraint(:name, message: "There is already a user with this name")
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
