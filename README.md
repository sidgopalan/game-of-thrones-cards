Game of Thrones Game: House Cards
=============================================

Simple web-app to synchronize the house-cards across players in the Game of Thrones board game.

Getting Started
---------------

- Start the server:

    ```
    bin/run_app.sh
    ```

- Create a game

    ```
    curl -XPOST "http://localhost:7000/games" -d '{"name": "some_game" }'
    ```

- Get the state of the game

    ```
    curl "http://localhost:7000/games/some_game"
    ```

- Update the house state

    ```
    curl -XPUT "http://localhost:7000/games/some_game/houses/baratheon" -d '[{ "card_name": "stannis", "card_status": "used" }]'
    ```


License
-------

Copyright (c) 2013 Siddharth Gopalan

[MIT License](http://www.opensource.org/licenses/mit-license.php)
