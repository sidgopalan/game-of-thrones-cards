class window.GameSelection
  constructor: ->
    $("#gameCreationButton").click(@createGame)
    $("#existingGameLinks a").click(@selectGame)

  createGame: (event) =>
    event.preventDefault()
    game_name = $("#gameNameInput").val()
    return if game_name == ""
    $.ajax(
      type: "POST",
      url: "/ui/games",
      data: JSON.stringify({ "name": game_name }),
      success: @onGameCreated
    )

  onGameCreated: (response) =>
    $("#mainPageDiv").html(response)
    $("#mainPageDiv").trigger("create")

  selectGame: (event) =>
    target = $(event.target)
    game_name = target.attr("data-game-name") ? target.parent().attr("data-game-name")
    $.ajax(
      type: "GET",
      url: "/ui/games/#{game_name}",
      success: @onGameSelected
    )

  onGameSelected: (response) =>
    $("#mainPageDiv").html(response)
    $("#mainPageDiv").trigger("create")
