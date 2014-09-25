// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require modernizr.custom
//= require console-polyfill
//= require date-polyfill
//= require time-polyfill
//= require lodash.min
//= require bootstrap.min
//= require jquery.Jcrop.min
//= require placeholders.jquery.min
//= require plupload.full.min
//= require moment-with-langs.min
//= require bootstrap-maxlength.min
//= require async
//= require predictions/create
//= require follow_button_view
// Force recompile

startLoading = function() {
	$('.loading-overlay').show();
};

stopLoading = function() {
	$('.loading-overlay').hide();
};

function getUrlVars()
{
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
};

$(function() {
  $('.full-height-content').height($(window).height() - 50)
	$('#createPredictionModal').on('show.bs.modal', function(e) {
		FlurryAgent.logEvent("CREATE_PREDICTION_START");
	});
	followButtonView = new FollowButtonView();
	$('.help-text').popover({
  	template: '<div class="popover help" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>'
	});
});

if (!Array.prototype.indexOf) {
  Array.prototype.indexOf = function(obj, start) {
       for (var i = (start || 0), j = this.length; i < j; i++) {
           if (this[i] === obj) { return i; }
       }
       return -1;
  }
}
