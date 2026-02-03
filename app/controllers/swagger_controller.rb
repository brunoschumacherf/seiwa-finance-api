class SwaggerController < ApplicationController
  def index
    render html: swagger_ui_html.html_safe
  end

  def spec
    send_file Rails.root.join('swagger', 'v1', 'swagger.yaml'), 
              type: 'application/yaml', 
              disposition: 'inline'
  end

  private

  def swagger_ui_html
    <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
          <title>Seiwa Finance API - Swagger UI</title>
          <link rel="stylesheet" type="text/css" href="https://unpkg.com/swagger-ui-dist@5.9.0/swagger-ui.css" />
          <style>
            html { box-sizing: border-box; overflow: -moz-scrollbars-vertical; overflow-y: scroll; }
            *, *:before, *:after { box-sizing: inherit; }
            body { margin:0; background: #fafafa; }
          </style>
        </head>
        <body>
          <div id="swagger-ui"></div>
          <script src="https://unpkg.com/swagger-ui-dist@5.9.0/swagger-ui-bundle.js"></script>
          <script src="https://unpkg.com/swagger-ui-dist@5.9.0/swagger-ui-standalone-preset.js"></script>
          <script>
            window.onload = function() {
              window.ui = SwaggerUIBundle({
                url: "/api-docs/v1/swagger.yaml",
                dom_id: '#swagger-ui',
                deepLinking: true,
                presets: [
                  SwaggerUIBundle.presets.apis,
                  SwaggerUIStandalonePreset
                ],
                plugins: [
                  SwaggerUIBundle.plugins.DownloadUrl
                ],
                layout: "StandaloneLayout"
              });
            };
          </script>
        </body>
      </html>
    HTML
  end
end
