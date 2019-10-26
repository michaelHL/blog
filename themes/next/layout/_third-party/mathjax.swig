{% if theme.mathjax.enable %}
  {% if not theme.mathjax.per_page or (page.total or page.mathjax) %}
    <script type="text/x-mathjax-config">
      MathJax.Hub.Config({
        showProcessingMessages: false,
        messageStyle: "none",
        tex2jax: {
          inlineMath: [ ['$','$'], ["\\(","\\)"] ],
          displayMath: [ ['$$', '$$'], ["\\[", "\\]"] ],
          processEscapes: true,
          skipTags: ['script', 'noscript', 'style', 'textarea', 'pre', 'code']
        },
        CommonHTML: {
          scale: 90
        },
        "HTML-CSS": {
          scale: 90
        },
        SVG: {
          scale: 90
        },
        TeX: {
          equationNumbers: {
            autoNumber: 'AMS'
          },
          extensions: ["AMSmath.js", "AMSsymbols.js", "autobold.js"]
        }
      });
    </script>

    <script type="text/x-mathjax-config">
      MathJax.Hub.Queue(function() {
        var all = MathJax.Hub.getAllJax(), i;
        for (i=0; i < all.length; i += 1) {
          all[i].SourceElement().parentNode.className += ' has-jax';
        }
      });
    </script>
    <script type="text/javascript" src="https://cdn.bootcss.com/mathjax/2.7.6/MathJax.js?config=TeX-MML-AM_CHTML"></script>
    <!-- <script type="text/javascript" src="{{ theme.mathjax.cdn }}"></script> -->
  {% endif %}
{% endif %}
