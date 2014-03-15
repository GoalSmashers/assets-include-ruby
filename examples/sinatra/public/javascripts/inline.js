(function() {
  var label = 'This content via an inline script in production mode (<script> in development)';

  document.addEventListener('DOMContentLoaded', function() {
    document.querySelector('.js-inline-placeholder').innerText = label;
  }, false);
})();
