module PwaHelper
  def manifest_object
    {
      "name": "MenuMate",
      "icons": [
        {
          "src": asset_path("favicon/web-app-manifest-512x512.png"),
          "type": "image/png",
          "sizes": "512x512"
        },
        {
          "src": asset_path("favicon/web-app-manifest-512x512.png"),
          "type": "image/png",
          "sizes": "512x512",
          "purpose": "maskable"
        }
      ],
      "start_url": "/",
      "display": "standalone",
      "scope": "/",
      "description": "Recipe book and menu randomiser",
      "theme_color": "#fafafa",
      "background_color": "#fafafa"
    }
  end
end
