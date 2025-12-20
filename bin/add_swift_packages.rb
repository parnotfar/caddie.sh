#!/usr/bin/env ruby
# frozen_string_literal: true

# Add local Swift Package dependencies to an Xcode project
# Usage: add_swift_packages.rb <project_path> <target_name> <package_path1> <product1> [<package_path2> <product2> ...]

require 'xcodeproj'

def add_swift_package(project, target, package_path, product_name)
  # Convert to absolute path if relative
  package_path = File.expand_path(package_path, File.dirname(project.path))
  
  unless File.directory?(package_path)
    $stderr.puts "Error: Package directory not found: #{package_path}"
    return false
  end

  # Initialize package_references if nil (for fresh Xcode projects)
  project.root_object.package_references ||= []
  
  # Check if package already exists
  existing_ref = project.root_object.package_references.find do |ref|
    ref.is_a?(Xcodeproj::Project::Object::XCLocalSwiftPackageReference) &&
      ref.relative_path == package_path
  end

  if existing_ref
    puts "Package already added: #{package_path}"
    package_ref = existing_ref
  else
    # Create local Swift package reference
    package_ref = project.new(Xcodeproj::Project::Object::XCLocalSwiftPackageReference)
    package_ref.relative_path = package_path
    
    # Add to root object's package references
    project.root_object.package_references << package_ref
    puts "Added package reference: #{package_path}"
  end

  # Initialize package_product_dependencies if nil (for fresh Xcode projects)
  target.package_product_dependencies ||= []
  
  # Check if product dependency already exists
  existing_product = target.package_product_dependencies.find do |dep|
    dep.product_name == product_name && dep.package == package_ref
  end

  if existing_product
    puts "Product dependency already added: #{product_name}"
    return true
  end

  # Create Swift package product dependency
  product_dep = project.new(Xcodeproj::Project::Object::XCSwiftPackageProductDependency)
  product_dep.package = package_ref
  product_dep.product_name = product_name

  # Add to target (already initialized above)
  target.package_product_dependencies << product_dep
  puts "Added product dependency: #{product_name}"

  true
rescue => e
  $stderr.puts "Error adding package #{package_path}: #{e.message}"
  false
end

# Parse arguments
if ARGV.length < 4 || ARGV.length.odd?
  $stderr.puts "Usage: #{$0} <project_path> <target_name> <package_path1> <product1> [<package_path2> <product2> ...]"
  $stderr.puts "Example: #{$0} vCaddie.xcodeproj vCaddie ../physics-core-swift PhysicsCore ../golf-agent-swift GolfSimulator"
  exit 1
end

project_path = ARGV[0]
target_name = ARGV[1]
packages = ARGV[2..-1].each_slice(2).to_a

# Open project
unless File.exist?(project_path)
  $stderr.puts "Error: Project not found: #{project_path}"
  exit 1
end

project = Xcodeproj::Project.open(project_path)

# Find target
target = project.targets.find { |t| t.name == target_name }
unless target
  $stderr.puts "Error: Target '#{target_name}' not found"
  $stderr.puts "Available targets: #{project.targets.map(&:name).join(', ')}"
  exit 1
end

# Add each package
failed_count = 0
packages.each do |package_path, product_name|
  if add_swift_package(project, target, package_path, product_name)
    # Save after each successful addition to persist progress
    project.save
  else
    failed_count += 1
  end
end

if failed_count == 0
  puts "\n✓ All packages added successfully!"
  puts "\nNext step: Run 'caddie swift:xcode:resolve' to resolve dependencies"
  exit 0
else
  $stderr.puts "\n✗ #{failed_count} package(s) failed to add"
  $stderr.puts "Successfully added packages have been saved to the project"
  exit 1
end
