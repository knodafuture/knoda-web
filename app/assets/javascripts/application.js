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
//= require jquery.endless-scroll
//= require placeholders.jquery.min
//= require plupload.full.min
//= require moment-with-langs.min
//= require bootstrap-maxlength.min
//= require main


startLoading = function() {
	$('.loading-overlay').show();
};

stopLoading = function() {
	$('.loading-overlay').hide();
};	


var createPrediction;

createPrediction = function() {
  startLoading()
  return $.ajax({
    url: "/predictions.json",
    data: $('#new_prediction').serialize(),
    type: "POST",
    dataType: "json",
    success: function(json) {
      startLoading()
      return window.location.reload();
    },
    error: function(xhr, status) {
      return console.log("Sorry, there was a problem!");
    },
    complete: function(xhr, status) {
      return console.log("The request is complete!");
    }
  });
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
// Force recompile