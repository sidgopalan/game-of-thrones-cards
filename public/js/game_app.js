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

	onShow:function(){
		console.log('done');

		this.$el.parent().trigger('create');
	}
});


var HousesView = Marionette.ItemView.extend({
	template:'#houses_template',
	tagName:'table',
	className:'table',
	
	onShow:function() {
		// this.$el.listview().listview('refresh');
		this.$el.parent().trigger('create');
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
		'click .btn-back' : ''
	},

	doCreateGame:function(){
		console.log('create');

		var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		var hash = '';
		for( var i=0; i < 4; i++ ) {
			hash += possible.charAt(Math.floor(Math.random() * possible.length));
		}
		console.log('hash:'+hash);
		var game = new GameModel();

		game.save({}, {
			url:'/ui/games',
			data:JSON.stringify({ "name": hash }),
			success:function(){
				console.log('saved');
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


	},

	onRender:function(){
		this.main.show( new GamesView({collection:this.collection}));
		// this.ui.header.parent().trigger('create');
	},

	onShow:function(){
		// console.log(this.$el);
		// this.ui.header.trigger('create');
		// this.$el.trigger('create');
		// this.$el.prepend("<div data-role=\"header\">hi</div>");
		// this.$el.trigger('create');
	},

	allGames:function() {
		this.main.show( new GamesView({collection:this.collection}));
		this.ui.nav.find("#game").remove();
	},

	joinGame:function(game) {
		this.main.show(new HousesView({model:this.collection.get(game)}));
		// this.main.$el.find('div[data-role="collapsible-set"]').collapsibleset('refresh');
		$('<li></li>')
			.addClass('active')
			.attr('id', 'game')
			.html("<a href='#'>"+game+"</a>")
			.appendTo(this.ui.nav);
		this.ui.nav.find('#allgames').removeClass('active');
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



