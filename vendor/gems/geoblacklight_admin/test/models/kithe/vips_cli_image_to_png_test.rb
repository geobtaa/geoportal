# frozen_string_literal: true

require "test_helper"
require "tempfile"
require "tty/command"

module Kithe
  class VipsCliImageToPngTest < ActiveSupport::TestCase
    setup do
      @test_image = Tempfile.new(["test_image", ".jpg"])
      @test_image.write("fake image content") # Simulate image content
      @test_image.rewind
    end

    teardown do
      @test_image.close
      @test_image.unlink
    end

    test "initializes with max_width, png_compression, and thumbnail_mode" do
      converter = VipsCliImageToPng.new(max_width: 100, png_compression: 2, thumbnail_mode: true)
      assert_equal 100, converter.max_width
      assert_equal 2, converter.png_compression
      assert converter.send(:thumbnail_mode?)
    end

    test "raises error if thumbnail_mode is true and max_width is nil" do
      assert_raises(ArgumentError) do
        VipsCliImageToPng.new(thumbnail_mode: true)
      end
    end

    test "call method creates a PNG with vipsthumbnail when max_width is provided" do
      converter = VipsCliImageToPng.new(max_width: 100, thumbnail_mode: true)

      # Stubbing TTY::Command#run using method replacement
      TTY::Command.class_eval do
        alias_method :original_run, :run
        define_method(:run) do |*_args|
          # No-op to prevent actual command execution
        end
      end

      output_file = converter.call(@test_image)

      assert_instance_of Tempfile, output_file
      assert_match(/\.png\z/, output_file.path)

      # Restore the original method
      TTY::Command.class_eval do
        alias_method :run, :original_run
      end
    end

    test "call method creates a PNG with vips copy when max_width is not provided" do
      converter = VipsCliImageToPng.new(max_width: nil)

      # Stubbing TTY::Command#run using method replacement
      TTY::Command.class_eval do
        alias_method :original_run, :run
        define_method(:run) do |*_args|
          # No-op to prevent actual command execution
        end
      end

      output_file = converter.call(@test_image)

      assert_instance_of Tempfile, output_file
      assert_match(/\.png\z/, output_file.path)

      # Restore the original method
      TTY::Command.class_eval do
        alias_method :run, :original_run
      end
    end

    test "maybe_profile_normalization_args returns correct arguments in thumbnail_mode" do
      converter = VipsCliImageToPng.new(max_width: 100, thumbnail_mode: true)
      expected_args = ["--eprofile", Kithe::VipsCliImageToPng.srgb_profile_path, "--delete"]
      assert_equal expected_args, converter.send(:maybe_profile_normalization_args)
    end

    test "maybe_profile_normalization_args returns empty array when not in thumbnail_mode" do
      converter = VipsCliImageToPng.new(max_width: 100, thumbnail_mode: false)
      assert_empty converter.send(:maybe_profile_normalization_args)
    end

    test "vips_png_params returns correct parameters in thumbnail_mode" do
      converter = VipsCliImageToPng.new(max_width: 100, png_compression: 3, thumbnail_mode: true)
      assert_equal "[compression=3,interlace,strip]", converter.send(:vips_png_params)
    end

    test "vips_png_params returns correct parameters when not in thumbnail_mode" do
      converter = VipsCliImageToPng.new(max_width: 100, png_compression: 3, thumbnail_mode: false)
      assert_equal "[compression=3,interlace]", converter.send(:vips_png_params)
    end
  end
end
