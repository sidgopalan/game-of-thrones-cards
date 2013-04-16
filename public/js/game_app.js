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
		name:'span.name',
	},
	events: {
		'click td' : 'selectGame',
	},
	onRender:function(){
		this.ui.name.html(this.model.get('name'));
	},
	selectGame:function(evt){
		var game = $(evt.target).closest('td').find('span.name').text();
		gotApp.vent.trigger('joingame', game);		
	},
});

var GamesView = Marionette.CompositeView.extend({
	template: 'script#games_template',
	tagName:'table',
	className:'table',
	itemView: GameView,
	itemViewContainer:'tbody',
});


var AppLayout = Marionette.Layout.extend({
	template : '#layout_template',

	regions:{
		nav:'#nav-region',
		main:'#main-region',
	},

	ui:{
		btn_create:'button.btn-create',
	},

	events: {
		'click .btn-create' : 'doCreateGame',
	},

	doCreateGame:function(){
		console.log('create');
	},

	initialize:function(options) {
		var self = this;
		gotApp.vent.on('joingame', function(game){
			console.log('joining game:'+game);
		});
	},

	onRender:function(){
		this.main.show( new GamesView({collection:this.collection}));
	},		
});





