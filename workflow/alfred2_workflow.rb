# coding: utf-8

require "alfred"
require_relative 'confluence'

class Alfred2Workflow
  def execute(confluence_info)
    Alfred.with_friendly_error do |alfred|
      feedback = alfred.feedback
      query = utf8_argv.join(" ").strip

      if confluence_info.nil?
        alfred.with_rescue_feedback = true
        fail "wrong account or settings."
      else
        generate_feedback(feedback, confluence_info, query)
      end
    end
  end

  private

  def generate_feedback(feedback, confluence_info, query)
    # FIXME: https or http
    base_url = "https://#{confluence_info.server}/#{confluence_info.path}"
    confluence = Confluence.new(
      confluence_info.account,
      confluence_info.password,
      base_url
    )

    confluence.search_page(query).each do |item|
      feedback.add_item({
        uid: "",
        title: item[:title],
        subtitle: item[:body],
        arg: item[:url],
        valid: "yes"
      })
    end

    puts feedback.to_alfred
  end

  def utf8_argv
    ARGV.map { |v| v.dup.force_encoding("UTF-8") }
  end
end
