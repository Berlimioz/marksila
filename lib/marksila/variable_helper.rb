class Marksila::VariableHelper < ActionView::Base

  include ActionView::Helpers::TagHelper
  #include Elm::Rails::Helper

  attr_accessor :current_platform
  attr_accessor :current_site_partner
  attr_accessor :current_blog_path
  attr_accessor :current_user

  def initialize(platform)
    @current_platform = platform
  end

  def embed_financial_simulator
    content_tag(:div, id: "financialSimulator") do
      # TODO => TO BE FIXED WITH ELM COMPILATION BUG !!!
      javascript_pack_tag('financial_simulator')
    end
  end

  def render_twitter_feed(twitter_name,opts={})
    unless twitter_name.blank?

      data_options = " "
      opts.each do |key, val|
        data_options << "data-#{key}='#{val}' "
      end

      "<a class='twitter-timeline' #{data_options} href='https://twitter.com/#{twitter_name}'>Tweets by @#{twitter_name}</a> <script async defer src='//platform.twitter.com/widgets.js' charset='utf-8'></script>"
    end
  end

  def render_partner_twitter_feed(opts={})
    render_twitter_feed(current_site_partner.twitter, opts)
  end

  def render_platform_twitter_feed(opts={})
    render_twitter_feed(current_platform.twitter, opts)
  end

  def render_br(opts={})
    "<br/>"
  end

  def render_matterport_video(opts={})
    frame_opts_whitelist = opts.slice('url_params', 'width', 'height')
    if (url_params = frame_opts_whitelist['url_params']).present?
      frame_opts_whitelist[:src] = "https://my.matterport.com/webgl_player/?m=#{url_params}"
      "<iframe #{frame_opts_whitelist.select{|k,v| v.present?}.map{|k,v| "#{k}=#{v}" }.join(" ")} allowfullscreen></iframe>"
    end
  end

  def render_iframe(opts={})
    frame_opts_whitelist = opts.slice('src', 'width', 'height')
    "<iframe #{frame_opts_whitelist.map{|k,v| "#{k}=#{v}" }.join(" ")} sandbox></iframe>"
  end

  def render_img(opts={})
    content_tag(:img)
  end

  def render_blog_feed(opts={})
    if current_platform.platform_blog_posts.present?
      blog_title = content_tag(:div, class: 'blog-feed__title') do
        link_to Rails.application.routes.url_helpers.platform_blog_posts_path do
          current_platform.blog_title.present? ? current_platform.blog_title : t('sections.platform_blog_posts')
        end
      end

      articles_nb = opts.delete('article-limit').try(:to_i) || 3
      articles = current_platform.platform_blog_posts.can_be_published.not_on_test.order(published_at: :desc).limit(articles_nb)
      articles_div = content_tag(:div, class: 'blog-feed__articles') do
        articles.map{ |article| render_article(article) }.join(" ").html_safe
      end

      extra_styles =
        opts.map do |key, val|
          "#{key}:#{val};"
        end.join(" ")

      subscription_div =
        if opts['subscription'].present? || opts['subscription'] == 'enabled'
          if current_platform.donation_premium? || current_platform.volunteering?
            if current_user.present? && !current_user.flag_platform_blog_post_subscription || !current_user
              link_to t('platforms.blog.subscription'), Rails.application.routes.url_helpers.subscribe_blog_platform_path(current_platform), class: 'btn blog-feed__subscription-btn'
            else
              link_to t('platforms.blog.unsubscription'), Rails.application.routes.url_helpers.unsubscribe_blog_platform_path(current_platform), class: 'btn blog-feed__subscription-btn'
            end
          end
        end

      content_tag(:div, class: 'blog-feed', style: extra_styles) do
        blog_title + articles_div + subscription_div
      end
    else
      ""
    end
  end

  def render_article(article, opts={})
    article_image = content_tag(:div, class: "blog-feed__article-image") { image_tag article.image.url(secure: true), alt: article.title } if article.image.present?
    article_title = content_tag(:div, class: "blog-feed__article-title") { article.title }
    article_date = content_tag(:div, class: "blog-feed__article-date") { article.display_date }
    article_abstract = content_tag(:div, class: 'blog-feed__article-abstract') { article.abstract }

    article_info = content_tag(:div, class: "blog-feed__article-info") { article_title + article_date + article_abstract }

    link_to Rails.application.routes.url_helpers.platform_blog_post_path(article.permalink || article), class: 'blog-feed__article-link' do
      if article_image.present?
        content_tag(:div, class: "blog-feed__article") { article_image + article_info }
      else
        content_tag(:div, class: "blog-feed__article") { article_info }
      end
    end
  end

end
