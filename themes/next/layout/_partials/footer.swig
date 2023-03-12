<div class="copyright" >
  {% set current = date(Date.now(), "YYYY") %}
  &copy; {% if theme.since and theme.since != current %} {{ theme.since }} - {% endif %}
  <span itemprop="copyrightYear">{{ current }}</span>
  <span class="with-love">
    <i class="fa fa-{{ theme.authoricon }}"></i>
  </span>
  <span class="author" itemprop="copyrightHolder">{{ config.author }}</span>

  <div class="theme-info">
    <div class="powered-by"></div>
    <span class="post-count">码了&nbsp;&nbsp{{ totalcount(site) }}&nbsp;&nbsp;个字</span>
  </div>

  {% if theme.busuanzi_count.enable %}
  <div class="theme-info">
    <div class="powered-by"></div>
    <script async src="https://busuanzi.ibruce.info/busuanzi/2.3/busuanzi.pure.mini.js"></script>

    {% if theme.busuanzi_count.site_uv %}
      <span class="site-uv">
        {{ theme.busuanzi_count.site_uv_header }}
        <span class="busuanzi-value" id="busuanzi_value_site_uv"></span>
        {{ theme.busuanzi_count.site_uv_footer }}
      </span>
    {% endif %}

    {% if theme.busuanzi_count.site_pv %}
      <span class="site-pv">
        {{ theme.busuanzi_count.site_pv_header }}
        <span class="busuanzi-value" id="busuanzi_value_site_pv"></span>
          {{ theme.busuanzi_count.site_pv_footer }}
      </span>
    {% endif %}
  </div>
  {% endif %}
</div>

{% if theme.copyright %}
<div class="powered-by">
  {{ __('footer.powered', '<a class="theme-link" href="https://hexo.io" rel="external nofollow">Hexo</a>') }}
</div>
{% endif %}

<div class="theme-info">
  {{ __('footer.theme') }} -
  <a class="theme-link" href="https://theme-next.iissnan.com/" rel="external nofollow">
    NexT.{{ theme.scheme }}
  </a>
</div>

