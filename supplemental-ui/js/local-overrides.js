
// Override the 0.1.8/0.1.9 query string implementation
document.addEventListener('DOMContentLoaded', function () {

    //Handle links
    var allQueryPramLinks = document.querySelectorAll('.query-params-link')
    if (allQueryPramLinks) {
      allQueryPramLinks.forEach(appendQueryStringToHref)
    }
  
    var pramLinks = document.querySelectorAll('.params-link')
    if (pramLinks) {
      pramLinks.forEach(appendQueryStringToHref)
    }
  
    var allNavLinks = document.querySelectorAll('.nav-link')
    if (allNavLinks) {
      allNavLinks.forEach(appendQueryStringToHref)
    }
  
    function appendQueryStringToHref(el) {
      var desiredQueryString = new URLSearchParams(window.location.search)
      var appendQueryString = el.classList.contains('query-params-link') ||
        el.classList.contains('nav-link')
  
      if (desiredQueryString.toString() && appendQueryString) {
        var hrefURL = new URL(el.href);
        for (var k of desiredQueryString.keys()) {
          hrefURL.searchParams.append(k, desiredQueryString.get(k));
        }
  
        el.href = hrefURL.toString();
      }
    }
  
    // refreshing links
  
    function replaceParamsInNodes(node, key, value) {
      if (node.parentElement) {
        //console.log('Parent element %s', node.parentElement.nodeName)
        if (node.parentElement.nodeName === 'code' ||
          node.parentElement.nodeName === 'CODE') {
          return
        }
      }
      if (node.nodeType === 3) {
        var text = node.data
        node.data = applyPattern(text, key, value)
      }
      if (node.nodeType === 1 && node.nodeName !== 'SCRIPT') {
        for (var i = 0; i < node.childNodes.length; i++) {
          replaceParamsInNodes(node.childNodes[i], key, value)
        }
  
        // handle link elements
        if (node.href) {
          node.href = applyPattern(node.href, key, value);
        }
      }
    }
  
    // If there are query parameters (searchparams) in the current window location then 
    // Iterate over all them replacing text and link-hrefs that contain them
    var params = new URLSearchParams(window.location.search);
    for (var k of params.keys()) {
      replaceParamsInNodes(document.body, k, params.get(k));
    }
  
    function applyPattern(str, key, value) {
      //(%25key%25|%key%) %25 is urlencode value of %
      var pattern = '(' + '%25' + key + '%25' +
        '|(?<!-)' + '%' + key + '%' + '(?!-))'
      var re = new RegExp(pattern, 'gi')
      return str.replace(re, value)
    }
  
  });