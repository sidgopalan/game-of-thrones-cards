class window.House
  constructor: ->
    @gameName = $("div [data-game-name]").attr("data-game-name")
    @houseName = $("div [data-game-name]").attr("data-house-name")
    # TODO (sid): Initialize the used cards using a callback rather than this hacky delay
    setTimeout(@initializeUsedCards, 200)
    $(".house-card-link").click(@toggleCard)

  initializeUsedCards: ->
    $("[data-card-status=used-card]").parent().addClass("used-card")

  toggleCard: (event) =>
    target = $(event.target)
    linkElement = if target.attr("data-card-key") then target else target.parent()
    cardKey = linkElement.attr("data-card-key")
    listElement = linkElement.parent()
    requestDisabledStatus = "used"

    if listElement.hasClass("used-card")
      listElement.removeClass("used-card")
      requestDisabledStatus = "unused"
    else
      listElement.addClass("used-card")

    requestBody = [{ "card_name": cardKey, "card_status": requestDisabledStatus }]
    $.ajax(
      type: "PUT",
      url: "/games/#{@gameName}/houses/#{@houseName}",
      data: JSON.stringify(requestBody)
    )