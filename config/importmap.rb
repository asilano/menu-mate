# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "@hotwired--turbo-rails.js" # @8.0.12
pin "@hotwired/turbo", to: "@hotwired--turbo.js" # @8.0.12
pin "@rails/actioncable/src", to: "@rails--actioncable--src.js" # @7.2.201
pin "@fortawesome/fontawesome-free/js/all", to: "@fortawesome--fontawesome-free--js--all.js" # @6.7.2
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/actions", under: "actions"
