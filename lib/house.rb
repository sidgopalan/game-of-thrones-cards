class House
  attr_reader :house_name, :cards
  HOUSE_NAMES = ["baratheon", "lannister", "stark", "greyjoy", "tyrell", "martell"]

  HOUSE_BARATHEON = {
    "stannis" => {
      :status => "unused",
      :name => "Stannis Baratheon",
      :strength => 4,
      :special_ability => "If your opponent has a higher position on the Iron Throne Influence track" +
                          " than you, this card gains +1 combat strength.",
      :swords => 0,
      :fortresses => 0
    },
    "renly" => {
      :status => "unused",
      :name => "Renly Baratheon",
      :strength => 3,
      :special_ability => "If you win this combat, you may upgrade one of your participating Footmen" +
                          "(or one supporting Baratheon Footman) to a Knight.",
      :swords => 0,
      :fortresses => 0
    },
    "davos" => {
      :status => "unused",
      :name => "Ser Davos Seaworth",
      :strength => 2,
      :special_ability => "If 'Stannis Baratheon' is in your discard pile, this card gains +1 combat" +
                          "strength and a sword icon.",
      :swords => 0,
      :fortresses => 0
    },
    "brienne" => {
      :status => "unused",
      :name => "Brienne of Tarth",
      :strength => 2,
      :special_ability => "",
      :swords => 1,
      :fortresses => 1
    },
    "melisandre" => {
      :status => "unused",
      :name => "Melisandre",
      :strength => 1,
      :special_ability => "",
      :swords => 1,
      :fortresses => 0
    },
    "salladhor" => {
      :status => "unused",
      :name => "Salladhor Saan",
      :strength => 1,
      :special_ability => "If you are being supported in this Saan combat, the combat strength of all" +
                          " non-Baratheon Ships is reduced to 0.",
      :swords => 0,
      :fortresses => 0
    },
    "patchface" => {
      :status => "unused",
      :name => "Patchface",
      :strength => 0,
      :special_ability => "After combat, you may look at your opponent's hand and discard one card of" +
                          " your choice.",
      :swords => 0,
      :fortresses => 0
    }
  }

  HOUSE_LANNISTER = {
    "tywin" => {
      :status => "unused",
      :name => "Tywin Lannister",
      :strength => 4,
      :special_ability => "If you win this combat, gain two Power tokens.",
      :swords => 0,
      :fortresses => 0
    },
    "gregor" => {
      :status => "unused",
      :name => "Ser Gregor Clegane",
      :strength => 3,
      :special_ability => "",
      :swords => 3,
      :fortresses => 0
    },
    "hound" => {
      :status => "unused",
      :name => "The Hound",
      :strength => 2,
      :special_ability => "",
      :swords => 0,
      :fortresses => 2
    },
    "jaimie" => {
      :status => "unused",
      :name => "Ser Jaime Lannister",
      :strength => 2,
      :special_ability => "",
      :swords => 1,
      :fortresses => 0
    },
    "tyrion" => {
      :status => "unused",
      :name => "Tyrion Lannister",
      :strength => 1,
      :special_ability => "You may immediately return your opponent's House card to his hand. He must then" +
                          " choose a different House card. If he has no other House cards in hand, he" +
                          " cannot use a House card this combat.",
      :swords => 0,
      :fortresses => 0
    },
    "kevan" => {
      :status => "unused",
      :name => "Ser Kevan Lannister",
      :strength => 1,
      :special_ability => "If you are attacking, all of your participating Footman (including supporting" +
                          " Lannister footmen) add +2 combat strength instead of +1.",
      :swords => 0,
      :fortresses => 0
    },
    "cersei" => {
      :status => "unused",
      :name => "Cersei Lannister",
      :strength => 0,
      :special_ability => "If you win this combat, you may remove one of your opponent's Order tokens from" +
                          " anywhere on the board.",
      :swords => 0,
      :fortresses => 0
    }
  }

  HOUSE_STARK = {
    "eddard" => {
      :status => "unused",
      :name => "Eddard Stark",
      :strength => 4,
      :special_ability => "",
      :swords => 2,
      :fortresses => 0
    },
    "robb" => {
      :status => "unused",
      :name => "Robb Stark",
      :strength => 3,
      :special_ability => "If you win this combat, you may choose the area to which your opponent retreats." +
                          " You must choose a legal area where your opponent loses the fewest units.",
      :swords => 0,
      :fortresses => 0
    },
    "roose" => {
      :status => "unused",
      :name => "Roose Bolton",
      :strength => 2,
      :special_ability => "If you lose this combat, return your entire House card discard pile into your" +
                          " hand (including this card)",
      :swords => 0,
      :fortresses => 0
    },
    "greatjon" => {
      :status => "unused",
      :name => "Greatjon Umber",
      :strength => 2,
      :special_ability => "",
      :swords => 1,
      :fortresses => 0
    },
    "rodrick" => {
      :status => "unused",
      :name => "Ser Rodrick Cassel",
      :strength => 1,
      :special_ability => "",
      :swords => 0,
      :fortresses => 2
    },
    "blackfish" => {
      :status => "unused",
      :name => "The Blackfish",
      :strength => 1,
      :special_ability => "You do not take casualties in this combat from House card abilities, Combat" +
                          " icons, or Tides of Battle cards.",
      :swords => 0,
      :fortresses => 0
    },
    "catelyn" => {
      :status => "unused",
      :name => "Catelyn Stark",
      :strength => 0,
      :special_ability => "If you have a Defence Order token in the embattled area, its value is doubled.",
      :swords => 0,
      :fortresses => 0
    }
  }

  HOUSE_GREYJOY = {
    "euron" => {
      :status => "unused",
      :name => "Euron Crow's Eye",
      :strength => 4,
      :special_ability => "",
      :swords => 1,
      :fortresses => 0
    },
    "victarion" => {
      :status => "unused",
      :name => "Victarion Greyjoy",
      :strength => 3,
      :special_ability => "If you are attacking, all of your participating Ships (incl. supporting Greyjoy" +
                          " Ships) add +2 to combat strength instead of +1.",
      :swords => 0,
      :fortresses => 0
    },
    "theon" => {
      :status => "unused",
      :name => "Theon Greyjoy",
      :strength => 2,
      :special_ability => "If you are defending an area that contains either a Stronghold or a Castle, this" +
                          " card gains +1 combat strength and a sword icon.",
      :swords => 0,
      :fortresses => 0
    },
    "balon" => {
      :status => "unused",
      :name => "Balon Greyjoy",
      :strength => 2,
      :special_ability => "The printed combat strength of your opponent's House card is reduced to 0.",
      :swords => 0,
      :fortresses => 0
    },
    "asha" => {
      :status => "unused",
      :name => "Asha Greyjoy",
      :strength => 1,
      :special_ability => "If you are not being supported in this combat, this card gains two sword icons" +
                          " and one fortification icon.",
      :swords => 0,
      :fortresses => 0
    },
    "dagmar" => {
      :status => "unused",
      :name => "Dagmar Cleftjaw",
      :strength => 1,
      :special_ability => "",
      :swords => 1,
      :fortresses => 1
    },
    "aeron" => {
      :status => "unused",
      :name => "Aeron Damphair",
      :strength => 0,
      :special_ability => "You may immediately discard two Power tokens to discard Aeron Damphair and" +
                          " choose a different House Card from your hand (if able).",
      :swords => 0,
      :fortresses => 0
    }
  }

  HOUSE_TYRELL = {
    "mace" => {
      :status => "unused",
      :name => "Mace Tyrell",
      :strength => 4,
      :special_ability => "Immediately destroy one of your opponent's attacking or defending Footmen units.",
      :swords => 0,
      :fortresses => 0
    },
    "loras" => {
      :status => "unused",
      :name => "Ser Loras Tyrell",
      :strength => 3,
      :special_ability => "If you are attacking and win this combat, move the March Order token used into" +
                          " the conquered area to resolve again later this round.",
      :swords => 0,
      :fortresses => 0
    },
    "garlan" => {
      :status => "unused",
      :name => "Ser Garlan Tyrell",
      :strength => 2,
      :special_ability => "",
      :swords => 2,
      :fortresses => 0
    },
    "randyll" => {
      :status => "unused",
      :name => "Randyll Tarly",
      :strength => 2,
      :special_ability => "",
      :swords => 1,
      :fortresses => 0
    },
    "alester" => {
      :status => "unused",
      :name => "Alester Florent",
      :strength => 1,
      :special_ability => "",
      :swords => 0,
      :fortresses => 1
    },
    "margaery" => {
      :status => "unused",
      :name => "Margaery Tyrell",
      :strength => 1,
      :special_ability => "",
      :swords => 0,
      :fortresses => 1
    },
    "queen" => {
      :status => "unused",
      :name => "Queen of Thorns",
      :strength => 0,
      :special_ability => "Immediately remove one of your opponent's Order tokens in any area adjacent to" +
                          " the embattled area other than the March Order token used to start this combat.",
      :swords => 0,
      :fortresses => 0
    }
  }

  HOUSE_MARTELL = {
    "viper" => {
      :status => "unused",
      :name => "The Red Viper",
      :strength => 4,
      :special_ability => "",
      :swords => 2,
      :fortresses => 2
    },
    "areo" => {
      :status => "unused",
      :name => "Areo Hotah",
      :strength => 3,
      :special_ability => "",
      :swords => 0,
      :fortresses => 1
    },
    "obara" => {
      :status => "unused",
      :name => "Obara Sand",
      :strength => 2,
      :special_ability => "",
      :swords => 1,
      :fortresses => 0
    },
    "darkstar" => {
      :status => "unused",
      :name => "Darkstar",
      :strength => 2,
      :special_ability => "",
      :swords => 1,
      :fortresses => 0
    },
    "nymeria" => {
      :status => "unused",
      :name => "Nymeria Sand",
      :strength => 1,
      :special_ability => "If you are defending, this card gains a fortification icon. If you are" +
                          " attacking, this card gains a sword icon.",
      :swords => 0,
      :fortresses => 0
    },
    "arianne" => {
      :status => "unused",
      :name => "Arianne Martell",
      :strength => 1,
      :special_ability => "If you are defending and lose this combat, your opponent may not move his units" +
                          " into the embattled area. They return to the area from which they marched. Your" +
                          " own units must still retreat.",
      :swords => 0,
      :fortresses => 0
    },
    "doran" => {
      :status => "unused",
      :name => "Doran Martell",
      :strength => 0,
      :special_ability => "Immediately move your opponent to the bottom of one Influence track of your" +
                          " choice.",
      :swords => 0,
      :fortresses => 0
    }
  }

  def initialize(house_name)
    @house_name = house_name
    @cards = House.const_get("HOUSE_#{house_name.upcase}").dup
  end

  def update_card_status(card_name, card_status)
    @cards[card_name][:status] = card_status
  end

  def state
    { :name => @house_name, :cards => @cards }
  end

  def reset
    @cards.each_value { |card_details| card_details[:status] = "unused" }
  end
end