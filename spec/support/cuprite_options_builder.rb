# frozen_string_literal: true

class CupriteOptionsBuilder
  def self.for(driver)
    options_builder = new
    raise "Cuprite options for #{driver} not implemented" unless options_builder.respond_to?(driver.to_sym)
    options_builder.public_send(driver.to_sym)
  end

  def cuprite_chrome
    add_capybara_logging
    add_chromium_logging if save_browser_log

    @cuprite_options
  end

  private

  def initialize
    @cuprite_options = default_options
  end

  def default_options
    default_options = {
      timeout: 15,
      window_size: [1280, 2000],
      headless: headless,
      process_timeout: 60,
      flatten: false,
      browser_options: {
        "force-prefers-reduced-motion" => nil,
        "disable-search-engine-choice-screen" => nil,
        "disable-features" => "LensOverlay"
      }
    }

    if headless
      default_options[:browser_options]["no-sandbox"] = nil
      default_options[:browser_options]["disable-dev-shm-usage"] = nil
    end

    if save_browser_log
      # Enable Chrome process level logging: https://www.chromium.org/for-testers/enable-logging/
      default_options[:browser_options]["enable-logging"] = nil # Enable logging, but not just to stderr
      default_options[:browser_options]["v"] = "1"
      default_options[:browser_options]["log-level"] = "0"
    end

    default_options
  end

  def add_chromium_logging(postfix = nil)
    ENV["CHROME_LOG_FILE"] = log_path_for(
      # eg: chrome_debug or chrome_debug_mobile
      ["chrome_debug", postfix].compact.join("_")
    )
  end

  def add_capybara_logging(postfix = nil)
    @cuprite_options[:logger] = cuprite_logger_file(
      ["capybara", postfix].compact.join("_")
    )
  end

  def cuprite_logger_file(path)
    File.open(log_path_for(path), "w")
  end

  def log_path_for(topic)
    create_log_directory

    capybara_log_path.join("#{topic}.log")
  end

  def create_log_directory
    unless File.directory?(capybara_log_path)
      require "fileutils"
      FileUtils.mkdir_p(capybara_log_path)
    end
  end

  def capybara_log_path
    Rails.root.join("log", "capybara")
  end

  def save_browser_log
    ENV.key?("DEBUG")
  end

  def headless
    ENV["SHOW_BROWSER"] != "true"
  end
end
