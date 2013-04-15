class window.Game
  constructor: ->
    @gameName = $("div [data-game-name]").attr("data-game-name")
    $(".house-link").click(@selectHouse)

  selectHouse: (event) =>
    target = $(event.target)
    houseName = target.attr("data-house-name") ? target.parent().attr("data-house-name")
    $.ajax(
      type: "GET",
      url: "/ui/games/#{@gameName}/houses/#{houseName}",
      success: @onHouseSelected
    )

  onHouseSelected: (response) =>
    $("#mainPageDiv").html(response)
    $("#mainPageDiv").trigger("create")
