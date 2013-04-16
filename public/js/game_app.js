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
			self.render();
		});
	},


	onRender:function(){
		
		this.ui.content.empty();

		if(!this.house) {

			$('<tr class="house" data-house="baratheon"><td>Baratheon</td></tr>').appendTo(this.ui.content);
			$('<tr class="house" data-house="lannister"><td>Lannister</td></tr>').appendTo(this.ui.content);
			$('<tr class="house" data-house="stark"><td>Stark</td></tr>').appendTo(this.ui.content);
			$('<tr class="house" data-house="greyjoy"><td>Greyjoy</td></tr>').appendTo(this.ui.content);
			$('<tr class="house" data-house="tyrell"><td>Tyrell</td></tr>').appendTo(this.ui.content);
			$('<tr class="house" data-house="martell"><td>Martell</td></tr>').appendTo(this.ui.content);
		} else {
			var cards = this.model.get('houses')[this.house].cards;

			var names = Object.keys(cards);
			for( name in cards ) {
				$('<tr class="card"><td>'+cards[name].name+'</td></tr>')
				.appendTo(this.ui.content);
			}
		}
	},

	selectHouse:function(evt){
		var house = $(evt.target).closest('tr').attr('data-house');
		this.house = house;
		this.render();
		gotApp.vent.trigger('select:house', house);
	},

	selectCard:function(evt) {

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
		gotApp.vent.on('select:house', function(house){
			self.selectHouse(house);
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
			console.log('ignored:'+e.target);
				e.preventDefault();
				return;
		}

		if( $(e.target).closest('li').attr('id') == 'game' ) {
			gotApp.vent.trigger('nav:game');

			this.ui.nav.find('#house').remove();
			this.ui.nav.find('#game').addClass('active');
			e.preventDefault();
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
		'*action' : 'default',
	},

	joinGame:function(game_name) {
		gotApp.vent.trigger('joingame', game_name);
	},

	default:function(){
		gotApp.vent.trigger('allgames');
	}
})



