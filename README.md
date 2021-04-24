# LouChat

API for real-time chatroom lobbies

## Use Cases

- User can register by creating an account with email, nickname, age, and password
- User can create a private lobby with the lobby name, description, and password
- User can create a public lobby with the name of the lobby and a description
- User can request the list of public lobbies paginated every 10
- User can connect to a private lobby by entering the name of the lobby and its password
- User can connect to a public lobby by passing the name of the lobby
- When a user connects to a lobby he receives the last 50 messages from it
- User can request the 50 messages prior to the message passed as a parameter
- User can send a message to the lobby
- When a new message is sent to a lobby all users connected to this lobby receive it
