Then 'the javascript expression "$expression" should return "$result"' do |expression, result|
  page.evaluate_script(expression).to_s.should == result
end
