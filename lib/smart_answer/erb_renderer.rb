module SmartAnswer
  class ErbRenderer
    module QuestionOptionsHelper
      def options(options = nil)
        if options
          @options = options
        else
          @options || {}
        end
      end
    end

    module MediaEmbedHelper
      def render_govspeak(content = "", &block)
        content = capture(&block) if block_given?

        # might need to strip leading spaces?

        # components are not in the lookup context which would need resolving
        render "govuk_publishing_components/components/govspeak" do
          raw(Govspeak::Document.new(content, sanitize: false).to_html) # rubocop:disable Rails/OutputSafety
        end
      end

      def govspeak_content_for(key, content = nil, &block)
        content = capture(&block) if block_given?

        content_for(key, render_govspeak(content))
      end

      # can probably alias this method
      def html_content_for(key, content = nil, &block)
        content_for(key, content, &block)
      end

      def text_content_for(key, content = nil, &block)
        # might need to normalize blank lines?
        content_for(key, content, &block)
      end
    end

    def initialize(template_directory:, template_name:, locals: {}, helpers: [])
      @template_directory = template_directory
      @template_name = template_name
      @locals = locals
      # This is used to include the Rails rendering paths in the lookup context
      # not sure if there is a better way to do this
      default_view_paths = ActionController::Base.view_paths.paths.map(&:to_s)
      lookup_context = ActionView::LookupContext.new(
        [@template_directory, FlowRegistry.instance.load_path] + default_view_paths
      )
      @view = ActionView::Base.with_empty_template_cache.new(lookup_context)
      helpers.each { |helper| @view.extend(helper) }
      @view.extend(QuestionOptionsHelper)
      @view.extend(MediaEmbedHelper)
    end

    def single_line_of_content_for(key)
      content_for(key, html: false).chomp.html_safe
    end

    def content_for(key, html: true)
      # content = rendered_view.content_for(key) || ""
      # content = strip_leading_spaces(content.to_str)
      # html ? GovspeakPresenter.new(content).html : normalize_blank_lines(content).html_safe
      rendered_view.content_for(key) || ""
    end

    def option_text(key)
      rendered_view
      @view.options.fetch(key).html_safe
    end

    def erb_template_path
      @template_directory.join(erb_template_name)
    end

    def relative_erb_template_path
      erb_template_path.relative_path_from(Rails.root).to_s
    end

  private

    def erb_template_name
      "#{@template_name}.govspeak.erb"
    end

    def rendered_view
      @rendered_view ||= @view.tap do |view|
        view.render(template: erb_template_name, locals: @locals)
      end
    end

    def strip_leading_spaces(string)
      string.gsub(/^ +/, "")
    end

    def normalize_blank_lines(string)
      string.gsub(/(\n$){2,}/m, "\n")
    end
  end
end
