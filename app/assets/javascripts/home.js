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
//= require lodash.min
//= require bootstrap.min
//= require placeholders.jquery.min
//= require jquery-scrollto
//= require prediction_slider
//= require home_view
// Force recompile

startLoading = function() {
  $('.loading-overlay').show();
};

stopLoading = function() {
  $('.loading-overlay').hide();
};

(function ($) {
$.fn.vAlign = function() {
  return this.each(function(i){
  var ah = $(this).height();
  var ph = $(this).parent().height();
  var mh = Math.ceil((ph-ah) / 2);
  console.log($(window).width());
  $(this).css('padding-top', mh);
  });
};
})(jQuery);