/* Theme specific javascript */

/*THEME SWITCHER*/
  (function($){ 
    
    $(document).ready(function(){

      //initialize

      var theme_current = "current_theme_title"
      var themes = new Array();

      var description;
      var version;

      //Set current preview image and text
      $("#preview").find("img").attr("src","/images/site_assets/theme-previews/"+theme_current+".png")
      $("#preview span").text(theme_current);

      var index = 0;
        <% @themes.each do |theme| %>
          themes.push('<%= theme.title %>')
          description = '<%= theme.description %>'

          if(theme_current == 'current_theme_title') {
            $("#themeswitcher").append('<div class="theme_thumb selected" thm="'+index+'" ><div class="thumbnail" style="background-image: url(<%= theme["preview"] %>)"><div class="thumb_tooltip"><small><strong>'+themes[index]+':</strong><br/>'+description+'</small></div><img class="loader" src="/images/site_assets/theme-previews/ajax-load-32px.gif"/></div><a class="disabled" id="">Active</a></div>');
          } else {
            $("#themeswitcher").append('<div class="theme_thumb" thm="'+index+'" ><div class="thumbnail" style="background-image: url(<%= theme["preview"] %>)"><div class="thumb_tooltip"><small><strong>'+themes[index]+':</strong><br/>'+description+'</small></div><img class="loader" src="/images/site_assets/theme-previews/ajax-load-32px.gif"/></div><a class="" id="">Set Theme</a></div>');
          }
          index++;   
        <% end %>

      //Event handlers for theme changes
      var idClicked;
      var waiting = false;
      $(".theme_thumb").bind('click',function() {

        if(!$(this).hasClass("selected") && !waiting) {
          //reset other items

          $(".theme_thumb a").removeClass("disabled");
          $(".theme_thumb").removeClass("selected");
          $(".theme_thumb a").text("Set Theme");

          //prevent additional clicks until success
          waiting = true;

          //get thm="x" to index themes array
          idClicked = $(this).attr('thm')
          
          //do this to make it look pretty and like the new theme is being loaded
          //TODO: Put this into the AJAX call
          $(this).find(".loader").addClass('load');
          $(this).find("a").addClass("disabled");
          $(this).find("a").text("Setting...");
          $(this).addClass("selected");

          //perform action: change_theme via AJAX


          //on success, 
          //keep disabled class, -- 
          //change waiting to false; --
          //hide (remove '.load') '.loader' --
          //button text to 'Active' --
          
          //old link ***link_to "Set Theme", "update_theme/#{theme["title"]}", :method => :post **

          var loader = $(this).find(".loader");
          var button = $(this).find("a");
          var thumb  = $(this);

          $.ajax({
            type: ('POST'),
            url:  ('update_theme/'+themes[idClicked]),
            success: function(data){
              loader.removeClass('load');
              button.text("Active");
              $("#preview").queue(function() {
                $(this).find("span").fadeOut(100);
                $(this).find("img").fadeOut(100);
                $(this).dequeue();
              }).queue(function() {
                $(this).find("span").delay(200).text(themes[idClicked]) //TODO: HUMANIZE THIS
                $(this).find("img").delay(200).attr("src","/images/site_assets/theme-previews/"+themes[idClicked]+".png")
                $(this).dequeue();
              }).queue(function() {
                $(this).find("span").delay(500).slideDown('fast');
                $(this).find("img").delay(400).fadeIn('200')
                $(this).dequeue();
              })
              
              waiting = false
            },
            error: function() {
              alert("Theme could not be changed to "+themes[idClicked])
            }

          });
 

          //on fail
          //send alert "AJAX Fail" for now 

        }
        

      })


    })
    
  })(jQuery);