var GameModel = Backbone.Model.extend({
	urlRoot:'/games',
	idAttribute: 'name',
});

var GamesCollection = Backbone.Collection.extend({
	url:'/games',
	model:GameModel,
});

var NavView = Marionette.ItemView.extend({
	template: '#nav_template',
	tagName:'div',
	ui:{
		btn_create:'button.btn-create',
	},

	events: {
		'click .btn-create' : 'doCreateGame',
	},

	doCreateGame:function(){
		console.log('create');
	},
});

var GameView = Marionette.ItemView.extend({
	template:'#game_template',
	tagName:'tr',
	ui:{
		name:'span.name',
	},
	onRender:function(){
		this.ui.name.html(this.model.get('name'));
	}
});

var GamesView = Marionette.CompositeView.extend({
	template: 'script#games_template',
	tagName:'table',
	className:'table',
	itemView: GameView,
	itemViewContainer:'tbody',

	initialize:function(options){
		console.log(options.collection);
	}
});