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
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require jquery.Jcrop.min
//= require jquery.endless-scroll
//= require bootstrap-datepicker
//= require bootstrap-timepicker
//= require plupload.full.min
//= require moment-with-langs.min
//= require bootstrap-maxlength.min


startLoading = function() {
	$('.loading-overlay').show();
};

stopLoading = function() {
	$('.loading-overlay').hide();
};	