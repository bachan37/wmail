// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){
  $(".wmail-folder-link").live("click", function(){
    $("a.wmail-folder-link.wmail-selected-label").removeClass("wmail-selected-label");
    $(this).addClass("wmail-selected-label");
  });
})