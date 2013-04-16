var GameModel = Backbone.Model.extend({
	urlRoot:'/games',
	idAttribute: 'name',
});

var GamesCollection = Backbone.Collection.extend({
	url:'/games',
	model:GameModel,
});

// ------------------


var GameView = Marionette.ItemView.extend({
	template:'#game_template',
	tagName:'tr',
	ui:{
		name:'td',
	},
	events: {
		'click td' : 'selectGame',
	},
	onRender:function(){
		var name = this.model.get('name');
		this.ui.name.html(name);
		// this.ui.name.attr('href', '#'+name);
	},
	selectGame:function(evt){
		var game = this.ui.name.text();
		// window.location = "#"+game;
		gotApp.router.navigate("#"+game, {trigger:true});
		return false;
	},
});

var GamesView = Marionette.CompositeView.extend({
	template: 'script#games_template',
	tagName:'table',
	className:'table',
	itemView: GameView,
	itemViewContainer:'tbody',
});


var HousesView = Marionette.ItemView.extend({
	template:'#houses_template',
	tagName:'table',
	className:'table',
	
	ui:{
		content:'tbody',
	},

	events:{
		'click tr.house' : 'selectHouse',
		'click tr.card'  : 'selectCard',
	},

	initialize:function() {
		var self = this;
		gotApp.vent.on('nav:game', function(game){
			self.house = null;
			self.model.fetch();
			//self.render();
		});

		gotApp.vent.on('click:house', function(gamehouse){
			self.house = gamehouse.house;
			self.render();
		});
		
		this.listenTo(this.model, 'sync', this.render);
	},


	onRender:function(){
		
		this.ui.content.empty();

		if(!this.house) {

			var houses = this.model.get('houses');

			for(var h in houses ) {
				var house = houses[h];

				var row = $("<tr></tr>")
					.addClass('house')
					.attr('data-house', h);

				var cell = $("<td></td>")
					.append("<strong>"+house.name+"</strong>");
				var cards = $("<div></div>")
					.addClass('pull-right');
					.addId(house.name + "-cards");

				for(c in house.cards) {
					var card = house.cards[c];

					if( card.status == 'used') {
						cards.append("<span class='badge badge-important'>"+card.strength+"</span> ");
					} else  {
						cards.append("<span class='badge'>"+card.strength+"</span> ");
					}
				}

				cell.append(cards);
				row.append(cell).appendTo(this.ui.content);

			}
		} else {
			var cards = this.model.get('houses')[this.house].cards;
			for( var name in cards ) {
				var card = cards[name];
				var cell = $("<td></td>")
					.append("<span class='badge badge-warning'>"+card.strength+"</span>")
					.append(" <Strong>"+card.name+"</Strong>")
					.append("<span class='pull-right'><span class='badge'>"+card.swords+"</span> <span class='badge'>"+card.fortresses+"</span></span>")
					.append("<div>"+card.special_ability+"</div>");

				var row = $('<tr class="card"></tr>').append(cell)
					.attr('data-house', this.house)
					.attr('data-card', name);
					
				if(card.status == 'used') {
					row.addClass('error');
				}
				row.appendTo(this.ui.content);
			}
		}
	},

	selectHouse:function(evt){
		var game = this.model.get('name');
		var house = $(evt.target).closest('tr').attr('data-house');
		gotApp.router.navigate("#"+game + "/"+house, {trigger:true});
	},

	selectCard:function(evt) {
		var game = this.model.get('name');
		var house = $(evt.target).closest('tr').attr('data-house');
		var card = $(evt.target).closest('tr').attr('data-card');

		console.log("house:"+house+", card:"+card);

		var status = this.model.get('houses')[house].cards[card].status;
		var newStatus = '';
		if (status == 'used') {
			$(evt.target).closest('tr').removeClass('error');
			newStatus = 'unused';
			this.model.get('houses')[house].cards[card].status = "unused";
		} else {
			$(evt.target).closest('tr').addClass('error');			
			newStatus = 'used';
			this.model.get('houses')[house].cards[card].status = "used";
		}

		requestBody = [{ "card_name": card, "card_status": newStatus }]
		$.ajax({
			type: "PUT",
			url: "/games/"+game+"/houses/"+house,
			data: JSON.stringify(requestBody)
		 });
	},


});


var AppLayout = Marionette.Layout.extend({
	template : '#layout_template',

	regions:{
		nav:'#nav-region',
		main:'#main-region',
	},

	ui:{
		btn_create:'button.btn-create',
		nav:'ul.nav',
	},

	events: {
		'click .btn-create' : 'doCreateGame',
		'click .nav li a' : 'doNav',

	},

	doCreateGame:function(){
		var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		var hash = '';
		for( var i=0; i < 4; i++ ) {
			hash += possible.charAt(Math.floor(Math.random() * possible.length));
		}
		var game = new GameModel();

		game.save({}, {
			data:JSON.stringify({ "name": hash }),
			success:function(){
				// console.log(game.toJSON());
			}
		});
		game.set('name', hash);
		this.collection.add(game);
	},

	initialize:function(options) {
		var self = this;
		gotApp.vent.on('joingame', function(game){
			self.joinGame(game);
		});
		gotApp.vent.on('allgames', function(game){
			self.allGames();
		});
		gotApp.vent.on('update:nav:house', function(house){
			self.selectHouse(house);
		});		
		gotApp.vent.on('click:house', function(gamehouse){
			
		});
	},

	onRender:function(){
		this.allGames();
	},

	selectHouse:function(house) {
		this.ui.nav.find('#house').remove();
		$('<li></li>')
			.addClass('active')
			.attr('id', 'house')
			.html("<a href='#'>"+house+"</a>")
			.appendTo(this.ui.nav);
		this.ui.nav.find('#allgames').removeClass('active');
		this.ui.nav.find('#game').removeClass('active');
		this.ui.btn_create.hide();
	},

	doNav:function(e){

		if( $(e.target).closest('li').hasClass('active') ) {
			// console.log('ignored:'+e.target);
				e.preventDefault();
				return false;
		}

		if( $(e.target).closest('li').attr('id') == 'game' ) {
			gotApp.vent.trigger('nav:game');

			this.ui.nav.find('#house').remove();
			this.ui.nav.find('#game').addClass('active');
			e.preventDefault();
			return false;
		} else {

		}

		// e.preventDefault();
	},

	allGames:function() {
		this.main.show( new GamesView({collection:this.collection}));
		this.ui.nav.find('#allgames').addClass('active');
		this.ui.nav.find("#game").remove();
		this.ui.nav.find("#house").remove();
		this.ui.btn_create.show();
	},

	joinGame:function(game) {		
		this.main.show(new HousesView({model:this.collection.get(game)}));
		// this.main.$el.find('div[data-role="collapsible-set"]').collapsibleset('refresh');
		this.ui.nav.find('#house').remove();
		this.ui.nav.find('#game').remove();
		
		$('<li></li>')
			.addClass('active')
			.attr('id', 'game')
			.html("<a href='#"+game+"'>"+game+"</a>")
			.appendTo(this.ui.nav);
		this.ui.nav.find('#allgames').removeClass('active');
		this.ui.btn_create.hide();
	}
});


AppRouter = Backbone.Router.extend({
	routes:{
		':game_name' : 'joinGame',
		':game_name/:house_name' : 'selectHouse',
		'*action' : 'default',
	},

	selectHouse:function(game_name, house_name) {
		console.log(game_name+","+house_name);
		gotApp.vent.trigger('click:house', {game:game_name, house:house_name});
		gotApp.vent.trigger('update:nav:house', house_name);
	},

	joinGame:function(game_name) {
		gotApp.vent.trigger('joingame', game_name);
	},

	default:function(){
		gotApp.vent.trigger('allgames');
	}
})



