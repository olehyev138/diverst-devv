$(document).on('ready page:load', function(){
  $('.flippable .back').hide();

  var images = $(".flippable .front > img");
  var loadedImgNum = 0;
  images.on('load', function(){
    loadedImgNum += 1;
    if (loadedImgNum == images.length) {
      $('.flippable .back').show();
      applyFlip();
    }
  });

  $(".flippable .front > svg").each(function() {
    $('.flippable .back').show();
    applyFlip();
  })

  function applyFlip() {
    var flippableOptions = {
      trigger: 'hover'
    };
    // Before applying flip, we need to manually set height of each element.
    // More could be found here:
    // http://stackoverflow.com/questions/39552827/jquery-flip-elements-overlapping-subsequent-elements
    $('.flippable').each(function(index){
      var $front = $(this).find('.front');
      var frontHeight = $front.find('img, svg').height();
      var backHeight = $(this).find('.back').height();
      var biggerHeight = frontHeight > backHeight ? frontHeight : backHeight;

      // Only apply flip if front element contains anything
      if($front.html().trim() ) {
        $(this).flip(flippableOptions).height(biggerHeight);
        $(this).on('flip:done', function(event) {
          if($(this).data('flip-once')) {
            $(this).off('.flip');
            $(this).flip(true, { trigger: 'manual' });
          }
        });
      }
    });//endof each
  };
});
