require 'rubygems'
require 'bundler/setup'

require 'json'
require 'logger'
require 'kafka'
require 'active_support/all'

require_relative 'stego/configure'
require_relative 'stego/ast'
require_relative 'stego/listener'
require_relative 'stego/producer'
require_relative 'stego/supervisor'
require_relative 'stego/bus_controller'

module Stego
  @@shutdown_pending = false

  def self.configure(&blk)
    blk.call(Configuration.instance)
  end

  def self.shutdown!
    puts "\nGracefull shutdown started (finishing current job before shutting down)."

    @@shutdown_pending = true
    Listener.stop_all
  end

  def self.shutdown_pending?
    @@shutdown_pending
  end

  def self.config
    Configuration.instance
  end
end
