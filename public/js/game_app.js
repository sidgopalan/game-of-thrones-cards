var GameModel = Backbone.Model.extend({
	urlRoot:'/game',
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