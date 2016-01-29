# coding: utf-8

require 'uri'
require 'rest-client'
require 'oj'

class Confluence
  def initialize(account, password, server_url)
    @account = account
    @password = password
    @server_url = server_url
  end

  def search_page(query)
    response = RestClient::Request.new(
      method: :get,
      url: page_search_url(query),
      user: @account,
      password: @password
    ).execute

    Oj.load(response)["results"].map do |item|
      {
        uid: "",
        title: remove_confluence_tag(item["title"]),
        body: remove_confluence_tag(item["bodyTextHighlights"]),
        url: URI.escape("#{@server_url}/#{item['url']}"),
        content_type: item["contentType"]
      }
    end
  end

  private

  def page_search_url(query)
    URI.escape("#{@server_url}/rest/searchv3/latest/search?queryString=#{query}&type=page")
  end

  def remove_confluence_tag(text)
    text.gsub("@@@hl@@@","").gsub("@@@endhl@@@", "") rescue ""
  end
end
