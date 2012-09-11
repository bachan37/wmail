// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require_tree .

$(document).ready(function(){
  var loader = '<div class="wmail-ajax-loader"><img src="/assets/wmail/ajax-loader.gif" /></div>'

  /*Add loading image to remote calls for mailboxes*/
  $('.wmail-mailbox-list a, .wmail-mails-prev, .wmail-mails-next, .wmail-subject a').live('ajax:beforeSend', function(){
    $('.wmail-mailbox').html(loader);
  });
});