# frozen_string_literal: true

require "test_helper"
require "fileutils"
require "zip"

class ZipFileGeneratorTest < ActiveSupport::TestCase
  setup do
    # Create a temporary directory for testing
    @input_dir = Dir.mktmpdir("zip_test_input")
    @output_file = File.join(Dir.tmpdir, "test_output.zip")

    # Create some test files and directories
    File.write(File.join(@input_dir, "file1.txt"), "Content of file 1")
    File.write(File.join(@input_dir, "file2.txt"), "Content of file 2")

    # Create a subdirectory with a file
    sub_dir = File.join(@input_dir, "subdir")
    FileUtils.mkdir_p(sub_dir)
    File.write(File.join(sub_dir, "file3.txt"), "Content of file 3")

    @zip_generator = ZipFileGenerator.new(@input_dir, @output_file)
  end

  teardown do
    # Cleanup: Remove the temporary files and directories after each test
    FileUtils.remove_entry(@input_dir) if File.directory?(@input_dir)
    File.delete(@output_file) if File.exist?(@output_file)
  end

  test "should create a zip file from a directory" do
    @zip_generator.write

    assert File.exist?(@output_file), "Expected zip file to be created"

    # Verify the contents of the zip file
    ::Zip::File.open(@output_file) do |zipfile|
      assert_includes zipfile.entries.map(&:name), "file1.txt"
      assert_includes zipfile.entries.map(&:name), "file2.txt"
      assert_includes zipfile.entries.map(&:name), "subdir/file3.txt"
    end
  end

  test "should include all files and subdirectories in the zip file" do
    @zip_generator.write

    # Check the files in the zip
    ::Zip::File.open(@output_file) do |zipfile|
      expected_files = ["file1.txt", "file2.txt", "subdir/", "subdir/file3.txt"]
      actual_files = zipfile.entries.map(&:name)

      expected_files.each do |file|
        assert_includes actual_files, file, "Expected #{file} to be included in the zip file"
      end
    end
  end

  test "should create directories in the zip file" do
    @zip_generator.write

    # Check that directories are included as empty entries in the zip file
    ::Zip::File.open(@output_file) do |zipfile|
      assert zipfile.entries.any? { |entry| entry.name == "subdir/" && entry.directory? }, "Expected 'subdir/' to be a directory in the zip file"
    end
  end

  test "should handle empty directories" do
    # Create an empty subdirectory
    empty_subdir = File.join(@input_dir, "empty_dir")
    FileUtils.mkdir_p(empty_subdir)

    @zip_generator.write

    # Check that the empty directory is included in the zip
    ::Zip::File.open(@output_file) do |zipfile|
      assert zipfile.entries.any? { |entry| entry.name == "empty_dir/" && entry.directory? }, "Expected 'empty_dir/' to be a directory in the zip file"
    end
  end

  test "should not include parent directories in the zip file" do
    @zip_generator.write

    # Verify that the zip file does not include parent directory paths
    ::Zip::File.open(@output_file) do |zipfile|
      refute zipfile.entries.any? { |entry| entry.name.include?(@input_dir) }, "Expected no parent directories to be included in the zip file"
    end
  end
end
