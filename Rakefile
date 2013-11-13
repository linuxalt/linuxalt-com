desc 'Tidy up HTML'
task :tidy do
  sh 'find _deploy -name "*.html" -exec tidy -config _conf/tidy.conf {} \;'
end
